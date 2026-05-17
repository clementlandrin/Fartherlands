package ui.comp;

@:uiComp("button")
class Button extends BaseElement {
	static var SRC = <button>
		<text id="label"/>
	</button>

	public function new(?parent) {
		super(parent);
		initComponent();
		enableInteractive = true;
		interactive.onClick = function (e:hxd.Event) {
			if ( e.button == 0 )
				onClick();
		};
	}
}