import 'package:MusicApp/home.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';

final Color mycolor = Color(0xff05c46b);
final Color myseccolor = Color(0xfff5f6fa);

final Color mybg = Color(0xff1e272e);
void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isplaying = false;
  FilePickerResult result;
  double slidervalue = 0;
  AudioPlayer player = new AudioPlayer();
  Duration currenttime;
  Duration totaltime;

  @override
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
  }

  Future openSongList(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Songlist()));
  }

  @override
  Widget build(BuildContext context) {
    Widget home() {
      return MaterialApp(
          theme: ThemeData(fontFamily: "Merienda-Regular"),
          debugShowCheckedModeBanner: false,
          home: Builder(
            builder: (context) => Scaffold(
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
                                  onPressed: () async {
                                    result =
                                        await FilePicker.platform.pickFiles();
                                    if (result != null) {
                                      int status = await player.play(
                                          result.files.single.path,
                                          isLocal: true);
                                      if (status == 1) {
                                        setState(() {
                                          isplaying = true;
                                        });
                                      }
                                    }
                                  }),
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
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 30),
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                  color: Color(0x46000000),
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
                          height: 70,
                        ),
                        Text(
                          result != null
                              ? result.files.single.name.split(".")[0]
                              : "Play Music ",
                          style: TextStyle(
                            fontSize: 18,
                            color: myseccolor,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              result != null
                                  ? currenttime.toString().split(".")[0]
                                  : "00.00",
                              style: TextStyle(
                                color: myseccolor,
                              ),
                            ),
                            Container(
                              width: 250,
                              child: Slider(
                                  value: result != null
                                      ? currenttime.inSeconds.toDouble()
                                      : 0.0,
                                  max: result != null
                                      ? totaltime.inSeconds.toDouble()
                                      : 0.0,
                                  min: 0.0,
                                  activeColor: mycolor,
                                  inactiveColor: Colors.grey,
                                  onChanged: (double value) {
                                    setState(() {
                                      int second = value.toInt();
                                      Duration seeked =
                                          Duration(seconds: second);
                                      player.seek(seeked);
                                      value = value;
                                    });
                                  }),
                            ),
                            Text(
                              result != null
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
                                color: myseccolor,
                                icon: Icon(
                                    isplaying ? Icons.pause : Icons.play_arrow),
                                iconSize: 60,
                                onPressed: () {
                                  if (result != null) {
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
          ));
    }

    return new MaterialApp(
        theme: ThemeData(fontFamily: "Merienda-Regular"),
        debugShowCheckedModeBanner: false,
        home: home());
  }
}
