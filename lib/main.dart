import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';

final Color mycolor = Colors.blue;
void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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

  @override
  Widget build(BuildContext context) {
    bool isplaying = false;
    Widget home() {
      return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text(
                "Musico",
              ),
            ),
            backgroundColor: mycolor,
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
                            color: Colors.grey[700],
                            iconSize: 40,
                            icon: Icon(Icons.arrow_drop_down),
                            onPressed: () {}),
                      ),
                      Container(
                        child: IconButton(
                            color: Colors.cyan,
                            icon: Icon(Icons.library_music),
                            onPressed: () async {
                              result = await FilePicker.platform.pickFiles();
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
                      )
                    ],
                  ),
                  Center(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Color(0x46000000),
                            offset: Offset(0, 10),
                            spreadRadius: 0,
                            blurRadius: 30)
                      ], borderRadius: BorderRadius.circular(20)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset("assets/images/img.jpg")),
                      width: 225,
                      height: 225,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Song Title",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text("Artist Name, Label"),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(result != null
                          ? currenttime.toString().split(".")[0]
                          : "00.00"),
                      Container(
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
                                Duration seeked = Duration(seconds: second);
                                player.seek(seeked);
                                value = value;
                              });
                            }),
                      ),
                      Text(result != null
                          ? totaltime.toString().split(".")[0]
                          : "00.00")
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          icon: Icon(Icons.skip_previous), onPressed: () {}),
                      IconButton(
                          icon:
                              Icon(isplaying ? Icons.pause : Icons.play_arrow),
                          iconSize: 60,
                          onPressed: () {
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
                          }),
                      IconButton(icon: Icon(Icons.skip_next), onPressed: () {}),
                    ],
                  )
                ],
              ),
            ),
          ));
    }

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: home(),
    );
  }
}
