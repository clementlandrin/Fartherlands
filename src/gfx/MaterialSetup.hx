package gfx;

class MaterialSetup extends h3d.mat.PbrMaterialSetup {

	public function new(?name="Fatherlands") {
		super(name);
	}

	override function createRenderer(): h3d.scene.Renderer {
		return new gfx.Renderer(h3d.scene.pbr.Environment.getDefault());
	}

	override function createMaterial() {
		return @:privateAccess new Material();
	}

	override function gloss() {
		return false;
	}

	public static function set() {
		h3d.mat.MaterialSetup.current = new MaterialSetup();
	}
}