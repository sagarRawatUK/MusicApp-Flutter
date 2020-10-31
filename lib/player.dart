import 'dart:io';
import 'package:MusicApp/Playlist.dart';
import 'package:flutter/material.dart';
import 'package:MusicApp/main.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:MusicApp/marqee.dart';
import 'package:path/path.dart' as path;
import 'package:audioplayers/audio_cache.dart';

class PLayer extends StatefulWidget {
  final File song;
  PLayer(this.song);

  @override
  _PLayerState createState() => _PLayerState();
}

class _PLayerState extends State<PLayer> {
  bool isplaying = false;
  double slidervalue = 0;
  AudioPlayer player = AudioPlayer();
  AudioCache cache = AudioCache();
  Duration currenttime;
  Duration totaltime;

  void initState() {
    super.initState();
    player.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        currenttime = duration;
      });
    });
    player.onDurationChanged.listen((Duration duration) {
      setState(() {
        totaltime = duration;
      });
    });
    playSong();
  }

  Future openSongList(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Songlist()));
  }

  @override
  void dispose() async {
    await player.release();
    await player.dispose();
    super.dispose();
  }

  Future playSong() async {
    setState(() {
      //player.stop();
      player.release();
    });

    String song = widget.song.path;
    print(song);
    if (widget.song != null) {
      int status = await player.play(song, isLocal: true);
      print(status);
      if (status == 1) {
        print("Playing Music");
        setState(() {
          isplaying = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "Merienda-Regular"),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: mybg,
          appBar: AppBar(
            title: Center(
              child: Text(
                "Musico",
                style: TextStyle(
                  color: mycolor,
                ),
              ),
            ),
            backgroundColor: Color(0xff1e272e),
          ),
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                            color: myseccolor,
                            iconSize: 40,
                            icon: Icon(Icons.arrow_drop_down),
                            onPressed: () {}),
                      ),
                      Container(
                        child: IconButton(
                          color: myseccolor,
                          icon: Icon(Icons.library_music),
                          onPressed: () => playSong(),
                        ),
                      ),
                      Container(
                        child: IconButton(
                            color: myseccolor,
                            icon: Icon(Icons.list),
                            onPressed: () {
                              openSongList(context);
                            }),
                      )
                    ],
                  ),
                  Center(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 10),
                            spreadRadius: 0,
                            blurRadius: 30)
                      ], borderRadius: BorderRadius.circular(20)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset("assets/images/img2.jpg")),
                      width: 225,
                      height: 225,
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  MarqueeWidget(
                    direction: Axis.horizontal,
                    child: Text(
                      widget.song != null
                          ? path.basenameWithoutExtension(widget.song.path)
                          : "Play Music ",
                      style: TextStyle(
                        fontSize: 18,
                        color: myseccolor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.song != null
                            ? currenttime.toString().split(".")[0]
                            : "00.00",
                        style: TextStyle(
                          color: myseccolor,
                        ),
                      ),
                      Container(
                        width: 250,
                        child: Slider(
                            value: widget.song != null
                                ? currenttime.inSeconds.toDouble()
                                : 0.0,
                            max: widget.song != null
                                ? totaltime.inSeconds.toDouble()
                                : 0.0,
                            min: 0.0,
                            activeColor: mycolor,
                            inactiveColor: Colors.grey,
                            onChanged: (double value) {
                              setState(() {
                                int second = value.toInt();
                                Duration seeked = Duration(seconds: second);
                                player.seek(seeked);
                                value = value;
                              });
                            }),
                      ),
                      Text(
                        widget.song != null
                            ? totaltime.toString().split(".")[0]
                            : "00.00",
                        style: TextStyle(
                          color: myseccolor,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          color: myseccolor,
                          icon: Icon(Icons.shuffle),
                          onPressed: () {}),
                      IconButton(
                          color: myseccolor,
                          icon: Icon(Icons.skip_previous),
                          onPressed: () {}),
                      IconButton(
                          color: Colors.white,
                          icon:
                              Icon(isplaying ? Icons.pause : Icons.play_arrow),
                          iconSize: 70,
                          onPressed: () {
                            if (widget.song != null) {
                              if (isplaying) {
                                player.pause();
                                setState(() {
                                  isplaying = false;
                                });
                              } else {
                                player.resume();
                                setState(() {
                                  isplaying = true;
                                });
                              }
                            }
                          }),
                      IconButton(
                          color: myseccolor,
                          icon: Icon(Icons.skip_next),
                          onPressed: () {}),
                      IconButton(
                          color: myseccolor,
                          icon: Icon(Icons.repeat),
                          onPressed: () {})
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
