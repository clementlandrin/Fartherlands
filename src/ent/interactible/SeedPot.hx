package ent.interactible;

class SeedPot extends Chest {

    function getSeed() {
        return item != null ? cast(item, ent.interactible.pickable.Seed) : null;
    }

    override function filterItem(i : ent.Entity) {
        return Std.isOfType(i, ent.interactible.pickable.Seed);
    }
    
    override function update(dt : Float) {
        super.update(dt);

        var s = getSeed();
        if ( s != null ) {
            s.grow(dt);
        }
    }
}