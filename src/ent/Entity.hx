package ent;

class Entity extends st.State {

	public var room : Room;
	public var inf : Data.Element_props;
	public var id : Data.ElementKind;
	@:s public var activated : Bool = true;
	
	var outlineShader : shaders.OutlineShader;
	var tooltip : ui.Tooltip;
	var timeMode : Game.TimeMode;

	public var obj : h3d.scene.Object;

	@:s public var x(default, set) : Float;
	public function set_x(v) {
		if ( obj != null )
			obj.x = v;
		return x = v;
	}
	@:s public var y(default, set) : Float;
	public function set_y(v) {
		if ( obj != null )
			obj.y = v;
		return y = v;
	}
	@:s public var z(default, set) : Float;
	public function set_z(v) {
		if ( obj != null )
			obj.z = v;
		return z = v;
	}
	
	override function init() {
		super.init();
		if ( game.state != null )
			room = game.state.curRoom;
		timeMode = @:privateAccess game.modeMake;
		game.entities.push(this);
	}

	public function canBeTp() {
		return inf != null && inf.canTp;
	}

	public function getPos() {
		return new h3d.col.Point(x,y,z);
	}

	public function setPos(pos : h3d.Vector) {
		x = pos.x;
		y = pos.y;
		z = pos.z;
	}

	public function getPos2D() {
		return getPos().to2D();
	}

	public function setObject(obj : h3d.scene.Object) {
		this.obj = obj;
		obj.inheritCulled = true;
		this.name = obj.name;
		if ( isMemo() )
			setTooltip();
	}

	public function posFromObj() {
		var pos = obj.getAbsPos().getPosition();
		@:bypassAccessor x = pos.x;
		@:bypassAccessor y = pos.y;
		@:bypassAccessor z = pos.z;
	}

	function isMemo() {
		return inf != null && inf.memo;
	}

	function onOver() {
		setOutline(true);
		setTooltip();
	}

	function onOut() {
		setOutline(false);
		removeTooltip();
	}

	final function trigger() {
		var action = getAction(Primary);
		if ( action != null )
			action.onTrigger(this);
	}

	final function secondTrigger() {
		var action = getAction(Secondary);
		if ( action != null )
			action.onTrigger(this);
	}

	final function getAction(triggerType : actions.Action.TriggerType) {
		return actions.Action.findAction(triggerType, this);
	}

	final function canTrigger() {
		return getAction(Primary) != null;
	}

	final function canSecondaryTrigger() {
		return getAction(Secondary) != null;
	}

	override function start() {
		super.start();
		if ( inf != null && inf.deactivated )
			activated = false;
		if ( obj != null ) {
			var newTransform = new h3d.Matrix();
			newTransform.multiply3x4inline(obj.getTransform(), obj.parent.getAbsPos());
			obj.setTransform(newTransform);
			game.s3d.addChild(obj);
		}
	}

	public function createUnitBounds() {
		var boxBounds = new h3d.col.Bounds();
		boxBounds.xMin = -0.5;
		boxBounds.yMin = -0.5;
		boxBounds.zMin = -0.5;
		boxBounds.xSize = 1.0;
		boxBounds.ySize = 1.0;
		boxBounds.zSize = 1.0;
		return boxBounds;
	}

	public function setFront(dir : h3d.col.Point) {
		var quat = new h3d.Quat();
		quat.initDirection(dir.normalized(), new h3d.Vector(0.0, 0.0, 1.0));
		obj.setRotationQuat(quat);
	}

	public function movementTarget(target : h3d.col.Point, dt : Float) {
		var curPos = new h3d.col.Point(x,y,z);
		var diff = target.sub(curPos);
		var dir = diff.normalized();
		var distToTarget = diff.length();
		var moveDist = dt * Const.get(PlayerSpeed);

		if ( distToTarget > 1e-3 )
			setFront(target.sub(new h3d.col.Point(x,y,target.z)));

		if ( moveDist > distToTarget ) {
			x = target.x;
			y = target.y;
			z = target.z;
			return true;
		}
		curPos = curPos.add(dir.scaled(moveDist));
		x = curPos.x;
		y = curPos.y;
		z = curPos.z;
		return false;
	}

	// override function update(dt : Float) {
	// 	super.update(dt);
	// 	updateItem(dt);
	// 	var player = game.player;
	// 	var goddess = game.goddess;
	// 	var range = Const.get(InteractibleRadius);

