package ent;

class Teleport extends Entity {

	var shader : h3d.shader.ColorMult;
	var targetIndex(default, set) = 0;
	function set_targetIndex(v : Int) {
		targetIndex = v;
		updateColor();
		return targetIndex;
	}

	public function new() {
		super();
		shader = new h3d.shader.ColorMult();
	}

	function getColor() : Null<Int> {
		if ( inf == null )
			return null;
		if ( inf.color == null )
			return null;
		return inf.color;
	}

	override function start() {
		super.start();
		if ( isHub() ) {
			for ( e in game.entities ) {
				var t = Std.downcast(e, Teleport);
				if ( t == null || t == this )
					continue;
				if ( t.isHub() )
					throw "duplicate teleport pillar hub. should be unique.";
			}
		}
		updateColor();
	}

	public function isHub() {
		return getColor() == null;
	}

	override function setObject(obj) {
		super.setObject(obj);
		for ( m in obj.getMaterials() )
			m.mainPass.addShader(shader);
	}

	function updateColor() {
		if ( isHub() ) {
			var targets = [];
			for ( e in game.entities ) {
				var t = Std.downcast(e, Teleport);
				if ( t == null || t == this || Std.isOfType(t, FinalTeleport) )
					continue;
				targets.push(t);
			}
			var target = targets[targetIndex % targets.length];
			shader.color.setColor(target.getColor());
		} else
			shader.color.setColor(getColor());
	}

	function getTargetColor() {
		if ( !isHub() )
			throw "assert";
		return shader.color.toColor();
	}

	public function matches(t : Teleport) {
		if ( isHub() && getTargetColor() == t.getColor() )
			return true;
		if ( !isHub() && t.isHub() )
			return true;
		return false;
	}

	public function teleport(toTp : Array<Entity>) {
		var teleportCb = function() {
			var outPos = new h3d.col.Point();
			var outRadius = 1.0;
			for ( i => e in toTp ) {
				var theta = 2.0 * Math.PI * i / toTp.length;
				outPos.load(getPos());
				outPos.x += Math.cos(theta) * outRadius;
				outPos.y += Math.sin(theta) * outRadius;
				e.x = outPos.x;
				e.y = outPos.y;
				e.z = outPos.z;
				e.room = room;
			}
		};
		game.moveTo(room, [teleportCb]);
	}

	public function canTp() {
		return true;
	}
}