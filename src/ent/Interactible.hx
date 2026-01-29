package ent;

<<<<<<< Updated upstream
import ent.interactible.Pickable;
import controllers.PlayerController;

class Interactible extends Entity {
=======
import controllers.PlayerController;

class Interactible extends Entity {
    var interactive : h3d.scene.Interactive;
>>>>>>> Stashed changes

    override function update(dt : Float) {
		super.update(dt);

		var player = game.player;
		var goddess = game.goddess;
		var range = Const.get(InteractibleRadius);

		var i = player.getPos().distanceSq(getPos()) < range * range;
		if (i) {
			switch(timeMode) {
                case Common:
                case Past:
                    var r = goddess.getTemporalRadius();
                    i = getPos().distanceSq(goddess.getTemporalPos()) < r * r;
                case Present:
                    var r = goddess.getTemporalRadius();
                    i = getPos().distanceSq(goddess.getTemporalPos()) > r * r;
                case None:
                    throw "assert";
			}
		}
		if (i && isInteractible()) {
			onOver();
			if (game.ctrl.requestInteract || game.ctrl.requestSecondaryInteract)
				onInteract(game.ctrl);
		} else {
			onOut();
		}
	}

	override function getTooltipText() {
		return 'Press F to interact';
	}

    public function isInteractible() {
        return true;
    }

    public function onInteract(ctrl: PlayerController) {}
}