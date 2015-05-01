function Preview(container) {
	this.actuators = null;
	this.container = container;
	this.active_actuator = null;
	this.init();
}

Preview.prototype = {
	init: function() {
		this.actuators = { light: new LEDRep(), motor: new motorRep() };
		this.active_actuator = this.actuators.led;
	},
	getRep: function() {
		return this.active_actuator;
	},
	switchRep: function(newRep) {
		this.container.empty();
		this.active_actuator = this.actuators[newRep];
		this.active_actuator.DOM.appendTo(this.container);
	},
	channel: function(val) {
		this.active_actuator.changeColor(val);
	},
}

function LEDRep() {
	this.DOM = null;
	this.init();
}

LEDRep.prototype = {
	init: function() {
		this.DOM = $(".led.template").clone().attr('class', 'led');
	},
	changeColor: function(value) {
		value *= 2;
		this.DOM.children('#LEDColor').children().attr('fill-opacity', value);
	}
}

function motorRep() {
	this.DOM = null;
	this.init();
}

motorRep.prototype = {
	init: function() {
		this.DOM = $(".motor.template").clone().attr('class', 'motor');;
	},
	//TODO: implement the rest
}
