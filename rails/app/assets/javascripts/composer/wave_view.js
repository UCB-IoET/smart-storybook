/*
 * Dependencies: 
 *  - requires page with instance 'api' of api.js,
 *  - requires _wave_view.html.erb
 *  - requires behavior.js
 */

function WaveView() {
	this.currentBehavior = null;
	this.dom = null;
	this.fieldDom = null;
	this.previewDom = null;
	this.repeatDom = null;
	this.stretchDom = null;
	this.preview;
	this.init();
}

WaveView.prototype = {
	init: function() {
		//TODO: fix hardcoding?
		var scope = this;
		this.dom = $('#current-wave');
		this.fieldDom = $('.field');
		this.previewDom = $('.preview');
		this.repeatDom = $('.repeat');
		this.stretchDom = $('.stretch');
		this.resetDom = $('.reset');
		this.repeatDom.change(function() {
			var num = parseInt(scope.repeatDom.val());
			var oldRepeat = scope.currentBehavior.wave.getRepeat();
			scope.currentBehavior.wave.setRepeat(num);
			scope.refresh();
		});
		this.stretchDom.change(function() {
			var num = parseInt(scope.stretchDom.val());
			var oldStretch = scope.currentBehavior.wave.getStretch();
			scope.currentBehavior.wave.setStretch(num);
			scope.refresh();
		});
		this.resetDom.click(function() {
			this.repeatDom.val(this.currentBehavior.wave.DEFAULT_REPEAT);
			this.stretchDom.val(this.currentBehavior.wave.DEFAULT_STRETCH);
			scope.currentBehavior.rate = scope.currentBehavior.DEFAULT_RATE;
			scope.currentBehavior.wave.reset();
			scope.refresh();
		})
		this.repeatDom.hide();
		this.stretchDom.hide();
	},
	loadBehavior: function(behaviorId) {
		var rawObj = api.get_async('/api/behaviors/' + behaviorId);
		var wave = new Wave(rawObj.name, rawObj.states, rawObj.is_smooth);
		var behavior = new Behavior(wave, false);
		behavior.preview = new Preview(this.previewDom);
		console.log(behavior);
		behavior.load(this.fieldDom);
		behavior.preview.switchRep("light"); // default to LED Rep, TODO: change later
		this.currentBehavior = behavior;

		this.repeatDom.show();
		this.stretchDom.show();
	},
	changeRepresentation: function(repName) {
		this.currentBehavior.preview.switchRep(repName);
	},
	refresh: function() {
		this.fieldDom.empty();
		this.currentBehavior.load(this.fieldDom);
	},
	clear: function() {
		this.stretchDom.val(scope.currentBehavior.wave.DEFAULT_STRETCH);
		this.repeatDom.val(scope.currentBehavior.wave.DEFAULT_REPEAT);
		this.currentBehavior = null;
		this.fieldDom.empty();
		this.previewDom.empty();
	}
}