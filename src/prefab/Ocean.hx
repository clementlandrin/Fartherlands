package prefab;

class OceanDepthShader extends hxsl.Shader {
	static var SRC = {

		var transformedNormal : Vec3;

		@global var global : {
			var time : Float;
		};

		@param var heightMap : Sampler2D;
		@param var terrainHeightScale : Float;
		@param var waveScale : Float;

		@param var speed : Float;
		@param var waveNumber : Float;
		@param var cosRot : Float;
		@param var sinRot : Float;
		@param var cosDir : Float;
		@param var sinDir : Float;
		@param var wavePersistence : Float;
		@param var waveLacunarity : Float;
		@param var waveCount : Int;
		@param var waveSteepness : Float;

		@param var fadeWavePower : Float;
		@param var fadeWaveRange : Float;

		var relativePosition : Vec3;
		var transformedPosition : Vec3;

		function computeGerstnerWaves(pos : Vec2, t : Float) : Vec3
		{
			var dir = vec2(cosDir, sinDir);

			var k = waveNumber;
			var c = sqrt(9.8 / k);
			var a = waveSteepness / k;

			var weight = 1.0;
			var w = vec3(0.0);
			var ws = 0.0;

			for ( i in 0...waveCount ) {
				dir = vec2((cosRot * dir.x) - (sinRot * dir.y), (sinRot * dir.x) + (cosRot * dir.y));

				var f = k * (dot(dir, pos) - t * c);
				var sinF = sin(f);
				var cosF = cos(f);

				var wave = vec3(pos, 0.0);
				wave.x += dir.x * a * cosF;
				wave.y += dir.y * a * cosF;
				wave.z = a * sinF;

				w += wave * weight;
				ws += weight;

				weight *= wavePersistence;
				k *= waveLacunarity;
				c = sqrt(9.8 / k);
			}

			return w/ws;
		}

		function vertex() {
			//var height = heightMap.get(relativePosition.xy).r * terrainHeightScale - transformedPosition.z;
			//var fadeFactor = smoothstep(0.0, 1.0, pow(saturate(-height / fadeWaveRange), fadeWavePower));
			var fadeFactor = 1.0;

			var gerstnerPos = computeGerstnerWaves( transformedPosition.xy,global.time * speed);
			gerstnerPos.z *= waveScale;
			gerstnerPos.z += transformedPosition.z;
			transformedPosition.xyz = mix(transformedPosition, gerstnerPos, fadeFactor);
		}

	}
}

class OceanShader extends hxsl.Shader {

