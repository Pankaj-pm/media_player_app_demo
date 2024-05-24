import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int cIndex = 0;

  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    assetsAudioPlayer.open(
        Playlist(
          audios: [
            Audio("assets/audio/maan_meri_jaan.mp3"),
            Audio("assets/audio/naach.mp3"),
            Audio.network(
                "https://files.freemusicarchive.org/storage-freemusicarchive-org/music/Music_for_Video/springtide/Sounds_strange_weird_but_unmistakably_romantic_Vol1/springtide_-_03_-_We_Are_Heading_to_the_East.mp3"),
            Audio("assets/audio/fateh_1.mp3"),

          ],
        ),
        autoStart: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CarouselSlider(
              items: List.generate(5, (index) {
                return Container(
                  color: Colors.black12,
                  width: double.infinity,
                  margin: EdgeInsets.all(1),
                  child: Text("index $index"),
                );
              }),
              options: CarouselOptions(
                aspectRatio: 2,
                autoPlay: true,
                reverse: true,
                enlargeCenterPage: true,
                enlargeFactor: 0.2,
                viewportFraction: 0.9,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  cIndex = index;
                  setState(() {});
                  print("index $index");
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) {
                  bool isSelect = cIndex == index;
                  return Container(
                    height: isSelect ? 13 : 10,
                    width: isSelect ? 30 : 10,
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isSelect ? Colors.red : Colors.grey,
                    ),
                  );
                },
              ),
            ),
            Slider(value: 0.5, onChanged: (value) {

            },),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.small(
                  onPressed: () {
                    assetsAudioPlayer.previous();
                  },
                  tooltip: 'Increment',
                  child: const Icon(Icons.skip_previous),
                ),
                SizedBox(
                  width: 10,
                ),
                StreamBuilder<bool>(
                    stream: assetsAudioPlayer.isPlaying,
                    builder: (context, snapshot) {
                      bool isPlaying = snapshot.data ?? false;
                      return FloatingActionButton(
                        onPressed: () {
                          assetsAudioPlayer.playOrPause();
                        },
                        tooltip: 'Increment',
                        child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                      );
                    }),
                SizedBox(
                  width: 10,
                ),
                FloatingActionButton.small(
                  onPressed: () {
                    assetsAudioPlayer.next();
                  },
                  tooltip: 'Increment',
                  child: const Icon(Icons.skip_next),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
