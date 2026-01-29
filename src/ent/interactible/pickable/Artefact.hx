package ent.interactible.pickable;

class Artefact extends Pickable {
    override function onInteract(ctrl : controllers.PlayerController) {
        super.onInteract(ctrl);
        
        game.goddess.unlockedSkill = true;
        onPicked();
        this.dispose();
    }
}