	static var SRC = {

		@global var global : {
			var time : Float;
		};

		@global var camera : {
			var view : Mat4;
			var proj : Mat4;
			var position : Vec3;
			var projFlip : Float;
			var projDiag : Vec3;
			var viewProj : Mat4;
			var inverseViewProj : Mat4;
			var zNear : Float;
			var zFar : Float;
			@var var dir : Vec3;
		};

		var output : {
			var metalness : Float;
			var roughness : Float;
			var emissive : Float;
			var occlusion : Float;
		};

		var relativePosition : Vec3;
		var transformedPosition : Vec3;
		var projectedPosition : Vec4;
		var transformedNormal : Vec3;
		var pixelColor : Vec4;
		var pixelTransformedPosition : Vec3;
		var oceanUV : Vec2;

		@global var depthMap : Channel ;
		@param var heightMap : Sampler2D;
		@param var terrainHeightScale : Float;
		@param var waveScale : Float;

		@param var waterRoughness : Float;
		@param var colorGradient : Sampler2D;
		@param var depthFactor : Float;
		@param var colorNoiseTexture : Sampler2D;
		@param var colorNoiseScale : Float;
		@param var colorNoiseIntensity : Float;

		// Opacity
		@param var maxOpacityDepth : Float;
		@param var opacityPower : Float;
		@param var opacityFadeRange : Float;
		@param var opacityFadePower : Float;

		// Foam
		@param var foamTexture : Sampler2D;
		@param var foamColor : Vec4;
		@param var staticFoam : Float;
		@param var foamScale : Float;
		@param var foamStartRange : Float;
		@param var foamTrailRange : Float;
		@param var foamSpeed : Float;
		@param var foamTrailPower : Float;
		@param var foamAnticipationPower : Float;
		@param var foamAnticipationRange : Float;
		@param var foamNoiseTexture : Sampler2D;
		@param var foamNoiseTextureSize : Vec2;
		@param var foamNoiseScale : Float;
		@param var foamNoiseIntensity : Float;

		@param var fadeWavePower : Float;
		@param var fadeWaveRange : Float;

		var fadeFactor : Float;

		@param var speed : Float;
		@param var waveIntensity : Float;
		@param var waveNumber : Float;
		@param var cosRot : Float;
		@param var sinRot : Float;
		@param var cosDir : Float;
		@param var sinDir : Float;
		@param var waveDetails : Float;
		@param var wavePersistence : Float;
		@param var waveLacunarity : Float;
		@const var waveCount : Int;
		@param var waveSteepness : Float;
		@param var foamHeight : Float;
		@param var foamDetails : Float;

		@param var sunDir 			: Vec3;
		@param var sunColor			: Vec3;
		@param var sssPower 		: Float;
		@param var sssScale 		: Float;
		@param var sssDistortion 	: Float;
		@param var sssColor			: Vec3;

		@const var computeTrails	: Bool;
		@const var computeSSS : Bool;
		@const var computeShoreFoam : Bool;
		@const var useDepth : Bool;

		var gerstnerWave : {
			var position : Vec3;
			var averageHeight : Float;
			var averageFoam : Float;
			var normal : Vec3;
		};

		function map(value : Float, min1 : Float, max1 : Float, min2 : Float, max2 : Float) : Float {
			return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
		}

		function computeGerstnerWaves(pos : Vec2, t : Float) {
			var dir = vec2(cosDir, sinDir);

			var k = waveNumber;
			var c = sqrt(9.8 / k);
			var a = waveSteepness / k;

			var weight = 1.0;
			var w = vec3(0.0);
			var ws = 0.0;
			var foamWs = 0.0;
			var N = vec3(0.0);
			var averageHeight = 0.0;
			var averageFoam = 0.0;

			for ( i in 0...waveCount ) {
				dir = vec2((cosRot * dir.x) - (sinRot * dir.y), (sinRot * dir.x) + (cosRot * dir.y));

				var f = k * (dot(dir, pos) - t * c);
				var sinF = sin(f);
				var cosF = cos(f);

				var wave = vec3(pos, 0.0);
				wave.x += dir.x * a * cosF;
				wave.y += dir.y * a * cosF;
				averageFoam += saturate(sinF * weight / pow(weight, foamDetails));
				averageHeight += sinF * weight;
				wave.z = a * sinF;

				w += wave * weight;
				ws += weight;
				foamWs += (weight / pow(weight, foamDetails));

				var tangent = vec3(
					1.0 - dir.x * dir.x * waveSteepness * sinF,
					-dir.x * dir.y * waveSteepness * sinF,
					dir.x * waveSteepness * cosF
				);

				var binormal = vec3(
					-dir.x * dir.y * waveSteepness * sinF,
					1.0 - dir.y * dir.y * waveSteepness * sinF,
					dir.y * waveSteepness * cosF
				);

				var normal = normalize(cross(tangent, binormal));
				N += normal * weight / pow(weight, waveDetails);

				weight *= wavePersistence;
				k *= waveLacunarity;
				c = sqrt(9.8 / k);
			}
			N.xy *= waveIntensity;

			gerstnerWave.position = w/ws;
			gerstnerWave.averageFoam = averageFoam/foamWs;
			gerstnerWave.averageHeight = averageHeight/ws;
			gerstnerWave.normal = normalize(N);
		}

		function foamWave(height : Float, offset : Float) : Float {
			// 0 is the start of the wave foam, 1 shore
			var normalizedHeight = 1 + height/foamStartRange;

			// 0 to PI/2
			var sinTime = (global.time * foamSpeed + offset)%(3.14 / 2.0);

			// From 0 to 1 : 0 begin wave, 1 end wave
			var waveProgress = saturate(sin(sinTime));

			var alpha = saturate(1 - distance(normalizedHeight, waveProgress));

			// Foam fading based on range
			var range = (waveProgress < normalizedHeight ) ? foamAnticipationRange : foamTrailRange;
			var foamRangeFading = saturate(map(alpha, 1 - range, 1, 0, 1));

			// Foam intensity
			var foamPower = (waveProgress < normalizedHeight ) ? foamAnticipationPower : foamTrailPower;
			var foamIntensityCoeff = pow(alpha, foamPower);

			// Foam fading based on time
			var fadeTimeFading = sin(sinTime * 2.0);

			return foamRangeFading * foamIntensityCoeff * fadeTimeFading;
		}

		var posBeforeDisplacement : Vec3;
		function vertex() {
			posBeforeDisplacement = transformedPosition;
			//var height = heightMap.get(relativePosition.xy).r * terrainHeightScale - posBeforeDisplacement.z;
			//fadeFactor = smoothstep(0.0, 1.0, pow(saturate(-height / fadeWaveRange), fadeWavePower));
			fadeFactor = 1.0;

			computeGerstnerWaves(transformedPosition.xy, global.time * speed);
			gerstnerWave.position.z *= waveScale;
			gerstnerWave.position.z += posBeforeDisplacement.z;
			transformedPosition.xyz = mix(posBeforeDisplacement, gerstnerWave.position, fadeFactor);
		}

		function fragment() {
			computeGerstnerWaves(transformedPosition.xy, global.time * speed);
			transformedNormal = normalize(normalize(mix(vec3(0.0, 0.0, 1.0), gerstnerWave.normal, fadeFactor)));

			// Water opacity
			var screenPos = projectedPosition.xy / projectedPosition.w;
			var depth = depthMap.get( screenToUv(screenPos) ).r;
			var depthPpos = vec4( screenPos, depth, 1.0 ) * camera.inverseViewProj;
			var depthWpos = depthPpos.xyz / depthPpos.w;
			var waterDepth = depthWpos.z - posBeforeDisplacement.z;
			var opacityAlpha = smoothstep(0.0, 1.0, 1.0 + waterDepth / maxOpacityDepth);
			var opacityFactor = pow(1.0 - opacityAlpha, opacityPower);

			var height = (useDepth) ? waterDepth : heightMap.get(relativePosition.xy).r * terrainHeightScale - posBeforeDisplacement.z;

			// Color Noise
			var p0 = 0.0;
			var p1 = 0.5;
			var p2 = 1.0;
			var terrainDepth = ((-height)  / depthFactor).saturate();
			var colorNoise = (colorNoiseTexture.get(posBeforeDisplacement.xy * colorNoiseScale).r - 0.5) * 2.0;
			var f1 = clamp(1.0 - abs(((terrainDepth - p0) / (p1 - p0)) - 0.5) * 2.0, 0.0, 1.0);
			f1 *= f1;
			var f2 = clamp(1.0 - abs(((terrainDepth - p1) / (p2 - p1)) - 0.5) * 2.0, 0.0, 1.0);
			f2 *= f2;

			var t = saturate(terrainDepth + colorNoiseIntensity * colorNoise);
			var color = colorGradient.get(vec2(t, 0.0)).rgb;
			color *= color;

			var foamAmount = 0.0;
			if (computeShoreFoam) {
				// Foam Noise
				var fn = (foamNoiseTexture.get(posBeforeDisplacement.xy * foamNoiseScale).r);
				var fn10 = (foamNoiseTexture.get(posBeforeDisplacement.xy * foamNoiseScale + vec2(foamNoiseTextureSize.x, 0.0)).r);
				var fn01 = (foamNoiseTexture.get(posBeforeDisplacement.xy * foamNoiseScale + vec2(0.0, foamNoiseTextureSize.y)).r);
				var average = (fn + fn10 + fn01) / 3.0;
				var diff = abs(fn - average);
				var noiseAlpha = 1.0 - diff;
				noiseAlpha *= step(diff, 0.1);

				foamAmount = foamWave(waterDepth, fn * foamNoiseIntensity) + smoothstep(0.0, 1.0, 1.0 + waterDepth / foamStartRange) * staticFoam;
				var foamSample = foamTexture.get(transformedPosition.xy * foamScale).r;
				foamAmount *= foamSample * noiseAlpha;
			}

			var averageFoam = gerstnerWave.averageFoam;
			var foamFactor = saturate((step(foamHeight, averageFoam) / averageFoam) - 1);
			foamAmount += foamFactor * fadeFactor;
			foamAmount *= foamColor.a;

			color = mix(color, foamColor.rgb, foamAmount );
			pixelColor.rgb = color;

			// Fresnel
			var pixelToCamera = normalize(camera.position - transformedPosition);
			var fresnelFactor = pow((1.0 - saturate(dot(transformedNormal, pixelToCamera))), 3.0);
			opacityFactor = saturate(opacityFactor + fresnelFactor);

			// Keep the opaque on foam in
			opacityFactor = mix(opacityFactor, 1.0, foamAmount);

			// Opacity on shore
			var depthFade = pow(saturate((-height) / max(opacityFadeRange, 0.0001)), opacityFadePower);
			pixelColor.a = opacityFactor * depthFade;

			if (computeSSS) {
				var H = normalize(-sunDir + transformedNormal.rgb * sssDistortion);
				var sss = pow(saturate(dot(pixelToCamera, H)), sssPower) * sssScale;
				sss *= 1 - foamAmount;
				sss *= saturate(gerstnerWave.averageHeight);
				pixelColor.rgb += sunColor * sssColor * sss;
			}

			pixelColor.rgb = saturate(pixelColor.rgb);

			output.metalness = 0.0;
			output.roughness = mix(waterRoughness, 0.95, foamAmount);
			output.emissive = 0.0;
			output.occlusion = mix(1.0, .7, 1.0 - terrainDepth);
		}
	}
}

