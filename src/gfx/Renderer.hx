package gfx;
class Renderer extends h3d.scene.pbr.Renderer {

	public var timeMode : Game.TimeMode;
	var game : Game;

	public function new(?env) {
		super(env);
		game = Game.inst;
	}

	override function initGlobals() {
		super.initGlobals();

		var player = game.player;
		ctx.setGlobal("playerPos", game.goddess.getTemporalPos());
		ctx.setGlobal("temporalRadius", game.goddess.getTemporalRadius());
		ctx.setGlobal("translucency", new h3d.Vector(0));
	}

	override function mark(id : String) {
		super.mark(id);
		#if !editor
		if(Game.inst != null)
			Game.inst.measure(id);
		#end
	}
}
