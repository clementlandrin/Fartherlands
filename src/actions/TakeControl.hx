package actions;

class TakeControl extends Action {

    public function new() {
        super(Secondary);
    }

    override function fit(e : ent.Entity) {
        return e.inf != null && e.inf.takeControl != null && e.game.player != e;
    }

    override function onTrigger(e : ent.Entity) {
        super.onTrigger(e);
        switch ( e.inf.takeControl ) {
        case Golem:
            e.game.ctrl = new controllers.GolemController(e);
        }
    }
    override function getActionText() {
        return "take control";
    }

    static var _ = Action.register(TakeControl);
}