class OceanObject extends h3d.scene.Mesh {

	public var oceanPrefab : Ocean;
	public var os : OceanShader;
	public var osDepth : OceanDepthShader;

	override function sync(ctx) @:privateAccess {
		var sun	= cast( getScene().lightSystem.shadowLight, h3d.scene.pbr.DirLight);

		if (sun != null) {
			os.sunDir = sun.pbr.lightDir;
			os.sunColor = sun.pbr.lightColor;
			os.computeSSS = true;
		} else
			os.computeSSS = false;

		super.sync(ctx);
	}

	override function emit(ctx) {
		if( os.colorNoiseTexture == null ) return;
		if( os.foamNoiseTexture == null ) return;
		if( os.foamTexture == null ) return;
		super.emit(ctx);
	}

}

class BaseOcean extends hrt.prefab.Object3D {

	@:s var color : Dynamic;

	@:s var maxOpacityDepth: Float = 500.0;
	@:s var opacityPower : Float = 0.25;
	@:s var opacityFadeRange : Float = 5.0;
	@:s var opacityFadePower : Float = 0.5;

	@:s var depthFactor : Float;
	@:s var roughness : Float;

	@:s var colorNoiseTexture : String = null;
	@:s var colorNoiseScale : Float = 1.0;
	@:s var colorNoiseIntensity : Float = 0.2;

