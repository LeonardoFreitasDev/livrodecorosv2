import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/Song.dart';
import '../views/SongScreen.dart';
import 'package:path_provider/path_provider.dart';

class FavoriteListScreen extends StatefulWidget {
  final List<Song> songList;

  const FavoriteListScreen({super.key, required this.songList});

  @override
  State<FavoriteListScreen> createState() => _FavoriteListScreenState();
}

class _FavoriteListScreenState extends State<FavoriteListScreen> {
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
      // ignore: avoid_print
      print('Erro ao salvar músicas no arquivo JSON: $e');
    }
  }

  Future<void> updateSongFavorite(Song song, List<Song> songList) async {
    // Carregar as músicas existentes do arquivo JSON
    List<Song> songs = songList;

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
      body: Scrollbar(
        child: ListView.builder(
          itemCount: widget.songList.length,
          itemBuilder: (BuildContext context, int index) {
            return widget.songList[index].favorito == true
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: widget.songList[index].favorito == true
                          ? const Color(0x33D4006C)
                          : Colors.white,
                    ),
                    margin: const EdgeInsets.all(3.0),
                    child: ListTile(
                      title: Text(
                        'Nº ${'${widget.songList[index].numero} - ${widget.songList[index].titulo}'}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                    ),
                  )
                : const SizedBox();
          },
        ),
      ),
    );
  }
}
