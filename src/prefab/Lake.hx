package prefab;

class LakeObject extends h3d.scene.Mesh {

	public function new( primitive, ?material, ?parent ) {
		super(primitive, material, parent);
	}
}

class Lake extends hrt.prefab.l3d.Polygon {

	@:s public var refMatLib : String;
	@:s public var overrides : Array<Dynamic> = [];

	override function makeInstance() : Void {
		var lo = new LakeObject(null, shared.current3d);
		local3d = lo;
		local3d.name = name;
		updateInstance();
	}

	override function updateInstance(?propName : String ) {
		super.updateInstance(propName);

		var lo : h3d.scene.Mesh = cast local3d;

		if (this.refMatLib != null && this.refMatLib != "") {
			var refMatLibPath = this.refMatLib.substring(0, this.refMatLib.lastIndexOf("/"));
			var refMatName = this.refMatLib.substring(this.refMatLib.lastIndexOf("/") + 1);
			var prefabLib = hxd.res.Loader.currentInstance.load(refMatLibPath).toPrefab();

			try {
				var mat = h3d.mat.Material.create();
				if ( hxd.fmt.hmd.Library.setupMaterialLibrary( path -> return shared.loadTexture(path, false), mat, prefabLib, refMatName) )
					lo.material = mat;
			} catch( e : Dynamic ) {}
		}
	}

	#if editor

	override function setColor(color: Int) {
		return;
	}

	override function getHideProps() : hide.prefab.HideProps {
		return { icon : "square", name : "Lake" };
	}

	override function edit( ctx : hide.prefab.EditContext ) {
		super.edit(ctx);

		var matLibs = ctx.scene.listMatLibraries(this.getAbsPath());
		var selectedLib = this.refMatLib == null ? null : this.refMatLib.substring(0, this.refMatLib.lastIndexOf("/"));
		var selectedMat = this.refMatLib == null ? null : this.refMatLib.substring(this.refMatLib.lastIndexOf("/") + 1);
		var materials = [];

		var materialLibrary = new hide.Element('<div class="group" name="Material Library">
		<dl>
			<dt>Library</dt>
			<dd>
				<select class="lib">
					<option value="">None</option>
					${[for( i in 0...matLibs.length ) '<option value="${matLibs[i].name}" ${(selectedLib == matLibs[i].path) ? 'selected' : ''}>${matLibs[i].name}</option>'].join("")}
				</select>
			</dd>
			<dt>Material</dt>
			<dd>
				<select class="mat">
					<option value="">None</option>
				</select>
			</dd>
		</dl></div>');

		var libSelect = materialLibrary.find(".lib");
		var matSelect = materialLibrary.find(".mat");

		function updateLibSelect() {
			libSelect.empty();
			new hide.Element('<option value="">None</option>').appendTo(libSelect);

			for (idx in 0...matLibs.length) {
				new hide.Element('<option value="${matLibs[idx].name}" ${(selectedLib == matLibs[idx].path) ? 'selected' : ''}>${matLibs[idx].name}</option>');
			}
		}

		function updateMatSelect() {
			matSelect.empty();
			new hide.Element('<option value="">None</option>').appendTo(matSelect);

			materials = ctx.scene.listMaterialFromLibrary(this.getAbsPath(), libSelect.val());

			for (idx in 0...materials.length) {
				new hide.Element('<option value="${materials[idx].path + "/" + materials[idx].mat.name}" ${(selectedMat == materials[idx].mat.name) ? 'selected' : ''}>${materials[idx].mat.name}</option>').appendTo(matSelect);
			}
		}

		function updateMat() {
			var previousMatLib = refMatLib;
			var mat = ctx.scene.findMat(materials, matSelect.val());
			if ( mat != null ) {
				this.refMatLib = Reflect.field(mat, "path") + "/" + Reflect.field(mat, "mat").name;
				updateInstance();
				ctx.rebuildProperties();
			} else {
				this.refMatLib = "";
			}

			ctx.properties.undo.change(Field(this, "refMatLib", previousMatLib), function() {
				ctx.rebuildProperties();
				updateInstance();
			});
		}

		updateMatSelect();

		libSelect.change(function(_) {
			var previousMatSelect = matSelect.val();
			updateMatSelect();

			if (libSelect.val() == "" || previousMatSelect != "")
				updateMat();
		});

		matSelect.change(function(_) {
			updateMat();
		});

		ctx.properties.add(materialLibrary, this);
	}

	#end

	static var _ = hrt.prefab.Prefab.register("lake", Lake);

}