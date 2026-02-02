package ent.interactible;

class WeatherWheel extends Interactible {
    override function onInteract(ctrl : controllers.PlayerController) {
        super.onInteract(ctrl);
        trace("ee");
    }
}