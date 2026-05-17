package ui;

import ui.comp.Button;

class Dialog extends Window {
	static var SRC =
	<dialog>
		<base-element id="dialog-container">
			<text id="dialog-text"/>
		</base-element>
		<base-element id="choices-container"></base-element>
		// <button id="button"/>
	</dialog>

	var onRemoveCb : Array<Void -> Void> = [];

	var entity : ent.Entity;

	public function new(entity : ent.Entity, ?parent) {
		super(parent);
		preventControl = true;
		this.entity = entity;
		initComponent();
	
		setDialog(0);
	}

	public function onEnd(cb : Void -> Void) {
		onRemoveCb.push(cb);
	}

	override function onRemove() {
		super.onRemove();
		for ( cb in onRemoveCb )
			cb();
	}

	function setDialog(idx : Int) {
		var dialog = entity.inf.dialog;
		dialogText.text = dialog[idx].text;
		
		if (dialog[idx].choices != null) {
			var buttons = [];
			for (c in dialog[idx].choices) {
				var b = new Button(choicesContainer);
				@:privateAccess b.label.text = c.text;
				buttons.push(b);
				b.onClick = () -> {
					var next = -1;
					for (idx => d in dialog) {
						if (d.id ==  c.targetId)
							next = idx; 
					}

					if (next == -1)
						throw "Wrong next dialog";
					
					for (b in buttons)
						b.remove();
					setDialog(next);
				}
			}
		}
	}
}