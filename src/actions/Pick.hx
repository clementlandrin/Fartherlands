package actions;

class Pick extends Action {

    public function new() {
        super(Primary);
    }

    override function fit(e : ent.Entity) {
        return containsPickableItem(e) || isPickable(e);
    }

    function containsPickableItem(e : ent.Entity) {
        return e.game.player != e && e.item != null && e.item.isPickable();
    }

    function isPickable(e : ent.Entity) {
        return e.isPickable() && !e.isInEntity();
    }

    override function onTrigger(e : ent.Entity) {
        super.onTrigger(e);
        var i = null;
        if ( containsPickableItem(e) ) {
            i = e.item;
            e.dropItem();
        } else if ( isPickable(e) )
            i = e;
        e.game.player.pickItem(i);
    }

    override function getActionText() {
        return "pick";
    }

    static var _ = Action.register(Pick);
}