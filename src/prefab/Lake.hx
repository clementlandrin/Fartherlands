package prefab;

class LakeShader extends hxsl.Shader {

	static var SRC = {

		@global var global : {
			var time : Float;
			@perObject var modelViewInverse : Mat4;
		};

		@global var camera : {
			var inverseViewProj : Mat4;
		};

		var relativePosition : Vec3;
		var transformedPosition : Vec3;
		var projectedPosition : Vec4;
		var transformedNormal : Vec3;
		var pixelColor : Vec4;

		var metalness : Float;
		var roughness : Float;
		var occlusion : Float;
		var emissive : Float;

		@param var nearWaterColor : Vec3;
		@param var middleWaterColor : Vec3;
		@param var deepWaterColor: Vec3;
		@param var roughnessValue : Float;
		@param var opacityPower : Float;
		@param var maxDepth: Float;

		@param var colorNoiseTexture : Sampler2D;
		@param var colorNoiseScale : Float;
		@param var colorNoiseStrength : Float;

		@param var normalMap : Sampler2D;
		@param var waveIntensity : Float;
		@param var waveScale : Float;
		@param var waveSpeed : Float;
		@param var secondWaveScale : Float;
		@param var secondWaveRotate : Vec2;
		@param var secondWaveSpeed : Float;

		@global var depthMap : Channel;

		var output : {
			normal : Vec3,
		};

		function fragment() {
			var waveUVBase = relativePosition.xy;
			var waveUV = (waveUVBase + vec2(global.time * waveSpeed, 0.0)) * waveScale;
			var waveUV2 = (waveUVBase + vec2(global.time * secondWaveSpeed) * secondWaveRotate) * secondWaveScale;

			#if low_devices
			var prescaledNormal = unpackNormal(vec4(normalMap.get(waveUV).rgb, 1.0));
			#else
			var prescaledNormal = unpackNormal(vec4(normalMap.get(waveUV).rgb, 1.0)) + unpackNormal(vec4(normalMap.get(waveUV2).rgb, 1.0));
			#end
			prescaledNormal.xy *= waveIntensity;
			transformedNormal = prescaledNormal.normalize();

			var screenPos = projectedPosition.xy / projectedPosition.w;

			var depth = depthMap.get(screenToUv(screenPos));

			var ruv = vec4( screenPos, depth, 1 );
			var ppos = ruv * camera.inverseViewProj;
			var wpos = ppos.xyz / ppos.w;
			var waterDepth = distance(wpos.xyz, transformedPosition);
			#if low_devices
			var colorNoise = 0.0;
			#else
			var colorNoise = colorNoiseTexture.get(relativePosition.xy * colorNoiseScale).r;
			colorNoise *= colorNoiseStrength;
			#end

			var p0 = 0.0;
			var p1 = 0.6 + colorNoise ;
			var p2 = 1.0 + colorNoise;
			var t = saturate(1.0 - waterDepth / maxDepth);
			var waterColor = mix(deepWaterColor, mix(middleWaterColor, nearWaterColor, smoothstep(p1, p2, t)), smoothstep(p0, p1, t));

			pixelColor.rgb = waterColor;
			metalness = 0.0;
			roughness = roughnessValue;
			occlusion = 1.0;
			emissive = 0.0;
			output.normal = transformedNormal;

			var opacity = mix(0.2, 1.0, pow(1.0 - t, opacityPower));

			pixelColor.a = opacity;
		}
	}
}

class LakeMesh extends h3d.scene.Mesh {
	override function draw(ctx:h3d.scene.RenderContext) {
		super.draw(ctx);
		// cast(ctx.scene.renderer, gfx.Renderer).setEnabledSSR(true);
	}
}

class Lake extends hrt.prefab.l3d.Polygon {

	var lakeShader : LakeShader;

	@:s public var nearWaterColor : Int = 0xffffff;
	@:s public var middleWaterColor : Int = 0xffffff;
	@:s public var deepWaterColor : Int = 0xffffff;
	@:s public var roughness : Float = 0.0;
	@:s public var opacityPower : Float = 5.0;
	@:s public var maxDepth : Float = 5.0;

	@:s public var colorNoiseTexture : String = null;
	@:s public var colorNoiseScale : Float = 1.0;
	@:s public var colorNoiseStrength : Float = 1.0;

	@:s var normalMap : String = null;
	@:s var waveIntensity : Float = 1.0;
	@:s var waveScale : Float = 1.0;
	@:s var waveSpeed : Float = 1.0;
	@:s var secondWaveScale : Float;
	@:s var secondWaveRotate : Float;
	@:s var secondWaveSpeed : Float;

	@:s public var collide : Bool = true;

