import 'dart:io';
import 'package:MusicApp/main.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'marqee.dart';

final Color songbg = Color(0xff2c3e50);

class Songlist extends StatefulWidget {
  @override
  _SonglistState createState() => _SonglistState();
}

class _SonglistState extends State<Songlist> {
  Directory dir = Directory('/storage/emulated/0/');
  List<FileSystemEntity> _files;
  List<FileSystemEntity> _songs = [];
  @override
  void initState() {
    super.initState();
    initlist();
  }

  void initlist() async {
    if (await Permission.storage.request().isGranted) {
      String mp3Path = dir.toString();
      print(mp3Path);
      setState(() {
        _files = dir.listSync(recursive: true, followLinks: false);
        for (FileSystemEntity entity in _files) {
          String path = entity.path;
          if (path.endsWith('.mp3') || path.endsWith('.m4a'))
            _songs.add(entity);
        }
      });
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: _songs.length,
            itemBuilder: (context, i) {
              return Card(
                color: mybg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed("MyApp", arguments: {
                        'path': _songs[i],
                      });
                    },
                    child: ListTile(
                      dense: true,
                      trailing: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.blueGrey,
                        child: Text((i + 1).toString()),
                      ),
                      title: MarqueeWidget(
                        direction: Axis.horizontal,
                        child: Text(
                          path.basenameWithoutExtension(_songs[i].toString()),
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
