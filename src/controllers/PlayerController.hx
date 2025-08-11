package controllers;

class PlayerController {

	public var requestInteract : Bool = false;
	public var requestSecondaryInteract : Bool = false;
	public var player : ent.Entity;
	
	var game : Game;

	var skin : h3d.scene.Skin;
	var curLadder : ent.Ladder;
	var idle = false;
	var sequence : Sequence;

	var x(get,set) : Float;
	function get_x() {
		return player.x;
	}
	function set_x(v) {
		return player.x = v;
	}
	var y(get,set) : Float;
	function get_y() {
		return player.y;
	}
	function set_y(v) {
		return player.y = v;
	}
	var z(get,set) : Float;
	function get_z() {
		return player.z;
	}
	function set_z(v) {
		return player.z = v;
	}

	public function new(p : ent.Entity) {
		game = Game.inst;
		player = p;
	}

	public function start() {
		skin = player.obj.find(o -> Std.downcast(o, h3d.scene.Skin));
	}

	public function onEnd() {
		requestInteract = false;
		requestSecondaryInteract = false;
	}
	
	public function update(dt : Float) {

		if ( canControl() ) {
			updateMovement(dt);
			if ( hxd.Key.isPressed(hxd.Key.G) )
				player.dropItem();
			if ( hxd.Key.isPressed(hxd.Key.F) )
				requestInteract = true;
			if ( hxd.Key.isPressed(hxd.Key.E) )
				requestSecondaryInteract = true;
		}
	}

	function canControl() {
		return game.canControl();
	}

	function updateMovement(dt : Float) {
		if ( sequence != null ) {
			if ( sequence.update(dt) )
				sequence = null;
			return;
		}
		if ( isClimbing() ) {
			updateLadderMovement(dt);
			return;
		}

		var speed = Const.get(PlayerSpeed);
		var displacement = new h2d.col.Point(0.0,0.0);
		if ( hxd.Key.isDown(hxd.Key.LEFT) || hxd.Key.isDown(hxd.Key.Q) ) {
			displacement.x = -dt * speed;
		}
		if ( hxd.Key.isDown(hxd.Key.RIGHT) || hxd.Key.isDown(hxd.Key.D) ) {
			displacement.x = dt * speed;
		}
		if ( hxd.Key.isDown(hxd.Key.UP) || hxd.Key.isDown(hxd.Key.Z) ) {
			displacement.y = dt * speed;
		}
		if ( hxd.Key.isDown(hxd.Key.DOWN) || hxd.Key.isDown(hxd.Key.S) ) {
			displacement.y = -dt * speed;
		}
		
		var camera = game.s3d.camera;
		var front = camera.getForward();
		front.z = 0.0;
		front.normalize();
		var right = camera.getRight();
		right.z = 0.0;
		right.normalize();

		var move = displacement.y * front + displacement.x * right;
		var newPos = new h3d.col.Point(x + move.x, y + move.y, z);

		if ( move.length() > 0.0 ) {
			setFront(move.normalized());

			if ( idle ) {
				idle = false;
				var anim = game.modelCache.loadAnimation(hxd.Res.chara.Anim.Anim_Walk);
				if ( skin != null )
					skin.switchToAnimation(anim.createInstance(skin));
			}
		} else {
			if ( !idle ) {
				idle = true;
				var anim = game.modelCache.loadAnimation(hxd.Res.chara.Anim.Anim_Idle);
				if ( skin != null )
					skin.switchToAnimation(anim.createInstance(skin));
			}
		}
		
		if ( game.curRoom != null ) {
			var voxels = game.curRoom.voxels;
			if ( voxels.isInside(newPos) ) {
				var stepDist = Voxels.getVoxelSize() / Math.sqrt(2.0);
				var steps = hxd.Math.imax(Math.ceil(move.length() / stepDist), 1);
				var moveStep = move.scaled(1.0 / steps);

				var curPos = new h3d.col.Point(x,y,z);
				var curVoxelCoord = voxels.getVoxelCoord(curPos);
				var speedFall = 1.0;
				var fallDist = dt * speedFall;
				var fallDistStep = fallDist / steps;
				var fallVoxelStep = Math.ceil(fallDistStep / Voxels.getVoxelSize());
				for ( s in 0...steps ) {
					var beforeStepPos = curPos.clone();
					curPos.x += moveStep.x;
					curPos.y += moveStep.y;
					curVoxelCoord = voxels.getVoxelCoord(curPos);
					var blocked = false;

					// fall
					if ( !voxels.collideValue(voxels.getByCoord(curVoxelCoord), getTimeMode())  ) {
						for ( i in 0...fallVoxelStep ) {
							curVoxelCoord.z--;
							if ( voxels.collideValue(voxels.getByCoord(curVoxelCoord), getTimeMode()) )
								break;
						}
					}
					//climb
					else {
						var height = Voxels.getVoxelSize();
						var startVoxelCoord = curVoxelCoord.clone();
						var maxHeight = Const.get(MaxClimbHeight);
						while ( curVoxelCoord.z < voxels.size.z ) {
							var upCoord = curVoxelCoord.clone();
							upCoord.z++;
							if ( !voxels.collideValue(voxels.getByCoord(upCoord), getTimeMode()) )
								break;
							if ( height > maxHeight ) {
								blocked = true;
								break;
							}
							height += Voxels.getVoxelSize();
							curVoxelCoord.load(upCoord);
						}
					}
					if ( blocked ) {
						curPos = beforeStepPos;
						break;
					}

					curPos.z = voxels.getPos(curVoxelCoord).z;
				}

				x = curPos.x;
				y = curPos.y;
				z = curPos.z;
			}
		}
	}

