import 'package:MusicApp/Playlist.dart';
import 'package:flutter/material.dart';

final Color mycolor = Color(0xff05c46b);
final Color myseccolor = Color(0xfff5f6fa);
final Color mybg = Color(0xff1e272e);

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(fontFamily: "Merienda-Regular"),
        debugShowCheckedModeBanner: false,
        home: Songlist());
  }
}
