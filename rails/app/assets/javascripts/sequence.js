function Sequence(name, behaviors) {
	this.name = name;
	this.behaviors = behaviors;
}

Sequence.prototype = {
	getBehaviors: function() {
		return this.behaviors;
	}
}