	@:s var speed : Float = 0.0;
	@:s var waveIntensity : Float = 1.0;

	@:s var computeShoreFoam : Bool = true;
	@:s var useDepth : Bool = false;
	@:s var foamTexture : String = null;
	@:s var foamColor : Int = 0xFFFFFFFF;
	@:s var staticFoam : Float = 0.0;
	@:s var foamScale : Float = 1.0;
	@:s var foamStartRange : Float = 5.0;
	@:s var foamSize : Float = 1.0;
	@:s var foamSpeed : Float = 1.0;
	@:s var foamTrailPower : Float = 15;
	@:s var foamTrailRange : Float = 0.2;
	@:s var foamAnticipationPower : Float = 15;
	@:s var foamAnticipationRange : Float = 1;
	@:s var foamHeight : Float = 0.3;
	@:s var foamDetails : Float = 0.8;

	@:s var foamNoiseIntensity : Float = 0.0;
	@:s var foamNoise : String = null;
	@:s var foamNoiseScale : Float = 1.0;

	@:s public var cellCount : Int = 1;

	@:s public var fadeWavePower : Float = 1.0;
	@:s public var fadeWaveRange : Float = 5.0;
	@:s public var waveLength : Float = 30;
	@:s public var waveCount : Int = 20;
	@:s public var waveDetails : Float = 0.55;
	@:s public var wavePersistence : Float = 0.8;
	@:s public var waveLacunarity : Float = 1.2;
	@:s public var waveSpeedMult : Float = 8.;
	@:s public var angleStep : Float = 12.0;
	@:s public var angleDir : Float = 0.0;
	@:s public var waveSteepness : Float = 0.5;
	@:s public var waveScale : Float = 1.27;