	override function makeObject( parent: h3d.scene.Object ) : h3d.scene.Object {
		#if editor
		hasDebugColor = false;
		#end
		var lo = new LakeMesh(null, parent);

		lo.material.mainPass.setPassName("decal");
		lo.material.mainPass.setBlendMode(Alpha);
		lo.material.mainPass.depthWrite = false;
		lo.material.castShadows = false;
		lo.material.receiveShadows = true;

		var depthPass = lo.material.allocPass("depthWrite", false);
		depthPass.depthWrite = true;
		depthPass.depthTest = Less;
		depthPass.addShader(lo.material.mainPass.getShader(h3d.shader.BaseMesh));

		lakeShader = new LakeShader();
		lo.material.mainPass.addShader(lakeShader);
		lo.material.mainPass.addShader(new h3d.shader.pbr.StrengthValues());

		return lo;
	}

	override function updateInstance(?propName : String ) {
		super.updateInstance(propName);

		if ( lakeShader != null ) {
			lakeShader.nearWaterColor = h3d.Vector.fromColor(nearWaterColor);
			lakeShader.middleWaterColor = h3d.Vector.fromColor(middleWaterColor);
			lakeShader.deepWaterColor = h3d.Vector.fromColor(deepWaterColor);
			lakeShader.roughnessValue = roughness;
			lakeShader.opacityPower = opacityPower;
			lakeShader.maxDepth = maxDepth;

			lakeShader.colorNoiseTexture = colorNoiseTexture != null ? shared.loadTexture(colorNoiseTexture) : h3d.mat.Texture.fromColor(0);
			lakeShader.colorNoiseTexture.wrap = Repeat;
			lakeShader.colorNoiseScale = colorNoiseScale;
			lakeShader.colorNoiseStrength = colorNoiseStrength;

			lakeShader.normalMap = normalMap != null ? shared.loadTexture(normalMap) : h3d.mat.Texture.fromColor(0x0000ff);
			lakeShader.normalMap.wrap = Repeat;
			lakeShader.waveIntensity = waveIntensity;
			lakeShader.waveScale = waveScale;
			lakeShader.waveSpeed = waveSpeed;
			lakeShader.secondWaveScale = secondWaveScale;
			lakeShader.secondWaveRotate.set(Math.cos(secondWaveRotate * Math.PI/180), Math.sin(secondWaveRotate * Math.PI/180));
			lakeShader.secondWaveSpeed = secondWaveSpeed;
		}
	}

	#if editor

	override function getHideProps() : hide.prefab.HideProps {
		return { icon : "square", name : "Lake" };
	}

	override function edit( ctx : hide.prefab.EditContext ) {
		super.edit(ctx);
		ctx.properties.add(new hide.Element('
			<div class="group" name="Color">
				<dl>
					<dt>Near Water Color </dt><dd><input type="color" field="nearWaterColor"/></dd>
					<dt>Middle Water Color</dt><dd><input type="color" field="middleWaterColor"/></dd>
					<dt>Deep Water Color</dt><dd><input type="color" field="deepWaterColor"/></dd>
					<dt>Roughness</dt><dd><input type="range" min="0" max="1" field="roughness"/></dd>
					<dt>Opacity Power</dt><dd><input type="range" min="0" max="5" field="opacityPower"/></dd>
					<dt>Lake max depth</dt><dd><input type="range" min="0" max="4" field="maxDepth"/></dd>
				</dl>
			</div>
			<div class="group" name="Color Noise">
				<dl>
					<dt>Texture</dt><dd><input type="texturepath" field="colorNoiseTexture"/></dd>
					<dt>Scale</dt><dd><input type="range" min="0" max ="1" step="0.01" field="colorNoiseScale"/></dd>
					<dt>Strength</dt><dd><input type="range" min="0" max ="1" step="0.01" field="colorNoiseStrength"/></dd>
				</dl>
			</div>
			<div class="group" name="Wave">
				<dl>
					<dt>NormalMap</dt><dd><input type="texturepath" field="normalMap"/></dd>
					<dt>Wave Intensity</dt><dd><input type="range" min="0" max="10" field="waveIntensity"/></dd>
					<dt>Wave Scale</dt><dd><input type="range" min="0" max="4" field="waveScale"/></dd>
					<dt>Wave Speed</dt><dd><input type="range" min="0" max="1" field="waveSpeed"/></dd>
					<dt>2d Wave Scale</dt><dd><input type="range" min="0" max="4" field="secondWaveScale"/></dd>
					<dt>2d Wave Rotate</dt><dd><input type="range" min="-180" max="180" field="secondWaveRotate"/></dd>
					<dt>2d Wave Speed</dt><dd><input type="range" min="0" max="1" field="secondWaveSpeed"/></dd>
				</dl>
			</div>
			<div class="group" name="Collisions">
				<dl>
					<dt>Collide WorldMap</dt><dd><input type="checkbox" field="collide"/></dd>
				</dl>
			</div>
			'), this, function(pname) {
				ctx.onChange(this, pname);
		});
	}

	#end

	static var _ = hrt.prefab.Prefab.register("Lake", Lake);
}