float radius = 50.0;
int X;
int Y;

// Setup audio input
navigator.getUserMedia = (navigator.getUserMedia ||
                          navigator.webkitGetUserMedia ||
                          navigator.mozGetUserMedia ||
                          navigator.msGetUserMedia);

// Setup audio context
var audioCtx = new (window.AudioContext || window.webkitAudioContext)();

// Setup analyser
var analyser = audioCtx.createAnalyser();
analyser.fftSize = 512; //1024;
var bufferLength = analyser.frequencyBinCount;
var dataArray = new Uint8Array(bufferLength);

void setup() {
  size(screen.width, screen.height);
  background(#95a5a6);
  fill(#c0392b);
  noStroke();
  frameRate(15);

  X = screen.width / 2 - radius;
  Y = screen.height / 2 - radius;

  // Get audio input
  if (navigator.getUserMedia) {
     navigator.getUserMedia (

        // constraints
        {
           video: false,
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
  }
}

void draw() {
  // Get audio data
  analyser.getByteTimeDomainData(dataArray);

  // Calculate shape
  var volume = getVolume(dataArray);
  console.log(volume);
  radius = volume * screen.width / 3;
  //radius = random() * screen.width / 3;

  // Reset canvas
  background(125);

  // Draw circle
  ellipse(X, Y, radius, radius);
}

void resize(float x, float y) {
  size(x,y);
}

function getVolume(array) {
  float volume = 0;
  var values = 0;
  var length = array.length;

  for (var i = 0; i < length; i++) {
     values += array[i];
  }

  volume = (values / length) / 128;

  return volume;
}
