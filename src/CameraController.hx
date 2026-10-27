import h3d.col.Point;

class CameraController extends h3d.scene.Object {
	var game : Game;
	
	var camera : h3d.Camera;
	var anchor = new Point();
	var snapToPlayer = true;

	public function new() {
		game = Game.inst;
		super(game.s3d);

		camera = game.s3d.camera;
		camera.orthoBounds = new h3d.col.Bounds();
		anchor.load(camera.target);
	}

	override function sync(ctx : h3d.scene.RenderContext) {
		super.sync(ctx);

		var curRoom = game.curRoom;
		if (curRoom != null && curRoom.camera == null)
			initCamera();

		var Y = camera.orthoBounds.xMax / camera.screenRatio;
		camera.orthoBounds.yMax = Y;
		camera.orthoBounds.yMin = -Y;

		var player = game.player;
		var playerPos = new Point(player.x, player.y, player.z);
		var followZ = curRoom?.inf?.camFollowZ == true;

		if (snapToPlayer) {
			snapToPlayer = false;
			centerOn(playerPos, followZ ? playerPos.z : camera.target.z);
			set(anchor);
			return;
		}

		// Before the dead zone, otherwise a Z change is seen as a vertical screen offset
		if (followZ)
			anchor.z = playerPos.z;

		var right = camera.getRight();
		var up = camera.getUp();
		var d = playerPos.sub(anchor);
		var sx = d.dot(right);
		var sy = d.dot(up);
		var halfW = camera.orthoBounds.xMax * Const.get(CameraDeadZoneWidth);
		var halfH = camera.orthoBounds.yMax * Const.get(CameraDeadZoneHeight);
		var ex = sx - hxd.Math.clamp(sx, -halfW, halfW);
		var ey = sy - hxd.Math.clamp(sy, -halfH, halfH);

		anchor.x += right.x * ex;
		anchor.y += right.y * ex;
		var groundUpX = -right.y;
		var groundUpY = right.x;
		var groundUpOnScreen = groundUpX * up.x + groundUpY * up.y;
		anchor.x += groundUpX * ey / groundUpOnScreen;
		anchor.y += groundUpY * ey / groundUpOnScreen;

		var kXY = 1 - Math.exp(-Const.get(FollowStrengthXY) * ctx.elapsedTime);
		var kZ = 1 - Math.exp(-Const.get(FollowStrengthZ) * ctx.elapsedTime);
		set(new Point(
			hxd.Math.lerp(camera.target.x, anchor.x, kXY),
			hxd.Math.lerp(camera.target.y, anchor.y, kXY),
			hxd.Math.lerp(camera.target.z, anchor.z, kZ)));
	}

	public function enteredRoom(r : ent.Room) {
		set(new Point(r.x, r.y, r.z));
		snapToPlayer = true;
	}

	function centerOn(pos : Point, z : Float) {
		anchor.set(pos.x, pos.y, z);
		var right = camera.getRight();
		var up = camera.getUp();
		var groundUpX = -right.y;
		var groundUpY = right.x;
		var groundUpOnScreen = groundUpX * up.x + groundUpY * up.y;
		var offset = (pos.z - z) * up.z / groundUpOnScreen;
		anchor.x += groundUpX * offset;
		anchor.y += groundUpY * offset;
	}

	function initCamera() {
		var X = Const.get(DefaultCameraWidth) * 0.5;
		var Z = Const.get(DefaultCameraDepth) * 0.5;
		camera.orthoBounds.xMax = X;
		camera.orthoBounds.xMin = -X;
		camera.orthoBounds.zMax = Z;
		camera.orthoBounds.zMin = -Z;
	}

	function set(pos : Point) {
		camera.target.load(pos);
		camera.pos.x = camera.target.x + Const.get(DefaultCameraX);
		camera.pos.y = camera.target.y + Const.get(DefaultCameraY);
		camera.pos.z = camera.target.z + Const.get(DefaultCameraZ);
	}
}
