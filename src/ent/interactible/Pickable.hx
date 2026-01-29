package ent.interactible;

class Pickable extends Interactible {
<<<<<<< Updated upstream
	public var owner(get, null) : Entity;
	public function get_owner() {
		if (game.ctrl.item == this)
			return game.player;
		for (e in game.entities) {
			var chest = Std.downcast(e, Chest);
			if (chest == null)
				continue;

			if (chest.item == this)
				return chest;
		}
		return null;
	}

	override function update(dt : Float) {
		super.update(dt);
		var o = owner;
		if (o != null) {
			this.setPos(o.getPos());
			this.room = o.room;
		}
=======
	override function getTooltipText() {
		return 'Press F to pick';
>>>>>>> Stashed changes
	}

	override function onInteract(ctrl: controllers.PlayerController) {
		super.onInteract(ctrl);

		if (game.ctrl.item == null)
			pick();
		else
			drop();
	}

<<<<<<< Updated upstream
	override function isInteractible() {
		return super.isInteractible() && this.owner == null;
	}

	override function getTooltipText() {
		return 'Press F to pick';
	}

=======
>>>>>>> Stashed changes
	public function pick() {
		if (game.ctrl.item != null)
			return;
		game.ctrl.item = this;
<<<<<<< Updated upstream

=======
		this.dispose();
>>>>>>> Stashed changes
		onPicked();
	}

	public function drop() {
		if (game.ctrl.item == null)
			return;
		game.ctrl.item = null;
		
		onDropped();
	}

    public function onPicked() {}
	public function onDropped() {}
}