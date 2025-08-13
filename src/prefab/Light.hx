package prefab;

class Light extends hrt.prefab.Light {

	#if editor
	override function shouldBeInstanciated() {
		var s = super.shouldBeInstanciated();
		if ( !s )
			return false;
		var scene = hide.comp.Scene.getCurrent();
		var s3d = scene.s3d;
		switch(kind){
		case Directional:
			var l = s3d.find(o -> Std.downcast(o, h3d.scene.pbr.DirLight));
			return l == null;
		default:
			return true;
		}
	}
	#end

	static var _ = hrt.prefab.Prefab.register("light", Light);
}