import 'package:tulu_music_player/player_screen/player_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tulu_music_player/audioController/controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final controller = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Music'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: FutureBuilder<List<SongModel>>(
        future: controller.audioQuery.querySongs(
            ignoreCase: true,
            orderType: OrderType.ASC_OR_SMALLER,
            sortType: null,
            uriType: UriType.EXTERNAL),
        builder: (ctx, snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No song Found',
                style: TextStyle(color: Colors.black, fontSize: 28),
              ),
            );
          } else {
            controller.audioList = snapshot.data!;
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => Obx(
                () => ListTile(
                  tileColor: Colors.black54,
                  title: Text(
                    snapshot.data![index].displayNameWOExt,
                    maxLines: 1,
                    style: TextStyle(
                        color: controller.isPlaying.value &&
                                controller.playIndex.value == index
                            ? Colors.green
                            : Colors.white),
                  ),
                  subtitle: Text('${snapshot.data![index].artist}',
                      style: const TextStyle(color: Colors.white),
                      maxLines: 1),
                  trailing: Text(
                      Duration(milliseconds: snapshot.data![index].duration!)
                          .toString()
                          .split('.')[0],
                      style: const TextStyle(color: Colors.white)),
                  onTap: () {
                    Get.to(() => const PlayerScreen());
                    if (controller.playIndex.value != index || !controller.isPlaying.value) {
                      controller.playAudio(index: index);
                    }
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
