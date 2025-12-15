package ui.comp;

class ProgressBarShader extends hxsl.Shader {
	static var SRC = {
        @:import h3d.shader.Base2d;
        @param var value : Float = 0.;
        @param var gaugeColor : Vec3;

		function fragment() {
            pixelColor.rgb = gaugeColor;
			pixelColor.a *= input.uv.y < value ? 0 : 1;
		}
	}
}

@:uiComp("progress-bar")
class ProgressBar extends BaseElement {
    static var SRC = <progress-bar>
        <bitmap id="gauge"/>
    </progress-bar>

    public var value(default, set) : Float = 0;
    @:p(color) var gaugeColor(default, set) : Int = 0xD69B23;
    var shader = new ProgressBarShader();

	public function new(?parent) {
		super(parent);
		initComponent();

        gauge.addShader(shader);
        shader.gaugeColor.setColor(gaugeColor);

		enableInteractive = true;
		interactive.onClick = function (e:hxd.Event) {
			if ( e.button == 0 )
				onClick();
		};
	}

    function set_value(v : Float) {
        this.value = v;
        shader?.value = v;
        return value;
    }

    function set_gaugeColor(v : Int) {
        gaugeColor = v;
        shader?.gaugeColor.setColor(v);
		return v;
    }
}