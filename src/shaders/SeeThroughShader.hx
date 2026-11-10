package shaders;

class SeeThroughShader extends hxsl.Shader {

	static var SRC = {

		@param var color : Vec4;

		var pixelColor : Vec4;

		function fragment() {
			pixelColor = color;
		}

	};

}
