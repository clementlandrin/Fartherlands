package prefab;

class TemporalWindow extends hxsl.Shader {

	static var SRC = {

		@global var global : {
			var time : Float;
			@perObject var modelViewInverse : Mat4;
		};

		@global var camera : {
			var inverseViewProj : Mat4;
		};

		@global var depthMap : Channel;

		@const var GAMMA_CORRECT : Bool = true;
		@param var tex : Sampler2D;
		@param var depth : Sampler2D;

		@global var temporalRadius : Float;
		@global var playerPos : Vec3;

		@param var outColor : Vec3;
		@param var outAlpha : Float;

		var screenUV : Vec2;
		var pixelColor : Vec4;

		function fragment() {
			pixelColor = tex.get(screenUV);
			if ( GAMMA_CORRECT )
				pixelColor.rgb *= pixelColor.rgb;
			var curDepth = depthMap.get(screenUV);
			var pastDepth = depth.get(screenUV).r;
			if ( curDepth < pastDepth - 1e-2) // prevent some z fighting
				discard;

			var pastPPos = vec4(uvToScreen(screenUV), pastDepth, 1) * camera.inverseViewProj;
			var pastWPos = pastPPos.xyz / pastPPos.w;
			if (length(pastWPos - playerPos) > temporalRadius) { // outside sphere
				pixelColor *= outAlpha;
				pixelColor.rgb = outColor;
			}
		}
	}
}

class TemporalWindowShader extends hrt.prefab.Shader {

	override function makeShader() {
		return new TemporalWindow();
	}

	override function updateInstance(?propName) {
		super.updateInstance(propName);

		var sh = cast(shader, TemporalWindow);
		sh.tex = h3d.mat.Texture.fromColor(0xFF00FF);
	}

	#if editor
	override function edit( ctx : hide.prefab.EditContext ) {
		ctx.properties.add(new hide.Element('
		'),this, pname -> ctx.onChange(this, pname));
	}
	#end

	static var _ = hrt.prefab.Prefab.register("temporalWindow", TemporalWindowShader);
}