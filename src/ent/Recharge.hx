package ent;

class Recharge extends Entity {

	public function new() {
		super();
	}

	override function canInteract() {
        return false;
    }

	override function update(dt : Float) {
		super.update(dt);
		if ( enabled ) {
			var playerPos = new h3d.col.Point(game.player.x,game.player.y,game.player.z);
			if ( obj.getBounds().contains(playerPos) )
				recharge();
		}
	}

	function recharge() {
		game.goddess.resetSphereRemainingTime();
	}
}