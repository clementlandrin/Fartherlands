package actions;

class DropInto extends Action {

    public function new() {
        super(Primary);
    }

    override function fit(e : ent.Entity) {
        var chest = Std.downcast(e, ent.Chest);
        if ( chest == null )
            return false;
        if ( chest.item != null )
            return false;
        var i = e.game.player.item;
        if ( i == null )
            return false;
        return chest.filterItem(i);
    }

    override function onTrigger(e : ent.Entity) {
        super.onTrigger(e);
        e.pickItem(e.game.player.dropItem());
    }

    override function getActionText() {
        return "drop";
    }

    static var _ = Action.register(DropInto);
}