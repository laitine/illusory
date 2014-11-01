boolean manhattan = true; // Set false for euclid
colorMode(HSB, 325);

// Setup audio input
navigator.getUserMedia = (navigator.getUserMedia ||
                          navigator.webkitGetUserMedia ||
                          navigator.mozGetUserMedia ||
                          navigator.msGetUserMedia);

// Setup audio context
var audioCtx = new (window.AudioContext || window.webkitAudioContext)();

// Setup audio analyser
var analyser = audioCtx.createAnalyser();
analyser.fftSize = 2048;
var bufferLength = analyser.frequencyBinCount;
var waveformArray = new Uint8Array(bufferLength);
var frequencyArray = new Uint8Array(bufferLength);

void setup() {
  size(screen.width, screen.height);
  smooth();
  background(#2c3e50);
  //frameRate(75);

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
           alert("Error occured while getting audio data!");
        }
     );
  } else {
     console.log("getUserMedia not supported");
     alert("Your browser doesn't support getUserMedia!");
  }
}

void draw() {
  // Reset canvas
  background(#2c3e50);

  // Get waveform data
  analyser.getByteTimeDomainData(waveformArray);

  // Get volume
  var volume = getVolume(waveformArray);

  // Get frequency data
  analyser.getByteFrequencyData(frequencyArray);

  // Get Frequency bands
  var bands = getActiveFrequencyBands(frequencyArray);

  console.log(volume + " " + bands);

  // Draw manhattan diagram
  int numSites = volume;
  PVector[] sites = new PVector[numSites];
  color[] colors = new color[numSites];

  for (int i = 0; i < numSites; i++) {
      colors[i] = color(random(bands, 325), 60, 100);
      sites[i] = new PVector(random(width), random(width));
  }

  for (int x = 0; x < width; x++)
  {
      for (int y = 0; y < height; y++)
      {
          float minDistance = screen.width;
          int closestIndex = 0;

          for (int i = 0; i < numSites; i++)
          {
              float distance = manhattan ? abs(sites[i].x - x) + abs(sites[i].y - y) : dist(x, y, sites[i].x, sites[i].y);

              if (distance < minDistance) {
                  closestIndex = i;
                  minDistance = distance;
              }
          }
          set(x, y, colors[closestIndex]);
      }
  }

  /*
  // Draw polygon center
  for (int i = 0; i < numSites; i++) {
      ellipse(sites[i].x, sites[i].y, 5, 5);
  }*/
}

void resize(float x, float y) {
  size(x,y);
}

function getVolume(array) {
  float volume = 0;
  int values = 0;
  int length = array.length;

  for (var i = 0; i < length; i++) {
    //console.log("volume: " + array[i]);
    values += array[i];
  }
  volume = 130 - (values / length);
  volume *= 100;

  return int(volume);
}

function getActiveFrequencyBands(array) {
  int bands = 0;
  int threshold = 5;

  for (int i = 0; i < array.length; i++) {
    //console.log("frequency: " + array[i]);
    if (array[i] > threshold) {
      bands++;
    }
  }

  return bands;
}