	function moveTo(target : h3d.col.Point, dt : Float) {
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

	public function setFront(dir : h3d.col.Point) {
		var quat = new h3d.Quat();
		quat.initDirection(dir.normalized(), new h3d.Vector(0.0, 0.0, 1.0));
		player.obj.setRotationQuat(quat);
	}

	function updateLadderMovement(dt : Float) {
		if ( hxd.Key.isDown(hxd.Key.Z) || hxd.Key.isDown(hxd.Key.UP) ) {
			curLadder.tryLeaveTop();
			z += dt * Const.get(ClimbSpeed);
		}
		if ( hxd.Key.isDown(hxd.Key.S) || hxd.Key.isDown(hxd.Key.DOWN) ) {
			curLadder.tryLeaveBottom();
			z -= dt * Const.get(ClimbSpeed);
		}
	}

	public function getTimeMode() : Game.TimeMode {
		return @:privateAccess player.timeMode; 
	}

	public function enterLadder(l : ent.Ladder, to : h3d.col.Point) {
		if ( !canClimb() )
			return;
		if ( l == null )
			throw "entering null ladder";
		curLadder = l;
		sequence = new Sequence(function (dt : Float) {
			return moveTo(to, dt);
		});
	}

	public function leaveLadder(ladderEdge : h3d.col.Point, out : h3d.col.Point) {
		if ( !canClimb() )
			throw "controller can't climb, shouldn't try to leave ladder";
		if ( curLadder == null )
			throw "assert";
		sequence = new Sequence(function (dt : Float) {
			var reached = moveTo(ladderEdge, dt);
			if ( reached ) {
				sequence = new Sequence(function (dt : Float) {
					var reached = moveTo(out, dt);
					if ( reached )
						curLadder = null;
					return reached;
				});
			}
			return false;
		});
	}

	public function isClimbing(?l : ent.Ladder) {
		if ( l == null )
			return curLadder != null;
		return curLadder == l;
	}

	public function canClimb() {
		return true;
	}

	public function canChangeRoom() {
		return true;
	}

	public function canSecondaryTrigger() {
		return true;
	}
}