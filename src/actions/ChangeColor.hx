package actions;

class ChangeColor extends Action {

    public function new() {
        super(Primary);
    }

    override function fit(e : ent.Entity) {
        var t = Std.downcast(e, ent.Teleport);
        if ( t == null )
            return false;
        return t.isHub();
    }

    override function onTrigger(e : ent.Entity) {
        super.onTrigger(e);
        var t = cast(e, ent.Teleport);
        @:privateAccess t.targetIndex++;
    }

    override function getActionText() {
        return "change color";
    }

    static var _ = Action.register(ChangeColor);
}