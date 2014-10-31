float radius = 50.0;
int shapeX;
int shapeY;
int nodeX = 0;
int nodeY = 0;
var nodes = [];

// Setup audio input
navigator.getUserMedia = (navigator.getUserMedia ||
                          navigator.webkitGetUserMedia ||
                          navigator.mozGetUserMedia ||
                          navigator.msGetUserMedia);

// Setup audio context
var audioCtx = new (window.AudioContext || window.webkitAudioContext)();

// Setup audio analyser
var analyser = audioCtx.createAnalyser();
analyser.fftSize = 512; //1024;
var bufferLength = analyser.frequencyBinCount;
var dataArray = new Uint8Array(bufferLength);

void setup() {
  size(screen.width, screen.height);
  background(#95a5a6);
  smooth();
  fill(#c0392b);
  //noStroke();
  frameRate(25);

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
           alert("An error occured! :(");
        }
     );
  } else {
     console.log("getUserMedia not supported");
     alert("Your browser doesn't support getUserMedia!");
  }

  // Position of shape
  shapeX = screen.width / 2 - radius;
  shapeY = screen.height / 2 - radius;
}

void draw() {
  // Get audio data
  analyser.getByteTimeDomainData(dataArray);

  // Reset canvas
  background(#95a5a6);

  // Get volume
  var volume = getVolume(dataArray);


  // Generate nodes
  for (var a = 0; a < int(volume); a++) {
    nodes.push({x: int( random(0, screen.width) ), y: int( random(0, screen.height) )});
  }

  // Draw arcs
  for (var b = 1; b < nodes.length; b++) {
    line(nodes[b-1].x, nodes[b-1].y, nodes[b].x, nodes[b].y);
  }


  // Calculate shape
  radius = volume * screen.width / 3;

  // Draw circle
  ellipse(shapeX, shapeY, radius, radius);
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