	@:s public var sssPower : Float;
	@:s public var sssScale : Float;
	@:s public var sssDistortion : Float;
	@:s public var sssColor : Int;

	var cosRot : Float;
	var sinRot : Float;
	var cosDir : Float;
	var sinDir : Float;

	var waveNumber(get, null) : Float;
	function get_waveNumber() {
		return 2.0 * Math.PI / waveLength;
	}

	override function updateInstance( ?propName : String ) {
		super.updateInstance(propName);
		var a = angleStep / 180.0 * Math.PI;
		var b = angleDir / 180.0 * Math.PI;
		cosRot = hxd.Math.cos(a);
		sinRot = hxd.Math.sin(a);
		cosDir = hxd.Math.cos(b);
		sinDir = hxd.Math.sin(b);
		// Hardcode limit to ensure performance.
		waveCount = waveCount > 40 ? 40 : waveCount;
	}

	function createBigPrimitive() {
		var cellCount : Int = cellCount;

		if (waveScale < 0.01) {
			cellCount = 1;
			waveScale = 0.0;
		}

		var vertexCount = cellCount + 1;
		var cellSize = 1.0 / cellCount;

		var prim = new h3d.prim.BigPrimitive(hxd.BufferFormat.POS3D.getCompressed());
		inline function addVertice( prim : h3d.prim.BigPrimitive, x : Float, y : Float, z : Float ) {
			prim.addPoint(x, y ,z);
		}

		prim.begin(0,0);
		// Vertices
		for( y in 0 ... vertexCount )
			for( x in 0 ... vertexCount )
				addVertice(prim, x * cellSize, y * cellSize, 0);

		// Indices
		for( y in 0 ... cellCount ) {
			for( x in 0 ... cellCount ) {
				var i = x + y * (vertexCount);
				prim.addIndex(i);
				prim.addIndex(i + 1);
				prim.addIndex(i + vertexCount + 1);

				prim.addIndex(i);
				prim.addIndex(i + vertexCount + 1);
				prim.addIndex(i + vertexCount);
			}
		}

		prim.flush();
		return prim;
	}

	inline function loadTexture(path : String ) : h3d.mat.Texture {
		if( path == null )
			return null;
		var t = hxd.res.Loader.currentInstance.load(path).toTexture();
		if( t != null )
			t.wrap = Repeat;
		return t;
	}

	function waveLengthToNumber() {
		return 2.0 * Math.PI / waveLength;
	}

