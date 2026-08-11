package ui;

enum Side {
	Right;
	Left;
}

class Bubble extends Window {
	static var SRC =
	<bubble>
		<text id="bubble-text"/>
		<flow id="choices-container">
		</flow>
	</bubble>

	static final STRIP_X_OFFSET = 50;
	static final STRIP_WIDTH = 25;
	static final STRIP_SPACING = 0;

	static final DIALOG_Y_OFFSET = 50;

	public var text(get, set) : String;
	public function get_text() {
		return bubbleText.text;
	}
	public function set_text(v : String) {
		return bubbleText.text = v;
	}

	var strip : h2d.Graphics; 
	var anchor : ent.Entity;
	var side : Side = Right;

	public function new(anchor : ent.Entity, side : Side, ?parent) {
		super(parent);
		this.anchor = anchor;
		this.side = side;
		initComponent();

		strip = new h2d.Graphics(this.getScene());
		this.onAfterReflow = drawStrip;
	}

	override function onRemove() {
		super.onRemove();
		strip.clear();
		strip.remove();
	}

	override function sync(ctx) {
		super.sync(ctx);

		var game = anchor.game;

		var dialogAnchor = new h3d.col.Point(anchor.x, anchor.y, anchor.z + anchor.obj.getBounds().getSize().z);
		var pos = game.s3d.camera.project(dialogAnchor.x, dialogAnchor.y, dialogAnchor.z, game.s2d.width, game.s2d.height);
		if (this.side == Right)
			this.setPosition(pos.x - Std.int(calculatedWidth / 6), pos.y - Std.int(calculatedHeight) - DIALOG_Y_OFFSET);
		else
			this.setPosition(pos.x - Std.int(calculatedWidth * (5 / 6)), pos.y - Std.int(calculatedHeight) - DIALOG_Y_OFFSET);

		drawStrip();
	}

	function drawStrip() {
		this.calcAbsPos();
		
		strip.clear();

		var game = anchor.game;
		var dialogAnchor = new h3d.col.Point(anchor.x, anchor.y, anchor.z + anchor.obj.getBounds().getSize().z);
		var pos = game.s3d.camera.project(dialogAnchor.x, dialogAnchor.y, dialogAnchor.z, game.s2d.width, game.s2d.height);

		var color = 0x000000;
		strip.beginFill(color, 0.8);
		strip.lineStyle(1, color, 0.8);
		if (this.side == Right)
			strip.moveTo(this.absX + STRIP_X_OFFSET, this.absY + 100);//@:privateAccess dialogAnchor.calculatedHeight);
		else
			strip.moveTo(this.absX + this.calculatedWidth - STRIP_X_OFFSET, this.absY + 100);//@:privateAccess dialogAnchor.calculatedHeight);
		strip.lineTo(pos.x, pos.y - STRIP_SPACING);
		if (this.side == Right)
			strip.lineTo(this.absX + STRIP_X_OFFSET + STRIP_WIDTH, this.absY + 100);//@:privateAccess dialogAnchor.calculatedHeight);
		else
			strip.lineTo(this.absX + this.calculatedWidth - STRIP_X_OFFSET - STRIP_WIDTH, this.absY + 100);//@:privateAccess dialogAnchor.calculatedHeight);
		strip.endFill();
	}
}

class Dialog extends Window {
	static var SRC =
	<dialog>
	</dialog>

	static final TYPE_SPEED = 120;

	var entity : ent.Entity;
	var onRemoveCb : Array<Void -> Void> = [];
	var currentDialog : Int = 0;

	var npcBubble : Bubble;
	var playerBubble : Bubble;

	public function new(entity : ent.Entity, ?parent) {
		super(parent);
		preventControl = true;
		this.entity = entity;
		initComponent();

		setDialog(currentDialog);
	}

	override function sync(ctx) {
		super.sync(ctx);

		var dialog = entity.inf.dialog;
		if (npcBubble.text != dialog[this.currentDialog].text) {
			var speed = Std.int(ctx.elapsedTime * TYPE_SPEED);
			npcBubble.text = dialog[this.currentDialog].text.substr(0, hxd.Math.imin(npcBubble.text.length + speed, dialog[this.currentDialog].text.length));
		}

		if (dialog[currentDialog].choices == null) {
			if (hxd.Key.isPressed(hxd.Key.MOUSE_LEFT) || hxd.Key.isPressed(hxd.Key.ENTER)) {
				currentDialog++;
				setDialog(currentDialog);
			}
		}
	}

	override function onRemove() {
		super.onRemove();
		for (cb in onRemoveCb)
			cb();
	}

	public function onEnd(cb : Void -> Void) {
		onRemoveCb.push(cb);
	}

	function setDialog(idx : Int) {
		if (npcBubble == null)
			npcBubble = new Bubble(entity, entity.x < Game.inst.player.x ? Left : Right, this);

		this.currentDialog = idx;
		npcBubble?.text = "";
		
		if (this.currentDialog < 0 || this.currentDialog >= entity.inf.dialog.length) {
			this.remove();
			return;
		}

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