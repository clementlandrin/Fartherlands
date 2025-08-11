package ent;

class Chest extends Entity {

    function filterItem(i : ent.Entity) {
        return true;
    }

    override function canTrigger() {
        if ( super.canTrigger() )
            return true;
        if ( game.player != this && item != null )
            return true;
        return game.player != this && game.player.item != null && filterItem(game.player.item);
    }

    override function getTriggerText() {
        if ( item != null )
            return "Press F to pick. ";
        return "Press F to drop.";
    }

    override function onTrigger() {
        super.onTrigger();
        if ( item != null ) {
            game.player.pickItem(item);
            item = null;
        } else {
            item = game.player.item;
            game.player.dropItem();
        }
    }

    override function update(dt : Float) {
        super.update(dt);

        if ( item != null ) {
            item.setPos(getPos());
            // player picked item
            if ( game.goddess.item == item )
                item = null;
        }
    }
}