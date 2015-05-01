var panelTitle = '.panel-title';
var sequenceView = '.seq-view';
var sequenceButton = '.seq-btn';
var dropdown = '#dropdown';
var track = '.track';

function Slot(name, container) {
	this.name = name;
	this.parent = container;
	this.sequence = null;
	this.behaviors = [];
	this.track = null;
}

Slot.prototype = {
	init: function() {
		var scope = this;
		this.DOM = $(slotPartial);
		// this.DOM.find("button.delete_slot").click($(this.remove()));
		$(this.DOM).find(panelTitle).append(this.name);
		$(this.DOM).find(panelTitle).data('parent_slot', this.name);
		$(this.DOM).find(sequenceButton).click(function() {
			scope.setSequence($(dropdown).val());
		});
		$(this.DOM).appendTo(this.parent);
		var newTrack = new Track(this.name, this.DOM);
		newTrack.init();
		this.track = newTrack;
	},
	setSequence: function(name) {
		var scope = this;
		this.sequence = sequences[name];
		$(this.DOM).find(sequenceView).append(name);
		$.map(sequences[name], function(e, i) {
			var wave = new Wave(i, e, false);
			var behavior = new LP(wave, false);
			scope.behaviors.push(behavior);
			scope.track.addBehavior(behavior);
		});
	},
	remove: function() {

	},
	toJSON: function() {

	},

}