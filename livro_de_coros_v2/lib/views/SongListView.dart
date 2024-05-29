// ignore: file_names
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import '../models/Song.dart';
import '../views/SongScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'FavoriteListScreen.dart';
import 'SongListScreen.dart';

class SongListView extends StatefulWidget {
  @override
  _SongListViewState createState() => _SongListViewState();
}

class _SongListViewState extends State<SongListView> {
  List<Song> songList = [];

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

  // Future<void> saveSongsToJson(List<Song> songs) async {
  //   try {
  //     // Obter o diretório de documentos do aplicativo
  //     Directory directory = await getApplicationDocumentsDirectory();
  //     File file = File('${directory.path}/songs.json');

  //     // Converter a lista de músicas para JSON
  //     List<Map<String, dynamic>> jsonData =
  //         songs.map((song) => song.toJson()).toList();

  //     // Escrever os dados JSON de volta no arquivo
  //     await file.writeAsString(json.encode(jsonData));
  //   } catch (e) {
  //     print('Erro ao salvar músicas no arquivo JSON: $e');
  //   }
  // }

  // Future<void> updateSongFavorite(Song song, List<Song> songList) async {
  //   // Carregar as músicas existentes do arquivo JSON
  //   List<Song> songs = await songList;

  //   // Encontrar o índice do Song na lista
  //   int songIndex = songs.indexWhere((element) => element.id == song.id);

  //   // Atualizar o estado de favorito do Song
  //   songs[songIndex].favorito = !songs[songIndex].favorito;

  //   // Salvar os dados atualizados no arquivo JSON
  //   await saveSongsToJson(songs);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

// @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(
//           child: Text(
//             'Músicas',
//           ),
//         ),
//       ),
//       body: Scrollbar(
//         child: ListView.builder(
//           itemCount: songList.length,
//           itemBuilder: (BuildContext context, int index) {
//             return Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: songList[index].favorito == true
//                     ? Color(0x33D4006C)
//                     : Colors.white,
//               ),
//               margin: EdgeInsets.all(3.0),
//               child: ListTile(
//                 title: Flexible(
//                   child: Text(
//                     'Nº ${'${songList[index].numero} - ${songList[index].titulo}'}',
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 1,
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 subtitle: Text(
//                   '${songList[index].letra[0].toString()}...',
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 1,
//                 ),
//                 trailing: IconButton(
//                   icon: Icon(
//                     songList[index].favorito == true
//                         ? Icons.favorite
//                         : Icons.favorite_border,
//                     color: songList[index].favorito == true
//                         ? Colors.red
//                         : Colors.grey,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       updateSongFavorite(songList[index], songList);
//                     });
//                   },
//                 ),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => SongScreen(song: songList[index]),
//                     ),
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.audiotrack_sharp),
//             label: 'Músicas',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite_sharp),
//             label: 'Favoritas',
//           ),
//         ],
//       ),
//     );
//   }
