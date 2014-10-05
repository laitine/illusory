document.addEventListener("DOMContentLoaded", function(event) {
  window.AudioContext = window.AudioContext || window.webkitAudioContext;

  var context = new AudioContext();

  navigator.webkitGetUserMedia({audio: true}, function(stream) {
    var microphone = context.createMediaStreamSource(stream);
    microphone.connect(context.destination);
  }, errorCallback);
});

function errorCallback() {
  console.log("Error getting audio data!");
}
