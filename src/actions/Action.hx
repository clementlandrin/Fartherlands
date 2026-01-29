package actions;

import ent.Interactible;

enum TriggerType {
    Primary;
    Secondary;
}

class Action {

    public static var actions : Array<Action> = [];

    public static function register(c : Class<Action>) {
        actions.push(Type.createInstance(c, []));
        return true;
    }

    public static function findAction(triggerType : TriggerType, e : ent.Entity) {
        for ( a in actions ) {
            if ( a.triggerType != triggerType )
                continue;
            if ( a.fit(e) )
                return a;
        }
        return null;
    }

    var triggerType : TriggerType;

    public function new(tt) {
        this.triggerType = tt;
    }

    public function fit(e : ent.Entity) {
        var int = Std.downcast(e, Interactible);
        return int != null && int.canInteract();
    }

    public function onTrigger(e : ent.Entity) {
        var int = Std.downcast(e, Interactible);
        int?.onInteract(e.game.ctrl);

        switch(triggerType) {
            case Primary:
                e.game.ctrl.requestInteract = false;
            case Secondary:
                e.game.ctrl.requestSecondaryInteract = false;
        }

        @:privateAccess e.removeTooltip();
    }

    public function getKeyText() {
        return switch(triggerType) {
        case Primary: "F";
        case Secondary: "E";
        }
    }

    public function getActionText() {
        return switch(triggerType) {
        case Primary: "interact";
        case Secondary: "infuse";
        }
    }

    public function getTooltipText() {
        return "Press " + getKeyText() + " to " + getActionText();
    }
}