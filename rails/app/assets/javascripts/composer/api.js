
	API.cache = {actuators: {}, flavors: {}, behaviors: {}}

	function API(){}
	API.cache = {};
	API.prototype = {
		get: function(url, callback){
			// console.log(url);
			var data = API.cache[url];
			if(typeof data !== "undefined"){ if(callback) callback(data); }
			else{
				$.getJSON(url, function(data){
					API.cache[url] = data;
					if(callback) callback(data);
				});
			}
			return true;
		},
		get_async: function(url){
			var data = API.cache[url];
			if(typeof data == "undefined"){
			  	data = JSON.parse($.ajax({ 
			      url: url, 
			      async: false
			   }).responseText);
			  API.cache[url] = data;
			}
			return data;
		},
		get_actuators : function(callback){
			return this.get("/api/actuators.json", callback);
		},
		get_flavors : function(actuator_id, callback){
			return this.get("/api/actuators/"+ actuator_id +"/flavors.json", callback);
		},
		get_behaviors : function(flavor_id, callback){
			return this.get("/api/tags/"+ flavor_id +"/behaviors.json", callback);
		},
		get_tags: function(flavor_id, callback){
			return this.get("/api/flavors/"+ flavor_id +"/tags.json", callback);
		},
		get_behaviors_via_tags: function(flavor_id, label, callback){
			return this.get("/api/tags/behaviors.json?flavor_id="+ flavor_id + "&label=" + label, callback);
		},
		count: function(type, id){
			if(type == "tags") {
				tags = this.get_async("/api/flavors/"+ id + "/tags.json");
				hash = {}
				$.each(tags, function(i, e){
					hash[e.id] = e.count;
				});
				return hash;
			}
			else return this.get_async("/api/"+ type + "/counts.json");
		},
	}