	function updateMat( os : OceanShader, osDepth : OceanDepthShader ) {
		os.computeShoreFoam = computeShoreFoam;
		os.useDepth = useDepth;
		os.waterRoughness = roughness;

		if ( color != null ) {
			var colorG = hrt.impl.TextureType.Utils.getTextureFromValue(color);
			colorG.wrap = Clamp;
			os.colorGradient = colorG;
		} else {
			os.colorGradient = h3d.mat.Texture.fromColor(0xFFFFFF);
		}

		os.maxOpacityDepth = maxOpacityDepth;
		os.opacityPower = opacityPower;
		os.opacityFadeRange = opacityFadeRange;
		os.opacityFadePower = opacityFadePower;

		os.colorNoiseTexture = loadTexture(colorNoiseTexture);
		os.colorNoiseScale = colorNoiseScale;
		os.colorNoiseIntensity = colorNoiseIntensity;
		os.depthFactor = depthFactor;
		os.foamColor = h3d.Vector4.fromColor(foamColor);
		os.staticFoam = staticFoam;
		os.foamTexture = loadTexture(foamTexture);
		os.foamScale = foamScale;
		os.foamSpeed = foamSpeed;
		os.foamStartRange = foamStartRange;
		os.foamNoiseTexture = loadTexture(foamNoise);
		if( os.foamNoiseTexture != null )
			os.foamNoiseTextureSize.set(os.foamNoiseTexture.width, os.foamNoiseTexture.height);
		os.foamNoiseScale = foamNoiseScale;
		os.foamNoiseIntensity = foamNoiseIntensity / 10.0;
		os.foamTrailRange = foamTrailRange;
		os.foamTrailPower = foamTrailPower;
		os.foamAnticipationPower = foamAnticipationPower;
		os.foamAnticipationRange = foamAnticipationRange;

		os.fadeWavePower = osDepth.fadeWavePower =fadeWavePower;
		os.fadeWaveRange = osDepth.fadeWaveRange =fadeWaveRange;

		os.speed = osDepth.speed = speed;
		os.waveNumber = osDepth.waveNumber = waveNumber;
		os.cosRot = osDepth.cosRot = cosRot;
		os.sinRot = osDepth.sinRot = sinRot;
		os.cosDir = osDepth.cosDir = cosDir;
		os.sinDir = osDepth.sinDir = sinDir;
		os.waveDetails = waveDetails;
		os.wavePersistence = osDepth.wavePersistence = wavePersistence;
		os.waveLacunarity = osDepth.waveLacunarity = waveLacunarity;
		os.waveCount = osDepth.waveCount = waveCount;
		os.waveScale = osDepth.waveScale = waveScale;
		os.waveSteepness = osDepth.waveSteepness = waveSteepness;
		os.waveIntensity = waveIntensity;

		os.foamHeight = foamHeight;
		os.foamDetails = foamDetails;

		os.sssScale = sssScale;
		os.sssPower = sssPower;
		os.sssDistortion = sssDistortion;
		os.sssColor = h3d.Vector.fromColor(sssColor);
	}

