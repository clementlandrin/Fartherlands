package ent;

class Goddess extends Entity {

	@:s public var unlockedSkill : Bool = false;

	var temporalVisual : h3d.scene.Object;
	var temporalRadius : Float = 0.0;
	var sphereActive : Bool = false;
	var idle = false;

	override function start() {
		super.start();
		
		var chara = new h3d.scene.Object(game.s3d);
		hxd.Res.chara.chara.load().make(chara);
		setObject(chara);
		for ( m in obj.getMaterials() )
			m.color.setColor(0xFF0000);

		var temporalPrim = new h3d.prim.Sphere(1.0, 64, 60);
		temporalVisual = new h3d.scene.Mesh(temporalPrim, null, game.s3d);
		for ( m in temporalVisual.getMaterials() ) {
			m.color.set(1.0, 1.0, 1.0, 0.2);
			m.mainPass.setBlendMode(Alpha);
			m.mainPass.setPassName("beforeTonemapping");
			m.mainPass.depthWrite = false;
			m.shadows = false;
			@:privateAccess m.mainPass.addSelfShader(game.pastWindowShader);
			var p = m.allocPass("afterTonemapping");
			p.setBlendMode(Alpha);
			var cm = new h3d.shader.ColorMult();
			cm.color.setColor(Const.getColor(SphereColor));
			cm.color.set(cm.color.x, cm.color.y, cm.color.z, Const.get(SphereColor));
			p.addShader(cm);
		}
		temporalVisual.followPositionOnly = true;
		temporalVisual.follow = chara.find(o -> o.name == "sphereCenter" ? o : null);
		temporalVisual.setScale(temporalRadius);
	}

	public function getTemporalRadius() {
		return temporalRadius;
	}

	public function getTemporalPos() {
		return temporalVisual.getAbsPos().getPosition();
	}

	override function canBeTp() {
		return true;
	}

	override function update(dt : Float) {
		super.update(dt);

		timeMode = sphereActive ? Past : Present;
	}

	override function setMode(mode : Game.TimeMode) {
		super.setMode(mode);

		temporalVisual.visible = mode == Present;
	}
}