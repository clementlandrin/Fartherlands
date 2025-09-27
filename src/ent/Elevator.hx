package ent;

import controllers.Sequence;

class Elevator extends Entity {

	public var bottom : h3d.scene.Object;
	public var top : h3d.scene.Object;
	public var model : h3d.scene.Object;

	public var door(default, null) : Door;

	@:s var isTopPosition : Bool = true;

	var bounds : h3d.col.Bounds;
	public function new() {
		super();
		bounds = createUnitBounds();
		if ( room != null )
			room.elevators.push(this);
	}

	override function canInteract() {
        return false;
    }

	override function setObject(obj) {
		super.setObject(obj);

		try {
			bottom = obj.find(o -> o.name.toLowerCase() == "bottom" ? o : null);
		} catch ( e: Dynamic) {}

		try {
			top = obj.find(o -> o.name.toLowerCase() == "top" ? o : null);
		} catch ( e : Dynamic ) {}

		model = obj.find(o -> o.name.toLowerCase() == "model" ? o : null);
		
	}

	override function start() {
		super.start();

		if ( bottom == null && top == null )
			throw "elevator without top and without bottom";

		if ( bottom == null || top == null ) {
			var wantedDir = new h3d.Vector(0.0, 0.0, top == null ? 1.0 : -1.0);
			var maxDot = 0.0;
			for ( d in room.doors ) {
				var dir = d.getLeavingDirection();
				var dot = dir.dot(wantedDir);
				if ( dot > maxDot ) {
					door = d;
					maxDot = dot;
				}
			}
		}

		var parentZ = model.parent.z;
		if ( isTopPosition && top != null ) {
			model.z = top.getAbsPos().getPosition().z - parentZ;	
		} else if ( !isTopPosition && bottom != null ) {
			model.z = bottom.getAbsPos().getPosition().z - parentZ;	
		}
		if ( isTopPosition && top == null )
			model.visible = false;
		else if ( !isTopPosition && bottom == null )
			model.visible = false;
	}

	function playerInBounds(obj : h3d.scene.Object) {
		var pos = new h3d.col.Point(game.player.x, game.player.y, game.player.z);
		var localPos = pos.transformed(obj.getAbsPos().getInverse());
		return bounds.contains(localPos);
	}

	override function update(dt : Float) {
		super.update(dt);

		if ( game.ctrl.sequence == null ) {
			if ( bottom != null && playerInBounds(bottom) && !isTopPosition ) {
				initSequence(true);
			} else if ( top != null && playerInBounds(top) && isTopPosition ) {
				initSequence(false);
			}
		}
	}

	function initSequence(up : Bool) {
		var elevatorSpeed = Const.get(ElevatorSpeed);
		game.ctrl.curElevator = this;
		var leaving = false;
		var leavingDist = 0.0;
		var zTarget = 0.0;
		if ( up )
			zTarget = top != null ? top.getAbsPos().getPosition().z : Math.POSITIVE_INFINITY;
		else
			zTarget = bottom != null ? bottom.getAbsPos().getPosition().z : Math.NEGATIVE_INFINITY;
		game.ctrl.sequence = new Sequence(function(dt : Float) {
			var curZ = model.getAbsPos().getPosition().z;
			if ( (up && curZ > zTarget) || (!up && curZ < zTarget) ) {
				curZ = zTarget;
				leaving = true;
				isTopPosition = up;
			}
			if ( leaving ) {
				leavingDist += dt;
				game.ctrl.x += dt * elevatorSpeed;
				if ( leavingDist >= 1.0 ) {
					game.ctrl.curElevator = null;
					return true;
				}
			} else {
				var dZ = elevatorSpeed * dt;
				if ( !up )
					dZ *= -1.0;
				model.z += dZ;
			}
			game.ctrl.z = curZ;
			return false;
		});
	}

	public function enterFromDoor() {
		var goingUp = top != null;
		game.ctrl.curElevator.isTopPosition = goingUp;
		game.ctrl.curElevator.model.visible = false;
		model.visible = true;
		var parentZ = model.parent.getAbsPos().getPosition().z;
		model.z = game.player.z - parentZ;
		initSequence(goingUp);
	}
}