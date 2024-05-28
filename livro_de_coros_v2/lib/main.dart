import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'models/Song.dart';
import 'views/SongScreen.dart';

void main() {
  runApp(MaterialApp(
    home: SongListView(),
    theme: ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF00BCD4),
      ),
    ),
  ));
}

class SongListView extends StatefulWidget {
  @override
  _SongListViewState createState() => _SongListViewState();
}

class _SongListViewState extends State<SongListView> {
  List<Song> songList = [];

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    String jsonString = await rootBundle.loadString('assets/songs.json');
    List<dynamic> jsonData = json.decode(jsonString);
    List<Song> songs = jsonData.map((data) => Song.fromJson(data)).toList();
    setState(() {
      songList = songs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Livro de Coros'),
      ),
      body: ListView.builder(
        itemCount: songList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Nº ${songList[index].numero.toString()}. '),
                Flexible(
                  child: Text(
                    songList[index].titulo,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            subtitle: Text('${songList[index].letra[0].toString()}...'),
            trailing: IconButton(
              icon: Icon(
                songList[index].favorito == true
                    ? Icons.favorite
                    : Icons.favorite_border,
                color:
                    songList[index].favorito == true ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  songList[index].favorito = !songList[index].favorito;
                });
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SongScreen(song: songList[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
