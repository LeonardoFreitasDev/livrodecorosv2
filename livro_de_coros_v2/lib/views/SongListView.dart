import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import '../models/Song.dart';
import '../views/SongScreen.dart';
import 'package:path_provider/path_provider.dart';

class SongListView extends StatefulWidget {
  @override
  _SongListViewState createState() => _SongListViewState();
}

class _SongListViewState extends State<SongListView> {
  List<Song> songList = [];

  @override
  void initState() {
    super.initState();
    // loadJsonData();
    _initializeAppData();
  }

  Future<void> _initializeAppData() async {
    // Verifica se o arquivo songs.json já existe no diretório de documentos
    bool songsFileExists = await _checkSongsFileExists();

    if (!songsFileExists) {
      // Se o arquivo não existir, copia-o do diretório assets para o diretório de documentos
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

  // Função para salvar os dados no arquivo JSON
  Future<void> saveSongsToJson(List<Song> songs) async {
    try {
      // Obter o diretório de documentos do aplicativo
      Directory directory = await getApplicationDocumentsDirectory();
      File file = File('${directory.path}/songs.json');

      // Converter a lista de músicas para JSON
      List<Map<String, dynamic>> jsonData =
          songs.map((song) => song.toJson()).toList();

      // Escrever os dados JSON de volta no arquivo
      await file.writeAsString(json.encode(jsonData));
    } catch (e) {
      print('Erro ao salvar músicas no arquivo JSON: $e');
    }
  }

  // Função para atualizar o estado de favorito de um Song e salvar os dados atualizados no arquivo JSON
  Future<void> updateSongFavorite(Song song, List<Song> songList) async {
    // Carregar as músicas existentes do arquivo JSON
    List<Song> songs = await songList;

    // Encontrar o índice do Song na lista
    int songIndex = songs.indexWhere((element) => element.id == song.id);

    // Atualizar o estado de favorito do Song
    songs[songIndex].favorito = !songs[songIndex].favorito;

    // Salvar os dados atualizados no arquivo JSON
    await saveSongsToJson(songs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Livro de Coros'),
        ),
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
                  // songList[index].favorito = !songList[index].favorito;
                  updateSongFavorite(songList[index], songList);
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
