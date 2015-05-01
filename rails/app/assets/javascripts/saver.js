/**
 * Usage:
 * Layer: 'behavior', 'sequence', or 'scheme'
 * DOM: save_modal partial supplied by caller
 * Sources: a hash containing object that the Saver object will read
 * from. Keys must be: 'behavior', 'sequence', or 'scheme'
 */

function Saver(layer, DOM, sources) {
	this.layer = layer;
	this.DOM = DOM;
	this.sources = sources;
}

var saveButton = '#save-btn';
var jsonButton = '#json-btn';
var cppButton = '#cpp-btn';

Saver.prototype = {
	init: function() {
		$('body').append(this.DOM);
		console.log($(this.DOM).find(saveButton));
		var scope = this;
		/* Kludge: need to reference DOM buttons by absolute selectors
		 * due to modal. */
		$(saveButton).click(function(e) {
			switch (scope.layer) {
				case "behavior":
					saveBehavior($('#name-field').val(), mixedWave.getData());
					break;
				case "sequence":
					saveSequence($('#name-field').val(), getLBData("name")); // the Behaviors
					break;
				case "scheme":
					saveScheme();
					break;
			}
		});

		$(jsonButton).click(function(e) {
			switch (scope.layer) {
				case "behavior":
					exportJSON($('#name-field').val(), scope.sources.behavior.wave.getData(), 'behavior');
					break;
				case "sequence":
					exportJSON($('#name-field').val(), sources.sequence.getData(), 'sequence');
					break;
				case "scheme":
					break;
			}
		});

		$(cppButton).click(function(e) {
			switch (scope.layer) {
				case "behavior":
					exportCPP($('#name-field').val(), scope.sources.behavior.wave.data, 'behavior');
					break;
				case "sequence":
					exportCPP($('#name-field').val(), scope.sources.sequence.getData(), 'sequence');
					break;
			}
		});
	},

}

/* Utility functions */

const ERROR_MAX_LEN = 20;

function exportJSON(name, states, layer) {
	var jsonStr = {};
	jsonStr[layer] = { 'name': name, 'states': states };
	var jsonContent = JSON.stringify(jsonStr);
	var blob = new Blob([jsonContent], { type: 'text/json' });
	var link = document.createElement("a");
	link.setAttribute("href", URL.createObjectURL(blob));
	link.setAttribute("download", name + ".json");
	link.click();
}

function exportCPP(name, states, layer) {
	var cppStr = {};
	cppStr[layer] = { 'name': name, 'states': states };
	$.ajax({
		type: "POST",
		url: "/" + layer + "s/json_to_cpp",
		data : cppStr,
		success: function(data, textStatus, jqXHR) {
			var blob = new Blob([data.cpp], { type: 'text/json' });
			var link = document.createElement("a");
			link.setAttribute("href", URL.createObjectURL(blob));
			link.setAttribute("download", name + ".h");
			link.click();
		},
		error: function() {}
	});
}

function saveBehavior(name, states) {
	$.ajax({
		beforeSend: function(xhr) {
			xhr.setRequestHeader('X-CSRF-TOKEN', 
				$('meta[name="csrf-token"]').attr('content'));
		},
		type: "POST",
		url: "/behaviors/create",
		data: { 'behavior' : { 'name': name, 'states': states } } ,
		dataType: "json",
		success: function() { alert("Saved to library."); } ,
		error: function(data, textStatus, xhr) {
			var errorMessage = (data.responseText.length > ERROR_MAX_LEN)
								? "Error -- please see console"
								: data.responseText;
			alert(errorMessage);
			console.log(data);
			console.log(textStatus);
			return false;
		}
	});
}

function saveSequence(name, behaviors) {
	$.ajax({
		beforeSend: function(xhr) {
			xhr.setRequestHeader('X-CSRF-TOKEN', 
				$('meta[name="csrf-token"]').attr('content'));
		},
		type: "POST",
		url: "/sequences/create",
		data: { 'sequence' : { 'name': name, 'behaviors': behaviors } } ,
		dataType: "json",
		success: function() { alert("Saved to library."); } ,
		error: function(data, textStatus, xhr) {
			var errorMessage = (data.responseText.length > ERROR_MAX_LEN)
								? "Error -- please see console"
								: data.responseText;
			alert(errorMessage);
			console.log(data);
			console.log(textStatus);
			return false;
		}
	});
}