import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDemo extends StatefulWidget {
  const VideoDemo({super.key});

  @override
  State<VideoDemo> createState() => _VideoDemoState();
}

class _VideoDemoState extends State<VideoDemo> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  List<String> videos = [
    "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
    "https://videos.pexels.com/video-files/855029/855029-hd_1280_720_60fps.mp4",
    "https://videos.pexels.com/video-files/4823938/4823938-hd_1080_1920_24fps.mp4"
  ];

  @override
  void initState() {
    super.initState();
    playNetworkVideo("https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4");
  }

  void playNetworkVideo(String path) {
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(path));
    videoPlayerController.initialize().then((value) {
      setState(() {});
    });
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      subtitle: Subtitles(
        [
          Subtitle(
            index: 0,
            start: const Duration(seconds: 0),
            end: const Duration(seconds: 4),
            text: "Su karo cho ??",
          ),
          Subtitle(
            index: 1,
            start: const Duration(seconds: 4),
            end: const Duration(seconds: 10),
            text: "Tamne kv",
          ),
          Subtitle(
            index: 2,
            start: const Duration(seconds: 10),
            end: const Duration(seconds: 16),
            text: "??",
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: videoPlayerController.value.aspectRatio,
              child: VideoPlayer(videoPlayerController),
            ),
            AspectRatio(
              aspectRatio: videoPlayerController.value.aspectRatio,
              child: Chewie(
                controller: chewieController,
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        playNetworkVideo(videos[index]);
                      },
                      child: Container(
                        color: Colors.black12,
                        margin: EdgeInsets.all(10),
                        child: Text("Video ${index + 1}"),
                      ),
                    );
                  },
                  itemCount: videos.length),
            ),
            FloatingActionButton(
              onPressed: () {
                playNetworkVideo("https://videos.pexels.com/video-files/855029/855029-hd_1280_720_60fps.mp4");
              },
              tooltip: 'Increment',
              child: Icon(Icons.play_arrow),
            ),
            FloatingActionButton(
              onPressed: () {
                chewieController.enterFullScreen();
              },
              tooltip: 'Increment',
              child: Icon(Icons.screen_lock_landscape),
            ),
          ],
        ),
      ),
    );
  }
}
