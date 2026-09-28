package gfx;

class Material extends h3d.mat.PbrMaterial {

	override function set_specularTexture(t) {
		if( specularTexture == t )
			return t;
		var spec = mainPass.getShader(gfx.PropsTexture);
		var props : h3d.mat.PbrMaterial.PbrProps = props;
		if( t != null ) {
			if( spec == null ) {
				spec = new gfx.PropsTexture();
				spec.emissiveValue = props.emissive;
				mainPass.addShader(spec);
			}
		}
		return super.set_specularTexture(t);
	}
}