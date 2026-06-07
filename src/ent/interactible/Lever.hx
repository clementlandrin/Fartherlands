package ent.interactible;

class Lever extends Interactible {
	static var enableCount : Map<Data.ElementKind, Int> = [];
	static var disableCount : Map<Data.ElementKind, Int> = [];

	public function new() {
		super();
		activated = false;
	}

	override function start() {
		super.start();

		for (e in inf.enableOnActivate ?? []) {
			var obj3d = Std.downcast(Entity.get(e.refId), hrt.prefab.Object3D);
			obj3d?.local3d?.remove();

			var count = enableCount.get(e.refId);
			if (count != null)
				enableCount.set(e.refId, count + 1);
			else
				enableCount.set(e.refId, 1);
		}

		for (e in inf.disableOnActivate ?? []) {
			var count = disableCount.get(e.refId);
			if (count != null)
				disableCount.set(e.refId, count + 1);
			else
				disableCount.set(e.refId, 1);
		}
	}

	override function getTooltipText() {
		return 'Press F activate';
	}

	override function isInteractible() {
		return !activated;
	}

    override function onInteract(ctrl : controllers.PlayerController) {
        this.activated = true;
		for (e in inf.disableOnActivate ?? []) {
			var count = disableCount.get(e.refId);
			count--;
			disableCount.set(e.refId, count);
			if (count <= 0) {
				var obj3d = Std.downcast(Entity.get(e.refId), hrt.prefab.Object3D);
				obj3d?.local3d?.remove();
			}
		}

		for (e in inf.enableOnActivate ?? []) {
			var count = enableCount.get(e.refId);
			count--;
			enableCount.set(e.refId, count);
			if (count <= 0) {
				var obj3d = Std.downcast(Entity.get(e.refId), hrt.prefab.Object3D);
				obj3d?.make();
			}
		}
    }
}