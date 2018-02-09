// Set mode
var mode = true; // true for manhattan and false for euclid
var param = window.location.search.substring(1);

if (param == "manhattan") {
  mode = true;
} else if (param == "euclid") {
  mode = false;
}

// Setup audio input
navigator.getUserMedia = (navigator.getUserMedia ||
                          navigator.webkitGetUserMedia ||
                          navigator.mozGetUserMedia ||
                          navigator.msGetUserMedia);

// Setup audio context
var audioCtx = new (window.AudioContext || window.webkitAudioContext)();

// Setup audio analyser
var analyser = audioCtx.createAnalyser();
analyser.fftSize = 32;
var bufferLength = analyser.frequencyBinCount;
var frequencyArray = new Uint8Array(bufferLength);

function setup() {
  createCanvas(windowWidth, windowHeight);
  background('#2980b9');
  smooth();
  frameRate(60);

  // Get audio input
  if (navigator.getUserMedia) {
     navigator.getUserMedia (
        // constraints
        {
           audio: true
        },

        // successCallback
        function(localMediaStream) {
          var microphone = audioCtx.createMediaStreamSource(localMediaStream);
          microphone.connect(analyser);
        },

        // errorCallback
        function(err) {
           console.log("The following error occured: " + err);
        }
     );
  } else {
     console.log("getUserMedia not supported");
     alert("Your browser doesn't support getUserMedia!");
  }
}

function draw() {
  // Get frequency data
  analyser.getByteFrequencyData(frequencyArray);

  // Get volume
  var volume = getVolume(frequencyArray);

  // Get Frequency bands
  var bands = getActiveFrequencyBands(frequencyArray);
  bands = 255 / bufferLength * bands;
  bands = 255 - int(bands);

  // Draw Voronoi diagram
  var numSites = volume;
  var sites = new Array(numSites);
  var colors = new Array(numSites);

  for (var i = 0; i < numSites; i++) {
    colors[i] = color(random(bands, 255), random(bands, 255), random(bands, 255));
    sites[i] = createVector(random(width), random(height));
  }

  loadPixels();
  var density = pixelDensity();

  if (colors.length !== 0) {
    for (var x = 0; x < windowWidth; x++) {
      for (var y = 0; y < windowHeight; y++) {
        var closestIndex = 0;
        var minDistance = windowWidth;

        for (var i = 0; i < numSites; i++) {
          var distance = mode ? abs(sites[i].x - x) + abs(sites[i].y - y) : dist(x, y, sites[i].x, sites[i].y);

          if (distance < minDistance) {
            closestIndex = i;
            minDistance = distance;
          }
        }

        for (var i = 0; i < density; i++) {
          for (var j = 0; j < density; j++) {
            var indx = 4 * ((y * density + j) * width * density + (x * density + i));
            pixels[indx] = red(colors[closestIndex]);
            pixels[indx + 1] = green(colors[closestIndex]);
            pixels[indx + 2] = blue(colors[closestIndex]);
            pixels[indx + 3] = alpha(colors[closestIndex]);
          }
        }
      }
    }
  }

  updatePixels();
}

function windowResized() {
  resizeCanvas(windowWidth, windowHeight);
}

function getVolume(array) {
  var vol = 0;
  var values = 0;
  var length = array.length;

  for (var i = 0; i < length; i++) {
    values += array[i];
  }
  vol = values / length;

  return int(vol);
}

function getActiveFrequencyBands(array) {
  var bands = 0;
  var threshold = 10;
  length = array.length;

  for (var i = 0; i < length; i++) {
    if (array[i] > threshold) {
      bands++;
    }
  }

  return bands;
}
