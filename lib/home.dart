import 'dart:io';
import 'package:MusicApp/main.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class Songlist extends StatefulWidget {
  @override
  _SonglistState createState() => _SonglistState();
}

class _SonglistState extends State<Songlist> {
  @override
  void initState() {
    super.initState();
    initlist();
  }

  void initlist() async {
    if (await Permission.storage.request().isGranted) {
      Directory dir = await getExternalStorageDirectory();
      List<FileSystemEntity> files;
      files = dir.listSync(recursive: true, followLinks: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mybg,
      appBar: AppBar(
        title: Text("Your Media"),
        backgroundColor: mybg,
      ),
      /*new ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: files.length,
          itemBuilder: (context, i) {
            return buildRow(_files.elementAt(i).path);
          }), */
    );
  }
}
