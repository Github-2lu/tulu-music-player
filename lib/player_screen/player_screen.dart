import 'package:tulu_music_player/audioController/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<Controller>();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Obx(() => Text(
            controller.audioList[controller.playIndex.value].displayNameWOExt)),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.black, Colors.white54, Colors.white24])),
        child: Column(children: [
          Obx(
            () => Expanded(
                child: SizedBox(
              height: 350,
              width: 350,
              child: QueryArtworkWidget(
                id: controller.audioList[controller.playIndex.value].id,
                type: ArtworkType.AUDIO,
                artworkHeight: double.infinity,
                artworkWidth: double.infinity,
                nullArtworkWidget: const Icon(
                  Icons.music_note,
                  size: 150,
                ),
              ),
            )),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              //color: Colors.white,
              child: Column(
                children: [
                  Obx(() => Slider(
                      thumbColor: Colors.lightBlue,
                      activeColor: Colors.lightBlue,
                      inactiveColor: Colors.black26,
                      min: const Duration(seconds: 0).inSeconds.toDouble(),
                      max: controller.max.value,
                      value: controller.value.value,
                      onChanged: (newValue) {
                        controller.changePosition(newValue.toInt());
                      })),
                  Obx(
                    () => Row(
                      children: [
                        Text(controller.position.value),
                        const Spacer(),
                        TextButton(
                            onPressed: () {
                              controller.durationMode.value = controller.durationMode.value == 0?1:0;
                            },
                            child: Obx(() {
                              if(controller.durationMode.value == 0){
                                return Text(controller.duration.value, style: const TextStyle(color: Colors.black));
                              }
                              else{
                                return Text('-${controller.remainingDuration.value}', style: const TextStyle(color: Colors.black));
                              }
                            },))
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            controller.skipPrevious();
                          },
                          icon: const Icon(Icons.skip_previous_rounded,
                              size: 40)),
                      IconButton(
                          onPressed: () {
                            controller.replay_10();
                          },
                          icon: const Icon(Icons.replay_10_rounded, size: 40)),
                      CircleAvatar(
                        backgroundColor: Colors.black26,
                        radius: 35,
                        child: Transform.scale(
                          scale: 3,
                          child: Obx(
                            () => IconButton(
                                onPressed: () {
                                  controller.playPause();
                                },
                                icon: Icon(
                                  controller.isPlaying.value
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white54,
                                )),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            controller.forward_10();
                          },
                          icon: const Icon(Icons.forward_10_rounded, size: 40)),
                      IconButton(
                          onPressed: () {
                            controller.skipNext();
                          },
                          icon: const Icon(Icons.skip_next_rounded, size: 40))
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text('Volume', style: TextStyle(fontSize: 20),),
                      Expanded(
                        child: Obx(
                          () => Slider(
                              thumbColor: Colors.lightBlue,
                              activeColor: Colors.lightBlue,
                              inactiveColor: Colors.black26,
                              min: 0,
                              value: controller.volume.value,
                              max: 1,
                              onChanged: (newVolume) {
                                controller.changeVolume(newVolume);
                              }),
                        ),
                      ),
                      const SizedBox(width: 20,)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
