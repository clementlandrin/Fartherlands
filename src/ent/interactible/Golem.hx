package ent.interactible;

class Golem extends Interactible {
    var ctrl : controllers.GolemController;

    public function new() {
        super();
        this.ctrl = new controllers.GolemController(this);
    }

    override function getTooltipText() {
		return isBehind(game.player) ? 'Press F to control' : 'Press F to interact';
	}

    override function onInteract(ctrl : controllers.PlayerController) {
        if (isBehind(game.player)) {
            game.ctrl = this.ctrl;
            return;
        }

        var window = new ui.Dialog(this, this.game.baseUI.root);
        if ( this.inf.knowledgeId != null ) {
            window.onEnd(function() {
                var k = null;
                this.game.state.knowledgeRoot.iter(function(n) {
                    if ( this.inf.knowledgeId == n.id )
                        k = n;
                });
                k.discovered = true;
            });
        }
        if ( this.inf.unlockArtefact ) {
            window.onEnd(function() {
                this.game.goddess.unlockedSkill = true;
                this.dispose();
            });
        }
        if ( this.inf.activatorId != null ) {
            for ( toActivate in this.game.entities )
                if ( toActivate.id == this.inf.activatorId )
                    toActivate.activated = true;
        }
    }

    function isBehind(e : Entity) {
        var eAbs = e.obj.getAbsPos();
        var abs = obj.getAbsPos();
        var f = abs.front();
        var d = (eAbs.getPosition() - abs.getPosition()).normalized();
        return f.dot(d) <= 0;
    }
}