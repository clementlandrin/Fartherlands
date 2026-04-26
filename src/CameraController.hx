import h3d.col.Point;

class CameraController extends h3d.scene.Object {
    public var strength : Float = 0.01;

    var game : Game;
    var camera : h3d.Camera;

    public function new() {
        game = Game.inst;
        super(game.s3d);

        camera = game.s3d.camera;
		camera.orthoBounds = new h3d.col.Bounds();
    }

    override function sync(ctx : h3d.scene.RenderContext) {
        super.sync(ctx);

        var curRoom = game.curRoom;
        if (curRoom != null && curRoom.camera == null)
			initCamera();

		var Y = camera.orthoBounds.xMax / camera.screenRatio;
		camera.orthoBounds.yMax = Y;
		camera.orthoBounds.yMin = -Y;

        var p = new h3d.col.Point(
            hxd.Math.lerp(camera.target.x, game.player.x, strength),
            hxd.Math.lerp(camera.target.y, game.player.y, strength),
            hxd.Math.lerp(camera.target.z, game.player.z, strength));

        set(p);
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