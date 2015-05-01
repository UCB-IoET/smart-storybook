const ON_COLOR = 'rgb(241, 196, 15)';
const OFF_COLOR = '#e7e7e7';
const CLEAR = 'rgba(0, 0, 0, 0)';
const DEFAULT_LEN = 300;

var currWave;
var currBehavior;
var mixedWave;
var mixedBehavior;

/* Utility functions */

/**
 * Finds the behavior with behaviorName in the database and loads the
 * newly-constructed Behavior to target. e is the event passed by a handler.
 */
function getWave(e, behaviorName, target) {
	e.preventDefault();
	$('#preview-box').html('');
	$.ajax({
		type : "GET",
		dataType : "json",
		data : { 'name' : behaviorName },
		url : "/behaviors/get_states",
		success : function(data, textStatus, jqXHR) {
			NUMBER_ATTRS.forEach(function(e, i) {
				if (data[e]) {
					var row = "<strong>" + e + "</strong>" + ": " + data[e];
					$('#stat-box').append(
						'<div class="stat-entry">' + row + '</div>'
					);
				}
			});
			waveStates = data["states"];
			currWave = new Wave(behaviorName, waveStates, data["is_smooth?"]);
			currBehavior = new Behavior(currWave, false).load(target);
		} ,
		error: function(jqXHR, textStatus, errorThrown) {
			return errorThrown;
		}
	});
}

/**
 * Given lpIndex, samples the Behavior whose index is referenced at
 * canvasIndices[lpIndex].
 */
function recursiveSample(lpIndex) {
	getNthBehavior(lpIndex).sample(function() {
		if (lpIndex + 1 < canvasIndices.length) {
			recursiveSample(lpIndex + 1);
		}
	});
}

/**
 * Takes in a wrapper element jQuery object and modifies it such that
 * it toggles color and marked/unmarked on shift-click.
 */
function activateWrapper(wrapperEl) {
	wrapperEl.click(function(e) {
		if (e.shiftKey) {
			if ($(this).css('backgroundColor') != ON_COLOR) {
				$(this).css('backgroundColor', ON_COLOR);
				$(this).attr('marked', 'yes');
			} else {
				$(this).css('backgroundColor', CLEAR);
				$(this).attr('marked', 'no');	
			}
		}
	});
}

/**
 * Sequentially samples all Behaviors on the track.
 */
function play() {
	if (patterns.length == 0) { return; }
	redoIndices();
	recursiveSample(0);
}

/**
 * Ressign the values of canvasIndices based on the current arrangement
 * of Behaviors on the track.
 */
function redoIndices() {
	canvasIndices = $.map($('.track').children(), function(el, i) {
		return parseInt($(el).attr('index'), 10);
	});
}

/**
 * Adds a light pattern to the track based on the current value of the
 * variable addedBehavior. If there is one track on the page, adds to the
 * end of the track. If there are are two tracks, the function adds
 * the Behavior to an empty track. Does not add an Behavior when both tracks are
 * full. NOTE: undefined behavior for documents with more than two
 * tracks.
 */
var wrapper;
function addToTrack(addedBehavior) {
	if (currBehavior == null) { return; }
	if ($('.track').length > 1) {
		var trackName;
		if ($('#track-0').children().length == 0) {
			trackName = '#track-0';
		} else if ($('#track-1').children().length == 0) {
			trackName = '#track-1';
		} else {
			alert("Both tracks are full.");
			return;
		}
		placeBehavior(addedBehavior, $(trackName));
	} else {
		placeBehavior(addedBehavior, $('.track'));
	}
}

function placeBehavior(addedBehavior, target) {
	// $(addedBehavior).attr('index', patterns.length);
	console.log(addedBehavior,target.attr('class'));
	var wrapper = $('<div class="wrapper"></div>').appendTo(target);
	wrapper.attr('index', patterns.length);
	// wrapper.append(currBehavior.canvas);
	addedBehavior.load(wrapper);
	activateWrapper(wrapper);
	patterns.push(addedBehavior);
	currBehavior = null;
}

/* Returns an array with string FIELD from each LB on the track */
function getLBData(field) {
	var data = [];
	redoIndices();
	canvasIndices.forEach(function(e, i) {
		data.push(patterns[e][field]);
	});
	return data;
}

function removeMarked() {
	$('.wrapper[marked=yes]').remove();
}

function clearAll() {
	patterns = [];
	canvasIndices = [];
	$('.track').empty();
}

/**
 * Returns the nth Behavior from the left of the screen. E.g. getNthBehavior(0)
 * returns the leftmost Behavior visible.
 */
function getNthBehavior(n) {
	return patterns[canvasIndices[n]];
}

function apply(lp1, lp2, operator) {
	var newData = lp1.wave[operator](lp2.wave, false);
	currWave = new Wave("Wave", newData, false);
	mixedWave = currWave;
	currBehavior = new Behavior(currWave, false).load($('#output'));
	mixedBehavior = currBehavior;
	saver.sources.behavior = currBehavior; //NOTE: for OO implementation
}

/* Arrays for canvas-to-Behavior matching */
var patterns = [];
var canvasIndices = [];

/* Page control functions */

$(document).ready(function() {

	$(document).keypress(function(e) {
		if (!($('.modal').hasClass('in'))) {
			switch (e.charCode) {
				case 13: // ENTER for entering forms to a track
					addToTrack(currBehavior);
					break;
				case 97: // 'a' for add
					$('#output').empty();
					apply(getNthBehavior(0), getNthBehavior(1), "add");
					break;
				case 115: // 's' for subtract
					// TODO
					break;
				case 112: // 'p' for play
					play();
					break;
				case 100: // 'd' for delete
					/* Note: inactive Behaviors are retained in patterns.
					 * This eliminates the need for reindexing, but
					 * is a potential memory leak. */
					removeMarked();
					break;
				case 99: // 'c' for clear
					clearAll();
					break;
				case 101: // 'e' for export
					//TODO
					break;
			}
		}
	})

	$('.filter').click(function() {
		var filterName = $(this).attr('name');
		console.log(filterName);
		filterList = orderedLists[filterName];
		console.log(filterList);
		filterList.forEach(function(el) {
			var bgColor = $('[name=' + el + ']').css('background-color');
			if (bgColor != ON_COLOR) {
				$('[name=' + el + ']').css('background-color', ON_COLOR);
			} else {
				$('[name=' + el + ']').css('background-color', OFF_COLOR);
			}
		});
	});

	$('#dropdown').change(function(e) {
		e.preventDefault();
		$('#stat-box').html('');
		$('#preview-box').html('');
		getWave(e, $('#dropdown option:selected').val(),
				$('#preview-box'));
	});

	$('.behavior').click(function(e) {
		e.preventDefault();
		$('#stat-box').html('');
		$('#preview-box').html('');
		getWave(e, $(this).attr('name'), $('#preview-box'));
	});

	$('#enter-button').click(function() {
		addToTrack(currBehavior);
	});

	$('#delete-button').click(function() {
		removeMarked();
	});

	$('#clear-button').click(function() {
		clearAll();
	});

	$('#play-button').click(function() {
		play();
	});

	$('.mix-btn').click(function() {
		$('#output').empty();
		var operator = $(this).attr('id');
		redoIndices();
		apply(getNthBehavior(0), getNthBehavior(1), operator);
	});

});