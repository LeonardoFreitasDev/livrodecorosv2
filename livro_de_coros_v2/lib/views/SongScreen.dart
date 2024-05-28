import 'package:flutter/material.dart';
import '../models/Song.dart';

class SongScreen extends StatelessWidget {
  final Song song;

  SongScreen({required this.song});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(song.titulo),
      ),
      body: ListView.builder(
        itemCount: song.letra.length,
        itemBuilder: (context, index) {
          return ListTile(
              title: Center(
            child: Text(song.letra[index]),
          ));
        },
      ),
    );
  }
}
