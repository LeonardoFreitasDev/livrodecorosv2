// ignore: file_names
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/Song.dart';
import '../views/SongScreen.dart';
import 'package:path_provider/path_provider.dart';

class SongListScreen extends StatefulWidget {
  final List<Song> songList;

  SongListScreen({super.key, required this.songList});

  @override
  State<SongListScreen> createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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

  void _showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Este é um modal!',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Fechar o modal quando o botão for pressionado
                    Navigator.of(context).pop();
                  },
                  child: Text('Fechar Modal'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        thumbVisibility: true,
        thickness: 5,
        radius: const Radius.elliptical(5, 5),
        interactive: true,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: 303,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: widget.songList[index].favorito == true
                    ? Color(0x33D4006C)
                    : Colors.white,
              ),
              margin: EdgeInsets.all(3.0),
              child: ListTile(
                title: Text(
                  'Nº ${'${widget.songList[index].numero} - ${widget.songList[index].titulo}'}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${widget.songList[index].letra[0].toString()}...',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                trailing: IconButton(
                  icon: Icon(
                    widget.songList[index].favorito == true
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.songList[index].favorito == true
                        ? Colors.red
                        : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      updateSongFavorite(
                          widget.songList[index], widget.songList);
                    });
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SongScreen(song: widget.songList[index]),
                    ),
                  );
                },
                onLongPress: () {
                  _showModal(context);
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Rola a lista de volta para o topo
          _scrollController.animateTo(
            0.0,
            duration: Duration(milliseconds: 50),
            curve: Curves.linear,
          );
        },
        child: Icon(Icons.arrow_upward),
      ),
    );
  }
}
