// ignore: file_names
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import '../models/Song.dart';
import 'package:path_provider/path_provider.dart';
import 'FavoriteListScreen.dart';
import 'SongListScreen.dart';

class SongListView extends StatefulWidget {
  @override
  _SongListViewState createState() => _SongListViewState();
}

class _SongListViewState extends State<SongListView> {
  List<Song> songList = [];
  List<Song> songListFavorite = [];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeAppData();
  }

  Future<void> _initializeAppData() async {
    bool songsFileExists = await _checkSongsFileExists();

    if (!songsFileExists) {
      await _copySongsFileToDocumentsDirectory();
    }

    // Carrega os dados do arquivo JSON
    await _loadJsonData();
  }

  Future<bool> _checkSongsFileExists() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    File file = File('${documentsDirectory.path}/songs.json');
    return file.exists();
  }

  Future<void> _copySongsFileToDocumentsDirectory() async {
    ByteData data = await rootBundle.load('./assets/songs.json');
    List<int> bytes = data.buffer.asUint8List();
    String songsFilePath =
        '${(await getApplicationDocumentsDirectory()).path}/songs.json';
    await File(songsFilePath).writeAsBytes(bytes);
  }

  Future<void> _loadJsonData() async {
    String jsonString = await _loadSongsJson();
    if (jsonString.isNotEmpty) {
      List<dynamic> jsonData = json.decode(jsonString);
      List<Song> songs = jsonData.map((data) => Song.fromJson(data)).toList();
      setState(() {
        songList = songs;
        songListFavorite =
            songs.where((song) => song.favorito == true).toList();
      });
    }
  }

  Future<String> _loadSongsJson() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      File file = File('${documentsDirectory.path}/songs.json');
      return await file.readAsString();
    } catch (e) {
      print('Erro ao carregar músicas do arquivo JSON: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Favoritas',
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          SongListScreen(songList: songList),
          FavoriteListScreen(songList: songList),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.audiotrack_sharp),
            label: 'Músicas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_sharp),
            label: 'Favoritas',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF00BCD4),
        onTap: _onItemTapped,
      ),
    );
  }
}