	#if editor
	override function edit( ctx : hide.prefab.EditContext ) {
		super.edit(ctx);
		ctx.properties.add(new hide.Element('
			<div class="group" name="Color">
				<dl>
					<dt>Color</dt><dd><input type="texturechoice" field="color"/></dd>
					<dt>UseDepth</dt><dd> <input type="checkbox" field="useDepth"/></dd>
					<dt>Range</dt><dd><input type="range" min="0" max ="100" field="depthFactor"/></dd>
					<dt>Roughness</dt><dd><input type="range" min="0" max ="1" field="roughness"/></dd>
				</dl>
			</div>

			<div class="group" name="Color Noise">
				<dl>
					<dt>Texture</dt><dd><input type="texturepath" field="colorNoiseTexture"/></dd>
					<dt>Scale</dt><dd><input type="range" min="0" max ="1" step="0.01" field="colorNoiseScale"/></dd>
					<dt>Intensity</dt><dd><input type="range" min="0" max ="1" step="0.01" field="colorNoiseIntensity"/></dd>
				</dl>
			</div>

			<div class="group" name="Opacity">
				<dl>
					<dt>MaxDepth</dt><dd><input type="range" max="1000" field="maxOpacityDepth"/></dd>
					<dt>Power</dt><dd><input type="range" max="5" field="opacityPower"/></dd>
					<dt>FadeRange</dt><dd><input type="range" max="10" field="opacityFadeRange"/></dd>
					<dt>FadePower</dt><dd><input type="range" max="5" field="opacityFadePower"/></dd>
				</dl>
			</div>

			<div class="group" name="Wave">
				<dl>
					<dt>FadePower</dt><dd><input type="range" max="5" field="fadeWavePower"/></dd>
					<dt>FadeRange</dt><dd><input type="range" max="10" field="fadeWaveRange"/></dd>
					<dt>Speed</dt><dd><input type="range" min="0" max ="1" step="0.01" field="speed"/></dd>
					<dt>Persistence</dt><dd><input type="range" min="0" max="1" field="wavePersistence"/></dd>
					<dt>Lacunarity</dt><dd><input type="range" min="1" max="3" field="waveLacunarity"/></dd>
					<dt>Details</dt><dd><input type="range" min="0" max="1" field="waveDetails"/></dd>
					<dt>Length</dt><dd><input type="range" min="0" max="0.5" field="waveLength"/></dd>
					<dt>Direction</dt><dd><input type="range" min="0" max="360" field="angleDir"/></dd>
					<dt>Step angle</dt><dd><input type="range" min="0" max="360" field="angleStep"/></dd>
					<dt>Wave count</dt><dd><input type="range" min="0" max="40" step="1" field="waveCount"/></dd>
					<dt>Steepness</dt><dd><input type="range" min="0" max="1" step="0.01" field="waveSteepness"/></dd>
					<dt>Wave scale</dt><dd><input type="range" min="0" max="2" step="0.01" field="waveScale"/></dd>
					<dt>Normal intensity</dt><dd><input type="range" min="0" max ="1" field="waveIntensity"/></dd>
				</dl>
			</div>

			<div class="group" name="OceanFoam">
				<dl>
					<dt>Foam height</dt><dd><input type="range" step="0.01"  min="0.01" max ="1" field="foamHeight"/></dd>
					<dt>Foam details</dt><dd><input type="range" step="0.01"  min="0" max ="1" field="foamDetails"/></dd>
				</dl>
			</div>

			<div class="group" name="Shore Foam">
				<dl>
					<dt>Enable</dt><dd> <input type="checkbox" field="computeShoreFoam"/></dd>
					<dt>Color</dt><dd> <input type="color" alpha="true" field="foamColor"/></dd>
					<dt>Static foam</dt><dd> <input type="range" min="0" max ="1" step="0.01" field="staticFoam"/></dd>
					<dt>Texture</dt><dd> <input type="texturepath" field="foamTexture"/></dd>
					<dt>Scale</dt><dd> <input type="range" min="0" max ="1" step="0.01" field="foamScale"/></dd>
					<dt>Speed</dt><dd> <input type="range" min="0" max ="1" step="0.01" field="foamSpeed"/></dd>
					<dt>Start Range</dt><dd> <input type="range" min="0" max ="10"  field="foamStartRange"/></dd>
					<dt>Trail Power</dt><dd> <input type="range" min="1" max ="20" step="0.01" field="foamTrailPower"/></dd>
					<dt>Trail Range</dt><dd> <input type="range" min="0.01" max ="1" step="0.01" field="foamTrailRange"/></dd>
					<dt>Anticipation Power</dt><dd> <input type="range" min="1" max ="20" step="0.01" field="foamAnticipationPower"/></dd>
					<dt>Anticipation Range</dt><dd> <input type="range" min="0.01" max ="1" step="0.01" field="foamAnticipationRange"/></dd>
				</dl>
			</div>

			<div class="group" name="Shore Fade Noise">
				<dl>
					<dt>Texture</dt><dd><input type="texturepath" field="foamNoise"/></dd>
					<dt>Scale</dt><dd> <input type="range" min="0" max ="1" step="0.01" field="foamNoiseScale"/></dd>
					<dt>Intensity</dt><dd> <input type="range" min="0" max ="1" step="0.01" field="foamNoiseIntensity"/></dd>
				</dl>
			</div>

			<div class="group" name="Subsurface scattering">
				<dl>
					<dt>Power</dt><dd><input type="range" min"0" max "10" step="0.1" field="sssPower"/></dd>
					<dt>Scale</dt><dd> <input type="range" min="0" max ="100" step="0.1" field="sssScale"/></dd>
					<dt>Distortion</dt><dd> <input type="range" min="0" max ="1" step="0.01" field="sssDistortion"/></dd>
					<dt>Color</dt><dd> <input type="color" field="sssColor"/></dd>
				</dl>
			</div>

			<div class="group" name="Resolution">
				<dl>
					<dt>CellCount</dt><dd><input type="range" step="1"  min="1" max ="100" field="cellCount"/></dd>
				</dl>
			</div>
			'), this, function(pname) {
				ctx.onChange(this, pname);
		});
	}
	#end
}

