import 'package:flutter/material.dart';
import '../models/Song.dart';

class SongScreen extends StatefulWidget {
  final Song song;

  SongScreen({required this.song});

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  double _fontSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.song.titulo),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widget.song.letra.map((item) {
            return Center(
              child: Text(
                item,
                style: TextStyle(fontSize: _fontSize),
              ),
            );
          }).toList(),
        ),
      ),

      // ListView.builder(
      //   itemCount: widget.song.letra.length,
      //   itemBuilder: (context, index) {
      //     return ListTile(
      //         title: Text(
      //       widget.song.letra[index],
      //       style: TextStyle(
      //         fontSize: _fontSize,
      //         fontWeight: FontWeight.bold,
      //       ),
      //       softWrap: true,
      //       textAlign: TextAlign.center,
      //     ));
      //   },
      // ),
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            child: Text('-'),
            onPressed: () => {
              setState(() {
                _fontSize--;
              }),
            },
          ),
          FloatingActionButton.small(
            child: Text('+'),
            onPressed: () => {
              setState(() {
                _fontSize++;
              }),
            },
          ),
        ],
      ),
    );
  }
}