	// 	var i = player.getPos().distanceSq(getPos()) < range * range;
	// 	if ( i ) {
	// 		switch(timeMode) {
	// 		case Common:
	// 		case Past:
	// 			var r = goddess.getTemporalRadius();
	// 			i = getPos().distanceSq(goddess.getTemporalPos()) < r * r;
	// 		case Present:
	// 			var r = goddess.getTemporalRadius();
	// 			i = getPos().distanceSq(goddess.getTemporalPos()) > r * r;
	// 		case None:
	// 			throw "assert";
	// 		}
	// 	}
	// 	if ( i && canInteract() ) {
	// 		onOver();
	// 		if ( game.ctrl.requestInteract )
	// 			trigger();
	// 		if ( game.ctrl.requestSecondaryInteract )
	// 			secondTrigger();
	// 	} else {
	// 		onOut();
	// 	}
	// }

	public function canInteract() {
		if ( !game.canControl() )
			return false;
		return canTrigger() || canSecondaryTrigger();
	}

	// public function isInEntity() {
	// 	for ( e in game.entities )
	// 		if ( e.item == this )
	// 			return true;
	// 	return false;
	// }

	public function cull() {
		var culled = !enabled || (room != null && !room.enabled);
		obj.culled = culled;
		if ( tooltip != null )
			tooltip.visible = !culled;
	}

	public function setMode(mode : Game.TimeMode) {

	}

	public function getDataColor() {
		return inf != null ? inf.color : null;
	}

	public function setOutline(b : Bool) {
		if ( b ) {
			if ( outlineShader == null ) {
				outlineShader = new shaders.OutlineShader();
				outlineShader.color.setColor(Const.getColor(OutlineColor));
				outlineShader.size = Const.get(OutlineSize);
				var mainStencil = new h3d.mat.Stencil();
				mainStencil.setFunc(Always, Const.STENCIL_OUTLINE, Const.STENCIL_OUTLINE, Const.STENCIL_OUTLINE);
				mainStencil.setOp(Keep, Keep, Replace);
				var outlineStencil = new h3d.mat.Stencil();
				outlineStencil.setFunc(Equal, 0, Const.STENCIL_OUTLINE, Const.STENCIL_OUTLINE);
				outlineStencil.setOp(Keep, Keep, Keep);
				for ( m in obj.getMaterials() ) {
					m.mainPass.stencil = mainStencil;
					var p = m.allocPass("afterTonemapping");
					p.addShader(outlineShader);
					p.stencil = outlineStencil;
				}
			}
			// if (obj != null) {
			// 	for( m in obj.getMeshes() ) {
			// 		var p = Std.downcast(m.primitive, h3d.prim.HMDModel);
			// 		if( p == null )
			// 			continue;
			// 		if( !p.hasInput("logicNormal") )
			// 			p.recomputeNormals("logicNormal");
			// 	}
			// }
		} else {
			if ( outlineShader != null ) {
				outlineShader = null;
				for ( m in obj.getMaterials() ) {
					m.mainPass.stencil = null;
					var p = m.getPass("afterTonemapping");
					if ( p != null )
						m.removePass(p);
				}
			}
		}
	}

	// function updateItem(dt : Float) {
	// 	if ( item == null )
	// 		return;
	// 	item.setPos(getPos());
	// 	item.room = room;
	// }

	function setTooltip() {
		if ( tooltip != null )
			return;
		var windows = @:privateAccess game.baseUI.windows;
		for ( w in windows ) {
			if ( Std.isOfType(w, ui.Dialog) )
				return;
		}
		tooltip = new ui.Tooltip(this, game.baseUI.root);
	}

	function removeTooltip() {
		if ( !isMemo() && tooltip != null ) {
			tooltip.remove();
			tooltip = null;
		}
	}

	public function getTooltipText() {
		var str = "";
		var action = getAction(Primary);
		if ( action != null )
			str += action.getTooltipText();
		var secondaryAction = getAction(Secondary);
		if ( secondaryAction != null )
			str += secondaryAction.getTooltipText();
		return str;
	}

	override function dispose() {
		super.dispose();
		obj.remove();
		// for ( e in game.entities )
			// if ( e.item == this )
			// 	e.item.dr.dropItem();
		if ( tooltip != null )
			tooltip.remove();
		game.entities.remove(this);
	}

	public function onUse() {

	}
}