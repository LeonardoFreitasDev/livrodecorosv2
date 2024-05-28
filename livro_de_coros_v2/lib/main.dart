import 'package:flutter/material.dart';
import 'package:livro_de_coros_v2/views/SongListView.dart';

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
