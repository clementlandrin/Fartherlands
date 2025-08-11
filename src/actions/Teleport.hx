package actions;

class Teleport extends Action {

    public function new() {
        super(Secondary);
    }

    override function fit(e : ent.Entity) {
        var t = Std.downcast(e, ent.Teleport);
        if ( t == null )
            return false;
		return t.canTp();
    }

    override function onTrigger(e : ent.Entity) {
        super.onTrigger(e);
        var teleport = cast(e, ent.Teleport);
        for ( e in teleport.game.entities ) {
			var to = Std.downcast(e, ent.Teleport);
			if ( to == null )
				continue;
			if ( teleport.matches(to) ) {
				if ( !to.activated ) {
					var s = new h3d.shader.ColorMult();
					s.color.setColor(0);
					for ( m in teleport.obj.getMaterials() )
						m.mainPass.addShader(s);
					e.game.globalEvent.wait(0.1, function() {
						for ( m in teleport.obj.getMaterials() )
							m.mainPass.removeShader(s);
					});
					break;
				}
				var toTp = [];
				for ( e in e.game.entities ) {
					if ( e.canBeTp() ) {
						var d = e.getPos().to2D().distance(teleport.getPos().to2D());
						if ( d < Const.get(PillarRadiusEffect) )
							toTp.push(e);
					}
				}
				to.teleport(toTp);
				break;
			}
		}
    }
    
    override function getActionText() {
        return "teleport";
    }

    static var _ = Action.register(Teleport);
}