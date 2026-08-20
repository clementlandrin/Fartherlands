package gfx;
class Renderer extends h3d.scene.pbr.Renderer {
	#if !editor
	var game : Game;
	#end

	public function new(?env) {
		super(env);
		#if !editor
		game = Game.inst;
		#end
	}

	override function initGlobals() {
		super.initGlobals();

		#if !editor
		var player = game.player;
		ctx.setGlobal("playerPos", game.goddess.getTemporalPos());
		ctx.setGlobal("temporalRadius", game.goddess.getTemporalRadius());
		ctx.setGlobal("translucency", new h3d.Vector(0));
		#end
	}

	override function mark(id : String) {
		super.mark(id);
		#if !editor
		if (game!= null)
			game.measure(id);
		#end
	}

	override function end() {
		if (this.currentStep == Decals) {
			setTarget(textures.depth);
			renderPass(depthOutput, get("depthWrite"));
		}
		super.end();
	}
}
