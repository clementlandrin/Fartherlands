package ui;

enum Side {
	Right;
	Left;
}

enum Align {
	Top;
	Bottom;
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

	static final DIALOG_Y_OFFSET = 50;

	public var text(get, set) : String;
	public function get_text() {
		return bubbleText.text;
	}
	public function set_text(v : String) {
		return bubbleText.text = v;
	}

	var strip : h2d.Graphics;
	var anchor : h3d.scene.Object;
	var side : Side = Right;
	var align : Align = Top;

	public function new(anchor : h3d.scene.Object, side : Side, align : Align, ?parent) {
		super(parent);
		this.anchor = anchor;
		this.side = side;
		this.align = align;
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

		var game = Game.inst;
		var dialogAnchor = anchor.getAbsPos().getPosition();
		var pos = game.s3d.camera.project(dialogAnchor.x, dialogAnchor.y, dialogAnchor.z, game.s2d.width, game.s2d.height);
		var x = this.side == Right ? pos.x - Std.int(calculatedWidth / 6) : pos.x - Std.int(calculatedWidth * (5 / 6));
		var y = this.align == Top ? pos.y - Std.int(calculatedHeight) - DIALOG_Y_OFFSET : pos.y + DIALOG_Y_OFFSET;
		this.setPosition(x, y);
		drawStrip();
	}

	function drawStrip() {
		this.calcAbsPos();

		strip.clear();

		if (!this.visible)
			return;

		var game = Game.inst;
		var dialogAnchor = anchor.getAbsPos().getPosition();
		var pos = game.s3d.camera.project(dialogAnchor.x, dialogAnchor.y, dialogAnchor.z, game.s2d.width, game.s2d.height);

		var color = 0x000000;
		strip.beginFill(color, 0.8);
		strip.lineStyle(1, color, 0.8);

		var startX = this.side == Right ? this.absX + STRIP_X_OFFSET : this.absX + this.calculatedWidth - STRIP_X_OFFSET;
		var startY = this.align == Top ? this.absY + 100 : this.absY;
		strip.moveTo(startX, startY);
		strip.lineTo(pos.x, pos.y);

		var endX = this.side == Right ? this.absX + STRIP_X_OFFSET + STRIP_WIDTH : this.absX + this.calculatedWidth - STRIP_X_OFFSET - STRIP_WIDTH;
		var endY = this.align == Top ? this.absY + 100 : this.absY;
		strip.lineTo(endX, endY);
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
				var next = -1;
				for (idx => d in dialog) {
					if (d.id ==  dialog[currentDialog].targetId)
						next = idx;
				}
				this.currentDialog = next;
				setDialog(currentDialog);
			}
		}
		else if (!playerBubble.visible && npcBubble.text == dialog[this.currentDialog].text) {
			playerBubble.visible = true;
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
		var player = Game.inst.get_player();

		if (npcBubble == null)
			npcBubble = new Bubble(entity.obj.getObjectByName("bubbleAnchorTop"), entity.x < player.x ? Left : Right, Top, this);

		this.currentDialog = idx;
		npcBubble?.text = "";

		if (this.currentDialog < 0 || this.currentDialog >= entity.inf.dialog.length) {
			this.remove();
			return;
		}

		var dialog = entity.inf.dialog;
		if (dialog[this.currentDialog].choices == null || dialog[this.currentDialog].choices.length <= 0) {
			playerBubble?.remove();
			return;
		}

		playerBubble = new Bubble(player.obj.getObjectByName("bubbleAnchorBottom"), player.x < entity.x ? Left : Right, Bottom, this);
		playerBubble.visible = false;
		var buttons = [];
		for (c in dialog[this.currentDialog].choices) {
			var b = new ui.comp.Button(@:privateAccess playerBubble.choicesContainer);
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