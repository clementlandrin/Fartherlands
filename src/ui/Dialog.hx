package ui;

class Dialog extends Window {
	static var SRC =
	<dialog>
		<text id="speechText"/>
		// <button id="button"/>
	</dialog>

	var onRemoveCb : Array<Void -> Void> = [];

	var entity : ent.Entity;

	public function new(entity : ent.Entity, ?parent) {
		super(parent);
		preventControl = true;
		this.entity = entity;
		initComponent();
		speechText.text = entity.inf.dialog;

		// button.onClick = function() {
		// 	this.remove();
		// };
	}

	public function onEnd(cb : Void -> Void) {
		onRemoveCb.push(cb);
	}

	override function onRemove() {
		super.onRemove();
		for ( cb in onRemoveCb )
			cb();
	}
}