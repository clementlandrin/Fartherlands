package actions;

class Activate extends Action {

    public function new() {
        super(Secondary);
    }

    override function fit(e : ent.Entity) {
        return !e.activated && e.inf != null && e.inf.activateByInfusion; 
    }

    override function onTrigger(e : ent.Entity) {
        super.onTrigger(e);
        e.activated = true;
        if ( e.inf.activatedModel != null ) {
            e.obj.removeChildren();
            hxd.res.Loader.currentInstance.load(e.inf.activatedModel).toPrefab().load().make(e.obj);
            e.setObject(e.obj);
        }
    }

    override function getActionText() {
        return "activate";
    }

    static var _ = Action.register(Activate);
}