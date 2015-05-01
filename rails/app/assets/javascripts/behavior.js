// fn = $(".led-value").css('opacity', val);

var hitOptions = {
	segments: true,
	stroke: true,
	fill: true,
	tolerance: 5
};

function Behavior(wave, isSVG){
	if(typeof isSVG === "undefined") isSVG = false;
	this.name = wave.name;
	this.wave = wave;
	this.interval = null;
	this.isSVG = isSVG;
	this._boundinterval = null;
	this.index = 0;
	this.states = [];
	this.linked = { next: null, prev: null };
	this.preview = null;
}

Behavior.prototype = {
	setPreview: function(dom) {
		this.preview = new Preview(dom);
	},
	// an output channel event - onSample event -- 
	// TODO - turn this into a binder
	channel: function(val){
		this.states[this.index] = val;
		this.preview.channel(1 - val);
		// console.log(val);
	},
	//return the document object representation
	load: function(c){
		var scope = this;
		this.canvas = DOM.tag("canvas")
				.prop('resize', true)
				.dblclick(function(){
					scope.sample(function() {});
				})
				.mousedown(function(event) {
					scope._segment = scope._path = null;
					var hitResult = scope.paper.project.hitTest(event.point, hitOptions);
					if (!hitResult) return;
					scope._path = hitResult.item;
					if (hitResult.type == 'segment') {
						scope._segment = hitResult.segment;
					}
				})
				.mousemove(function(){
					if (scope._segment) {
						scope._segment.point += event.delta;
						if (scope.wave.isSmooth) {
							scope.path.smooth();
						}
						scope.paper.view.update();
					}
				})
				.mouseup(function(){
					scope._segment = scope._path = null;
				})

		c.append(this.canvas);	
		this.paper = new paper.PaperScope();
		this.paper.setup(this.canvas[0]);
		
		this.height = this.paper.view.size.height;
		this.width = this.paper.view.size.width;
		this.tracker = this.draw(Behavior.trackerLine);
		this.axis = this.draw(Behavior.axis);

		if(!this.isSVG){
			this.states = this.wave.dataPts(this.paper.view.size);
			this.path = this.draw(Behavior.plot, {points: this.states, isSmooth: this.wave.isSmooth });
			var scope = this;
			this._boundinterval = setInterval(function(){ scope.bound()}, 50);
			// console.log(this.states);
			
		}
		else{
			this.paper.project.importSVG(this.wave, true);//this.paper.importSVG(this.wave);
			
			// update boundary conditions
			var scope = this;
			this._boundinterval = setInterval(function(){ scope.bound()}, 50);
		}
		return this;
	},
	bound: function(){
		if(this.isSVG)
			this.path = this.getSVG();
		
		if(typeof this.path === "undefined") return;
		else{
			this.path.fitBounds(this.paper.project.layers[0].bounds);
			this.paper.view.update();
			
			if(this.wave == "/lb/LB_Lighthouse.svg")
				this.path = this.path._children[2];
			else if(this.wave == "/lb/LB_EKG.svg")
				this.path = this.path._children[1];
			else if(this.isSVG)
				this.path = this.path._children[0];

			clearInterval(this._boundinterval);
		}
	},
	getSVG: function(){
		return this.paper.project.layers[0]._children[2];
	},
	draw: function(routine, params){
		var rtn = routine(this.paper, params);
		this.paper.view.draw();
		return rtn;
	},
	sample: function(fn){
		if (!this.preview.getRep()) {
			alert("Need to assign an actuator to " + this.name);
			return;
		}
		var scope = this;
		var slice = function(){
			scope._slice(function(v){ scope.channel(v); }, fn);
		}
		if(!this.interval)
			console.log(this.wave.getRate());
			this.interval = setInterval(slice, this.wave.getRate());
	},
	_slice: function(channel, fn){
		this.tracker.position.x += this.width/500; // delta x
		var intersections = this.tracker.getIntersections(this.path);
		
		for (var i = 0; i < intersections.length; i++) {
			var val = (intersections[i].point.y/(this.height/1.35));
			channel(val);
			this.index++;
		}

		if(this.tracker.position.x > this.width) {
			this.tracker.position.x = 0;
			clearInterval(this.interval);
			this.interval = null;
			fn(this.wave, this.states);
			this.index = 0;
		}
		this.paper.view.update();
	}
}


Behavior.plot = function(paper, params, isSmooth){
	var path = new paper.Path({
		segments: params.points,
		strokeColor: 'black',
		strokeWidth: 4,
		fullySelected: true
	});
	if (params.isSmooth) {
		path.smooth();
	}
	paper.project.activeLayer.selected = false;
	return path;
	
}

Behavior.axis = function(paper){
	axis = new paper.Path();
	axis.strokeColor = '#CCC';
	axis.strokeWidth = 2;
	axis.add(new paper.Point(0, paper.view.size.height/2.0));
	axis.add(new paper.Point(paper.view.size.width, paper.view.size.height/2.0));
	axis.selected = false;
	return axis;
}

Behavior.trackerLine = function(paper){
	var path = new paper.Path();
	path.strokeColor = 'blue';
	path.strokeWidth = 2;
	path.add(new paper.Point(0, 0));
	path.add(new paper.Point(0, paper.view.size.height));
	path.selected = false;
	return path;
}
	