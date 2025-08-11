package controllers;

class GolemController extends PlayerController {
	var prevController : PlayerController;
	
	public function new(p) {
		super(p);
		prevController = game.ctrl;
	}

	override function update(dt : Float) {
		if ( hxd.Key.isPressed(hxd.Key.E) ) {
			game.ctrl = prevController;
			return;
		}
		super.update(dt);
	}

	override function canChangeRoom() {
		return false;
	}

	override function canClimb() {
		return false;
	}

	override function canSecondaryTrigger() {
		return false;
	}
}