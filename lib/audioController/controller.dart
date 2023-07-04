import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

class Controller extends GetxController {
  @override
  void onInit() {
    super.onInit();
    checkPermission();
  }

  checkPermission() async {
    var permission = await Permission.audio.request();
    if (permission.isGranted) {
    } else {
      checkPermission();
    }
  }

  final audioPlayer = AudioPlayer();
  final audioQuery = OnAudioQuery();
  var isPlaying = false.obs;
  RxInt playIndex = (-1).obs;
  var duration = ''.obs;
  var position = ''.obs;
  var max = 10.0.obs;
  var value = 0.0.obs;
  List<SongModel> audioList = [];
  var volume = 0.5.obs;
  var durationMode =0.obs;
  var remainingDuration = ''.obs;

  playAudio({required int index}) {
    try {
      playIndex.value = index;
      var uri = audioList[playIndex.value].uri;
      isPlaying.value = true;
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioPlayer.setVolume(volume.value);
      durationMode.value = 0;
      audioPlayer.play();
      updatePosition();
    } on Exception {
      //show Alert Box
    }
  }

  updatePosition() {
    audioPlayer.durationStream.listen((d) {
      duration.value = d.toString().split('.')[0];
      max.value = d!.inSeconds.toDouble();
    });
    audioPlayer.positionStream.listen((p) {
      position.value = p.toString().split('.')[0];
      value.value = p.inSeconds.toDouble();
      remainingDuration.value = (Duration(milliseconds: audioList[playIndex.value].duration!) - p).toString().split('.')[0];

      if (value.value >= max.value) {
        changePosition(0);
        isPlaying.value = false;
        audioPlayer.pause();
      }
    });
  }

  playPause() {
    if (isPlaying.value) {
      isPlaying.value = false;
      audioPlayer.pause();
    } else {
      isPlaying.value = true;
      audioPlayer.play();
    }
  }

  changePosition(int newValue) {
    audioPlayer.seek(Duration(seconds: newValue));
  }

  skipPrevious() {
    if (playIndex.value > 0) {
      int index = playIndex.value - 1;
      playAudio(index: index);
    }
  }

  replay_10() {
    final newValue = value.value.toInt() - 10;
    changePosition(newValue > 0 ? newValue : 0);
  }

  forward_10() {
    final newValue = value.value.toInt() + 10;
    final limit = max.value.toInt();
    if (newValue > limit) {
      isPlaying.value = false;
      audioPlayer.pause();
      changePosition(0);
    } else {
      changePosition(newValue);
    }
  }

  skipNext() {
    int index = playIndex.value + 1;
    if (index < audioList.length) {
      playAudio(index: index);
    }
  }

  changeVolume(double newVolume){
    volume.value = newVolume;
    audioPlayer.setVolume(newVolume);
  }
}
