function Library(){
	this.preload();
	this.init();
};

Library.prototype = {
	init: function(){
		var self = this;
		Library.set_actuators();
	},
	preload: function(){
		api.get_flavors(13);
		api.get_flavors(14);
		api.get_flavors(15);
		api.get_flavors(16);
		api.get_flavors(17);
		api.count("flavors");
		api.count("actuators");
	},
	get_selected: function(){
		return {
			actuator: Library.find_selected("#actuator-list"),
			flavor: Library.find_selected("#flavor-list"),
			tag: Library.find_selected("#tag-list"),
			behavior: Library.find_selected("#behavior-list")
		}
	}
}
	Library.find_selected = function(list){
		el = $(list).find('.selected2, .selected').children();
		return  el.length > 0 ? parseInt(el.attr('data-id')) : undefined;
	}
	Library.set_actuators = function(){
		$('#actuator-list table tr').not(".header").remove();
		api.get_actuators(function(data){
			$('#actuator-list .header').after(Library.listify(data, true, Library.set_flavors, "actuators", null, true));
		});	
	}
	Library.set_flavors = function(actuator_id){
		if(actuator_id == this.current_actuator) return;
		
		this.current_actuator = actuator_id;
		
		$('#flavor-list table tr').not(".header").remove();
		$('#tag-list table tr').not(".header").remove();
		this.current_flavor = undefined;
		api.get_flavors(actuator_id, function(data){
			$('#flavor-list .header').after(Library.listify(data, true, Library.set_tags, "flavors"));
		});
	}
	Library.set_tags = function(flavor_id){
		var self = this;			
		if(flavor_id == this.current_flavor) return;
		
		this.current_flavor = flavor_id;
		
		$('#tag-list table tr').not(".header").remove();
		

		api.get_tags(flavor_id, function(data){
			$('#tag-list .header').after(Library.listify(data, false, Library.set_behaviors, "tags", flavor_id));
		});	
	}

	Library.set_behaviors = function(flavor_id, label){
		if(label == this.current_label) return;

		this.current_label = label;
		$('#behavior-list table tr').not(".header").remove();
		console.log("setting_behaviors");
		api.get_behaviors_via_tags(flavor_id, label, function(data){
			console.log(data);
			$('#behavior-list .header').after(Library.listify(data, false, Library.set_wave, null, null, true));
		});	
	}
	Library.set_wave = function(behavior_id){
		if(behavior_id == this.current_behavior) return;
		this.current_behavior = behavior_id;
		if (waveView.currentBehavior) { waveView.clear(); }
		waveView.loadBehavior(behavior_id);
	}

Library.selected = function(el){
	$('.selected2').removeClass('selected2').addClass('selected');
	$(el).parent().addClass('selected2').siblings().removeClass('selected selected2')
}

Library.listify = function(els, has_decor, get, type, id, has_icon){
	console.log("iconed", type, has_icon)
	return $.map(els, function(el, i){
		// If no <next_order_semantic>  found, disable the caller;
		var count = type ? "(" + api.count(type, id)[el.id] + ")" : "";
		var nullify = count  == "(undefined)";
		var has_metadata = typeof el.duration !== "undefined";
		var count = nullify ? "" : count;

		
		var name = DOM.tag("td").addClass('noselect')
								.attr('data-id', el.id)
								.html(el.name + " "+ count)
								.click(function(){
									Library.selected(this);
									var elid = $(this).attr('data-id');
									
									if(id) get(id, elid);
									else get(elid);
									
								});

		if(nullify) name.addClass("disabled").unbind("click");

		// ROW LOGIC
		var row = DOM.tag("tr");
		if(has_icon){
			var icon = DOM.tag("img", true).attr("src", el.picture).addClass("icon");
			name.prepend(icon);
		}
		row.append(name);
		if(has_metadata){
			var metadata = DOM.tag("td").attr('data-id', el.id).html(el.duration);
			row.append(metadata);
		}
		if(has_decor && !nullify){
			var play = DOM.tag("span").addClass("glyphicon glyphicon-play").attr("aria-hidden","true");
			var decoration = DOM.tag("td").addClass('decoration-right').attr('data-id', el.id).html(play);
			row.append(decoration);
		}
		
		return row;
	});
} 

Library.on_behavior_click = function(){
	selected = lib.get_selected();
	code = JSON.stringify({addr: 3, behavior_id: selected.behavior, flavor_id: selected.flavor});
	payload = {command: {user_id: user_id, task_id: 3, code: code}};
	$.post("commands", payload, function(data){
		console.log(data);
	});
}
