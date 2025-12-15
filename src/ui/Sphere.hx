package ui;

class Sphere extends Window {
	static var SRC =
	<sphere>
		<progress-bar id="gauge"/>
	</sphere>

	public function new(?parent) {
		super(parent);
		initComponent();
	}

	override function sync(ctx : h2d.RenderContext) {
		super.sync(ctx);
		gauge.value = 1 -  hxd.Math.clamp(Game.inst.goddess.getSphereRemainingTime() / Const.get(SphereMaxTime));
	}
}