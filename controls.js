// Controls
// Main script for controlling media.
// ----------------------------------------------------------------
// Variable Info:
// ----------------------------------------------------------------
// LOG.innerHTML - Put something in the "Log" box.
// ----------------------------------------------------------------
// h - Contains the HTML for the settings.
// ----------------------------------------------------------------
// db - Contains the database.
// ----------------------------------------------------------------
// c - Contains MIDI Settings
// ----------------------------------------------------------------




var osascript = require('node-osascript');
var db = {
	a: ['','',''],
	fadeDuration : 3,
	musicPlayer : 'Spotify'
};



var LOG = document.getElementById('log');
LOG.innerHTML = 'app loaded on ' + new Date();

// LEARNING
var learning = 0;
function learnMidi(id) {
	learning = parseInt(id);
	document.getElementById('log').innerHTML = 'Learning MIDI command '+id;
}

function build() {
var h = '<p><label onclick="musicIn()">Fade-In:</label> <b><span id="a0">'+db.a[1]+'</span></b> <span onclick="learnMidi(1)" type="button">Learn</span></p>';
h += '<p><label onclick="musicOut()">Fade-Out:</label> <b><span id="a1">'+db.a[2]+'</span></b> <span onclick="learnMidi(2)" type="button">Learn</span></p>';
document.getElementById('c').innerHTML = h;

var h = '<select class="form-select" id="fd" onchange="fadeDur()">';
for (var i = 0; i < 11; i++) {
	var v = i*.5;
	var s = (v==parseInt(db.fadeDuration))? ' selected':'';
	h += '<option value="'+v+'"'+s+'>'+v+' sec</option>'
}
h += '</select>';
document.getElementById('durr').innerHTML = h;

}




// Music Player Selection

var mplayerSelection = '<select id="mp" class="form-select" onchange="musicPlayer()">';
mplayerSelection += '<option value="Spotify">Spotify</option>';
mplayerSelection += '<option value="iTunes">iTunes</option>';
mplayerSelection += '</select>';

function musicPlayer() { 
	var Selection = document.getElementById('mp');
	var Selected = Selection.options[Selection.selectedIndex].value;
	db.musicPlayer = Selected;
	console.log('musicPlayer: '+Selected);
	document.getElementById('r').innerHTML = 'music player changed to '+Selected;
}

document.getElementById('mplayer').innerHTML = mplayerSelection;

function fadeDur() {
var d = document.getElementById('fd');
var c = d.options[d.selectedIndex].value;
db.fadeDuration = c;
localStorage.midiDB2 = JSON.stringify(db);
LOG.innerHTML = 'fade time changed to '+c+' seconds';
}

var midi, data;
// request MIDI access
if (navigator.requestMIDIAccess) {
navigator.requestMIDIAccess({
							sysex: false
							}).then(onMIDISuccess, onMIDIFailure);
} else {
LOG.innerHTML = "There is no MIDI support for external apps on your platform.";
}


// -------------------------------- MIDI --------------------------------

function onMIDISuccess(midiAccess) {
// when we get a succesful response, run this code
midi = midiAccess; // this is our raw MIDI data, inputs, outputs, and sysex status

var inputs = midi.inputs.values();
// loop over all available inputs and listen for any MIDI input
for (var input = inputs.next(); input && !input.done; input = inputs.next()) {
	// each time there is a midi message call the onMIDIMessage function
	input.value.onmidimessage = onMIDIMessage;
}
}

function onMIDIFailure(error) {
// when we get a failed response, run this code
LOG.innerHTML = "No access to MIDI devices or your browser doesn't support WebMIDI API. Please use WebMIDIAPIShim " + error;
}

function onMIDIMessage(message) {
data = message.data; // this gives us our [command/channel, note, velocity] data.
if (learning == 0) {
	for (var i = 0; i < db.a.length; i++) {
		if (db.a[i] == data.toString()) {
			if (parseInt(i) == 1) {
				if (db.musicPlayer == 'Spotify') {
					spotifyIn();
				} else if (db.musicPlayer == 'iTunes') {
					iTunesIn();
				}
			} else if (parseInt(i) == 2) {
				if (db.musicPlayer == 'Spotify') {
					spotifyOut();
				} else if (db.musicPlayer == 'iTunes') {
					iTunesOut();
				}

			} else {
				LOG.innerHTML = 'invalid command';
			}
		}
	}
} else {
	LOG.innerHTML = 'MIDI data', JSON.stringify(data); // MIDI data [144, 63, 73]
	db.a[learning] = data.toString();
	localStorage.midiDB2 = JSON.stringify(db);
	learning = 0;
	build();
}
}


// Dedicated In/Out
function musicIn() {
	if (db.musicPlayer == 'Spotify') {
		spotifyIn();
	} else if (db.musicPlayer == 'iTunes') {
		iTunesIn();
	}
}

function musicOut() {
	if (db.musicPlayer == 'Spotify') {
		spotifyOut();
	} else if (db.musicPlayer == 'iTunes') {
		iTunesOut();
	}
}



//---------------- APPLESCRIPT -----------------
function spotifyIn() {
var fade = db.fadeDuration / 100;
osascript.execute('tell application "Spotify"\nif player state is paused then\nset the sound volume to 0\nend if\nend tell\ntell application "Spotify"\nif player state is paused then\nplay\nend if\nset volumespotify to the sound volume\nrepeat\nrepeat with i from volumespotify to 100 by 1\nset the sound volume to i\ndelay '+fade+'\nend repeat\nexit repeat\nend repeat\nend tell');
LOG.innerHTML = 'Spotify faded in '+new Date();
}
function spotifyOut() {
var fade = db.fadeDuration / 100;
osascript.execute('tell application "Spotify"\nif player state is not paused then\nset volumespotify to the sound volume\nend if\nend tell\ntell application "Spotify"\nif player state is not paused then\nrepeat\nrepeat with i from volumespotify to 0 by -1\nset the sound volume to i\ndelay '+fade+'\nend repeat\npause\nexit repeat\nend repeat\nend if\nend tell');
LOG.innerHTML = 'Spotify faded out '+new Date();
}

function iTunesIn() {
	fade = db.fadeDuration / 100;
	osascript.execute('tell application "Music"\nif player state is paused then\nset snd to the sound volume\nset snd to 0\nplay\nrepeat\nrepeat with i from snd to 100 by 1\nset the sound volume to i\ndelay '+fade+'\nend repeat\nexit repeat\nend repeat\nend if\nend tell');
	LOG.innerHTML = 'iTunes faded in '+new Date();
}
function iTunesOut() {
	fade = db.fadeDuration / 100;
	osascript.execute('tell application "Music"\nif player state is not paused then\nset snd to the sound volume\nrepeat\nrepeat with i from snd to 0 by -1\nset the sound volume to i\ndelay '+fade+'\nend repeat\npause\nexit repeat\nend repeat\nend if\nend tell');
	LOG.innerHTML = 'iTunes faded out '+new Date();
}



// --------------- INIT -----------------
function init() {
//localStorage.midiDB2 = JSON.stringify(db);
if (localStorage.midiDB2) {
	db = JSON.parse(localStorage.midiDB2);
}
build();
}
init();
