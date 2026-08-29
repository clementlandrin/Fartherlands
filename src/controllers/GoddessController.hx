package controllers;

@:access(ent.Goddess)
class GoddessController extends PlayerController {
	public var sphereRemainingTime = Const.get(SphereMaxTime);

	function getGoddess() {
		return cast(player, ent.Goddess);
	}

	override function update(dt : Float) {
		super.update(dt);

		if ( canControl() ) {
			if ( sequence == null )
				updateSphere(dt);
		}
	}

	override function getSpeed() {
		return getGoddess().sphereActive ? Const.get(PlayerSpeedWithSphere) : Const.get(PlayerSpeed);
	}

	function updateSphere(dt : Float) {
		var goddess = getGoddess();
		if ( !goddess.unlockedSkill )
			return;
		var sphereIncrease = dt * Const.get(SphereMaxRadius) / Const.get(SphereTransitionDuration);
		if ( hxd.Key.isPressed(hxd.Key.SPACE) && goddess.getSphereRemainingTime() > 0) {
			goddess.sphereActive = !goddess.sphereActive;
		}
		if ( goddess.sphereActive ) {
			goddess.temporalRadius += sphereIncrease;
		} else {
			goddess.temporalRadius -= sphereIncrease;
		}

		goddess.temporalRadius = hxd.Math.clamp(goddess.temporalRadius, 0.0, Const.get(SphereMaxRadius));
		goddess.temporalVisual.setScale(goddess.temporalRadius);
	}
}