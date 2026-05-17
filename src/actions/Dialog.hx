package actions;

class Dialog extends Action {

    public function new() {
        super(Primary);
    }

    override function fit(e : ent.Entity) {
        return true;
        // return e.activated && e.inf != null && e.inf.dialog != null; 
    }

    override function getActionText() {
        return "discuss";
    }

    override function onTrigger(e : ent.Entity) {
        super.onTrigger(e);
        var window = new ui.Dialog(e, e.game.baseUI.root);
        if ( e.inf.knowledgeId != null ) {
            window.onEnd(function() {
                var k = null;
                e.game.state.knowledgeRoot.iter(function(n) {
                    if ( e.inf.knowledgeId == n.id )
                        k = n;
                });
                k.discovered = true;
            });
        }
        if ( e.inf.unlockArtefact ) {
            window.onEnd(function() {
                e.game.goddess.unlockedSkill = true;
                e.dispose();
            });
        }
        if ( e.inf.activatorId != null ) {
            for ( toActivate in e.game.entities )
                if ( toActivate.id == e.inf.activatorId )
                    toActivate.activated = true;
        }
    }

    static var _ = Action.register(Dialog);
}