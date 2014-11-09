// Set mode
boolean mode = true; // true for manhattan and false for euclid
var param = window.location.search.substring(1);
if (param == "manhattan") {
  mode = true;
}

if (param == "euclid") {
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

void setup() {
  size(screen.width, screen.height);
  smooth();
  background(#2980b9);
  frameRate(60);
  loadPixels();

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

void draw() {
  // Get frequency data
  analyser.getByteFrequencyData(frequencyArray);

  // Get volume
  var volume = getVolume(frequencyArray);

  // Get Frequency bands
  var bands = getActiveFrequencyBands(frequencyArray);
  bands = 255 / bufferLength * bands;
  bands = 255 - int(bands);

  //console.log("volume: " + volume + " freqBands: " + bands);

  // Draw Voronoi diagram
  int numSites = volume;
  PVector[] sites = new PVector[numSites];
  color[] colors = new color[numSites];

  for (int i = 0; i < numSites; i++) {
    colors[i] = color(random(bands, 255), random(bands, 255), random(bands, 255));
    sites[i] = new PVector(random(width), random(width));
  }

  for (int x = 0; x < width; x++)
  {
      for (int y = 0; y < height; y++)
      {
          int closestIndex = 0;
          float minDistance = screen.width;

          for (int i = 0; i < numSites; i++)
          {
              float distance = mode ? abs(sites[i].x - x) + abs(sites[i].y - y) : dist(x, y, sites[i].x, sites[i].y);

              if (distance < minDistance) {
                  closestIndex = i;
                  minDistance = distance;
              }
          }
          pixels[x + (y * width)] = colors[closestIndex];
      }
  }

  updatePixels();
}

void resize(float x, float y) {
  size(x,y);
}

function getVolume(array) {
  int vol = 0;
  int values = 0;
  int length = array.length;

  for (var i = 0; i < length; i++) {
    values += array[i];
  }
  vol = values / length;

  return int(vol);
}

function getActiveFrequencyBands(array) {
  int bands = 0;
  int threshold = 10;
  length = array.length;

  for (int i = 0; i < length; i++) {
    if (array[i] > threshold) {
      bands++;
    }
  }

  return bands;
}