@:access(prefab.OceanChunk)
class Ocean extends BaseOcean {

	var t : hrt.prefab.l3d.HeightMap = null;

	public var polygones(get, never) : Array<hrt.prefab.l3d.Polygon>;
	function get_polygones() {
		var polys : Array<hrt.prefab.l3d.Polygon> = [];
		for (c in children) {
			var p = c.to(hrt.prefab.l3d.Polygon);
			if (p != null) polys.push(p);
		}
		return polys;
	}

	override function makeObject(parent3d:h3d.scene.Object):h3d.scene.Object {
		var mesh = new OceanObject(null, parent3d);
		var os = new prefab.Ocean.OceanShader();
		mesh.os = os;
		mesh.oceanPrefab = this;

		var osDepth = new prefab.Ocean.OceanDepthShader();
		mesh.osDepth = osDepth;
		os.computeSSS = false;

		os.heightMap = osDepth.heightMap = h3d.mat.Texture.fromColor(0xFFFFFFFF);
		os.terrainHeightScale = osDepth.terrainHeightScale = -100.0;

		for( m in mesh.getMaterials() ) {
			m.mainPass.setPassName("decal");
			m.castShadows = false;
			m.mainPass.depthWrite = false;
			m.mainPass.setBlendMode(Alpha);

			m.mainPass.addShader(os);
			m.mainPass.addShader(new h3d.shader.pbr.StrengthValues());

			var depthPass = m.allocPass("depthWrite", false);
			depthPass.addShader(new h3d.shader.BaseMesh());
			depthPass.addShader(osDepth);
			depthPass.depthWrite = true;
			depthPass.depthTest = Less;

			m.castShadows = false;
		}

		return mesh;
	}

	override function updateInstance( ?propName : String ) {
		super.updateInstance(propName);

		var oceanObject : OceanObject = cast local3d;
		var os = oceanObject.os;
		var osDepth = oceanObject.osDepth;
		updateMat(os, osDepth);

		// Refresh the primitive
		if( propName == null || propName.indexOf("waveScale") >= 0 || propName.indexOf("cellCount") >= 0 || propName == "x" || propName == "y" || propName == "z" || propName == "scaleX" || propName == "scaleY" || propName == "scaleZ" ) {
			if( oceanObject.primitive != null )
				oceanObject.primitive.dispose();
			oceanObject.primitive = createBigPrimitive();
		}
	}

	#if editor
	override function getHideProps() : hide.prefab.HideProps {
		return { icon : "square", name : "Ocean" };
	}
	#end

	static var _ = hrt.prefab.Prefab.register("ocean", Ocean);
}