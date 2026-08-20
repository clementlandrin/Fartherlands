import h3d.prim.Cube;
import h3d.Engine;
import hxd.Window;
import h3d.col.Point;

class CameraController extends h3d.scene.Object {
    public var deadZone : h2d.col.Bounds;

    var game : Game;
    var camera : h3d.Camera;

    public function new() {
        game = Game.inst;
        super(game.s3d);

        camera = game.s3d.camera;
		camera.orthoBounds = new h3d.col.Bounds();

        var engine = Engine.getCurrent();
        var cx = engine.width / 2;
        var cy = engine.height / 2;
        var deadzoneWidth = engine.width / 7;
        var deadZoneHeight = engine.height / 7;

        deadZone = new h2d.col.Bounds();
        deadZone.xMin = cx - deadzoneWidth;
        deadZone.xMax = cx + deadzoneWidth;
        deadZone.yMin = cy - deadZoneHeight;
        deadZone.yMax = cy + deadZoneHeight;
    }

    override function sync(ctx : h3d.scene.RenderContext) {
        super.sync(ctx);

        var curRoom = game.curRoom;
        if (curRoom != null && curRoom.camera == null)
			initCamera();

		var Y = camera.orthoBounds.xMax / camera.screenRatio;
		camera.orthoBounds.yMax = Y;
		camera.orthoBounds.yMin = -Y;

        var engine = Engine.getCurrent();
        var sp = camera.project(game.player.x, game.player.y, game.player.z, engine.width, engine.height);
        if (!deadZone.contains(new h2d.col.Point(sp.x, sp.y))) {
            var closestPoint = new h2d.col.Point(engine.width / 2, engine.height / 2);
            if (sp.x < deadZone.xMin || sp.x > deadZone.xMax)
                closestPoint.x = hxd.Math.clamp(sp.x, deadZone.xMin, deadZone.xMax);
            if (sp.y < deadZone.yMin || sp.y > deadZone.yMax)
                closestPoint.y = hxd.Math.clamp(sp.y, deadZone.yMin, deadZone.yMax);
            var r = camera.rayFromScreen(closestPoint.x, closestPoint.y, engine.width, engine.height);
            var targetPoint = r.intersect(h3d.col.Plane.fromNormalPoint(new h3d.col.Point(0, 0, 1), new h3d.col.Point(game.player.x, game.player.y, game.player.z)));

            var p = new h3d.col.Point(
                hxd.Math.lerp(camera.target.x, targetPoint.x, Const.get(FollowStrengthXY) * ctx.elapsedTime),
                hxd.Math.lerp(camera.target.y, targetPoint.y, Const.get(FollowStrengthXY) * ctx.elapsedTime),
                hxd.Math.lerp(camera.target.z, targetPoint.z, Const.get(FollowStrengthZ) * ctx.elapsedTime));

			if (!curRoom?.inf?.camFollowZ)
				p.z = camera.target.z;

            set(p);
        }
    }

    public function enteredRoom(r : ent.Room) {
        set(new Point(r.x, r.y, r.z));
    }

    function initCamera() {
		var X = Const.get(DefaultCameraWidth) * 0.5;
		var Z = Const.get(DefaultCameraDepth) * 0.5;
		camera.orthoBounds.xMax = X;
		camera.orthoBounds.xMin = -X;
		camera.orthoBounds.zMax = Z;
		camera.orthoBounds.zMin = -Z;
	}

    function set(pos : h3d.col.Point) {
        camera.target = pos;
        camera.pos.x = camera.target.x + Const.get(DefaultCameraX);
        camera.pos.y = camera.target.y + Const.get(DefaultCameraY);
        camera.pos.z = camera.target.z + Const.get(DefaultCameraZ);
    }
}