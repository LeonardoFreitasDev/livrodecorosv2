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
        title: Text(
            '${widget.song.numero.toString() + '. ' + widget.song.titulo}'),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: widget.song.letra.map((line) {
                  return Text(
                    line,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: _fontSize,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            child: Text('-'),
            onPressed: () => {
              setState(() {
                _fontSize--;
              }),
            },
          ),
          ElevatedButton(
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
