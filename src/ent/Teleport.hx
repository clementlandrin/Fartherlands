package ent;

class Teleport extends Entity {

	var shader : h3d.shader.ColorMult;
	var runtimeColor : Int = 0;

	public function new() {
		super();
		shader = new h3d.shader.ColorMult();
	}

	override function setObject(obj) {
		super.setObject(obj);
		for ( m in obj.getMaterials() ) {
			if ( m.mainPass.getShader(h3d.shader.ColorMult) == null )
				m.mainPass.addShader(shader);
		}
	}

	override function update(dt : Float) {
		super.update(dt);

		var curColor = new h3d.Vector(0.0, 0.0, 0.0);

		for ( e in game.entities ) {
			if ( e.room != null && e.room != room )
				continue;
			var c = e.getDataColor();
			if ( c == null )
				continue;
			var d = e.getPos().distance(getPos());
			var min = 1.0;
            var max = 2.0;
            var t = (max - d) / (max - min);
            t = hxd.Math.clamp(t);
			if ( t > 0.0 ) {
				var c = h3d.Vector.fromColor(c);
				c.scale(t);
				curColor = curColor.add(c);
			}
		}
		curColor.x = hxd.Math.clamp(curColor.x);
		curColor.y = hxd.Math.clamp(curColor.y);
		curColor.z = hxd.Math.clamp(curColor.z);

		shader.color.set(curColor.x, curColor.y, curColor.z, 1.0);
	}

	public function matches(t : Teleport) {
		if ( t == this )
			return false;
		return shader.color.toColor() == t.shader.color.toColor();
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