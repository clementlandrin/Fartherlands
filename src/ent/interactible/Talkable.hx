package ent.interactible;

class Talkable extends Interactible {
	override function onInteract(ctrl: controllers.PlayerController) {
		super.onInteract(ctrl);

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
}