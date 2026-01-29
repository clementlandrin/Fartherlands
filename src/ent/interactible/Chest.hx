package ent.interactible;

class Chest extends Interactible {
    public var item : Pickable = null;

    override function getTooltipText() {
		return item == null ? 'Press F to drop item' : 'Press F to pick item';
	}

    override function onInteract(ctrl : controllers.PlayerController) {
        if (ctrl.item != null && item == null) {
            item = ctrl.item;
            ctrl.item = null;
        }
        else if (item != null && ctrl.item == null) {
            ctrl.item = item;
            item = null;
        }
    }

    public function filterItem(i : ent.Entity) {
        return true;
    }
}