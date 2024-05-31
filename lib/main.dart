import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:media_player_app_new/video_demo.dart';

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

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  int cIndex = 0;

  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  late TabController tabController=TabController(length: 10, vsync: this);

  @override
  void initState() {
    assetsAudioPlayer.open(
        Playlist(
          audios: [
            Audio(
              "assets/audio/maan_meri_jaan.mp3",
              metas: Metas(
                title: "Maan meri jaan",
                image: const MetasImage.network(
                    "https://www.pagalworld.online/GpE34Kg9Gq/113834/152477-pushpa-pushpa-from-pushpa-2-the-rule-hindi-mp3-song-300.jpg"),
              ),
            ),
            Audio(
              "assets/audio/naach.mp3",
              metas: Metas(
                title: "Naach meri jaan",
                image: const MetasImage.network(
                    "https://www.pagalworld.online/GpE34Kg9Gq/113834/152477-pushpa-pushpa-from-pushpa-2-the-rule-hindi-mp3-song-300.jpg"),
              ),
            ),
            Audio.network(
              "https://files.freemusicarchive.org/storage-freemusicarchive-org/music/Music_for_Video/springtide/Sounds_strange_weird_but_unmistakably_romantic_Vol1/springtide_-_03_-_We_Are_Heading_to_the_East.mp3",
              metas: Metas(
                title: "Sringtide",
                image: const MetasImage.network(
                    "https://www.pagalworld.online/GpE34Kg9Gq/113834/152477-pushpa-pushpa-from-pushpa-2-the-rule-hindi-mp3-song-300.jpg"),
              ),
            ),
            Audio(
              "assets/audio/fateh_1.mp3",
              metas: Metas(
                title: "Fateh",
                image: const MetasImage.network(
                    "https://www.pagalworld.online/GpE34Kg9Gq/113604/152329-daaku-mp3-song-300.jpg"),
              ),
            ),
          ],
        ),
        autoStart: false);

    // tabController=TabController(length: 10, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Title",style: GoogleFonts.dancingScript()),
      ),
      body: Column(
        children: [
          TabBar(
            controller: tabController,
            indicatorColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            isScrollable: true,
            // indicator: BoxDecoration(
            //   color: Colors.black,
            //   shape: BoxShape.circle
            // ),

            tabs: [
              Tab(text: "Video"),
              Tab(text: "Audio"),
              Tab(text: "History"),
              Tab(text: "Category"),
              Tab(text: "Call"),
              Tab(text: "Audio"),
              Tab(text: "Video"),
              Tab(text: "History"),
              Tab(text: "Category"),
              Tab(text: "Call"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                VideoDemo(),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CarouselSlider(
                            items: List.generate(assetsAudioPlayer.playlist?.audios.length ?? 0, (index) {
                              var audio = assetsAudioPlayer.playlist?.audios[index];
                              return Container(
                                color: Colors.black12,
                                width: double.infinity,
                                margin: EdgeInsets.all(1),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(audio?.metas.image?.path ?? "", fit: BoxFit.fill),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 80,
                                        padding: EdgeInsets.all(15),
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Colors.transparent,
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                        ),
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(audio?.metas.title ?? "",
                                              style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            options: CarouselOptions(
                              aspectRatio: 2,
                              autoPlay: false,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.2,
                              viewportFraction: 0.9,
                              enableInfiniteScroll: false,
                              onPageChanged: (index, reason) {
                                cIndex = index;
                                setState(() {});
                                var audio = assetsAudioPlayer.playlist?.audios[index];
                                if (audio != null) {
                                  assetsAudioPlayer.open(audio);
                                }

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
                          StreamBuilder<Duration>(
                              stream: assetsAudioPlayer.currentPosition,
                              builder: (context, snapshot) {
                                print("currentPosition ${snapshot.data?.inSeconds}");
                                print("currentPosition1 ${assetsAudioPlayer.current.hasValue}");

                                Duration? currentDuration;
                                if (assetsAudioPlayer.current.hasValue) {
                                  currentDuration = assetsAudioPlayer.current.value?.audio.duration;
                                }

                                return Opacity(
                                  opacity: assetsAudioPlayer.current.hasValue ? 1 : 0.2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text("${snapshot.data?.inMinutes ?? 0.0}:"),
                                            Text("${(snapshot.data?.inSeconds ?? 0.0) % 60}".padLeft(2, '0')),
                                            Expanded(
                                              child: Slider(
                                                value: snapshot.data?.inSeconds.toDouble() ?? 0,
                                                min: 0,
                                                max: currentDuration?.inSeconds.toDouble() ?? 1,
                                                onChanged: (value) {
                                                  print("onChanged $value");
                                                  assetsAudioPlayer.seek(Duration(seconds: value.toInt()));
                                                },
                                              ),
                                            ),
                                            Text(
                                                "${currentDuration?.inMinutes ?? 0.0}:${currentDuration?.inSeconds ?? 0.0}"),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
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
                    Transform.rotate(
                      angle: pi * 1.5,
                      child: StreamBuilder<double>(
                          stream: assetsAudioPlayer.volume,
                          builder: (context, snapshot) {
                            var val = snapshot.data ?? 0;
                            return Slider(
                              value: val,
                              onChanged: (value) {
                                assetsAudioPlayer.setVolume(value);
                              },
                            );
                          }),
                    ),
                  ],
                ),
                Text("History"),
                Text("Category"),
                Text("Call"),
                Text("Video"),
                Text("History"),
                Text("Category"),
                Text("Call"),
                Text("Call"),

              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          tabController.index++;
          // tabController.animateTo(tabController.index+1);
        },
      ),
    );
  }
}
