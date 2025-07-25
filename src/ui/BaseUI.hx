package ui;

class BaseUIRoot extends ui.comp.BaseElement {
	public function new(parent) {
		super(parent);
		fillWidth = fillHeight = true;
		initComponent();
	}
}

class BaseUI {

	public var root : BaseUIRoot;
	public var style(default, null) : h2d.domkit.Style;

	public var s2d : h2d.Scene;

	var windows : Array<Window> = [];

	public function new() {
		Game.inst.baseUI = this;

		s2d = Game.inst.s2d;
		
		style = new h2d.domkit.Style();
		style.allowInspect = true;
		style.onInspectHyperlink = function(url: String) {
			new sys.io.Process('code --goto $url', false).close();
		}

		root = new BaseUIRoot(s2d);
		style.addObject(root);

		loadStyle();
	}

	function loadStyle() {
		style.clear();
		style.load(hxd.Res.ui.style.style);
	}	

	public function update(dt : Float) {
		style.sync(dt);
		if ( hxd.Key.isPressed(hxd.Key.ESCAPE) ) {
			var w = windows.pop();
			if ( w != null )
				w.remove();
		}
	}
}