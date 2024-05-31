import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/Song.dart';
import '../views/SongScreen.dart';
import 'package:path_provider/path_provider.dart';

class FavoriteListScreen extends StatefulWidget {
  final List<Song> filteredList;
  final List<Song> originalSongList;

  const FavoriteListScreen(
      {super.key, required this.filteredList, required this.originalSongList});

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
      print('Erro ao salvar músicas no arquivo JSON: $e');
    }
  }

  Future<void> updateSongFavorite(Song song, List<Song> filteredList) async {
    List<Song> songs = await filteredList;
    List<Song> originalSongs = await widget.originalSongList;

    // Encontrar o índice do Song na lista filtrada
    int songIndex = songs.indexWhere((element) => element.id == song.id);

    // Se o índice for encontrado na lista filtrada
    if (songIndex != -1) {
      // Atualizar o estado de favorito na lista filtrada
      songs[songIndex].favorito = !songs[songIndex].favorito;

      // Encontrar o índice correspondente na lista original
      int originalIndex =
          originalSongs.indexWhere((element) => element.id == song.id);

      // Se o índice for encontrado na lista original
      if (originalIndex != -1) {
        // Atualizar o estado de favorito na lista original
        originalSongs[originalIndex].favorito = songs[songIndex].favorito;

        // Salvar os dados atualizados no arquivo JSON
        await saveSongsToJson(originalSongs);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.filteredList.isNotEmpty &&
              widget.originalSongList.any((song) => song.favorito)
          ? Scrollbar(
              child: ListView.builder(
                itemCount: widget.filteredList.length,
                itemBuilder: (BuildContext context, int index) {
                  return widget.filteredList[index].favorito == true
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: widget.filteredList[index].favorito == true
                                ? const Color(0x33D4006C)
                                : Colors.white,
                          ),
                          margin: const EdgeInsets.all(3.0),
                          child: ListTile(
                            title: Text(
                              'Nº ${'${widget.filteredList[index].numero} - ${widget.filteredList[index].titulo}'}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${widget.filteredList[index].letra[0].toString()}...',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                widget.filteredList[index].favorito == true
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    widget.filteredList[index].favorito == true
                                        ? Colors.red
                                        : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  updateSongFavorite(widget.filteredList[index],
                                      widget.filteredList);
                                });
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SongScreen(
                                    song: widget.filteredList[index],
                                    songList: widget.originalSongList,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : const SizedBox();
                },
              ),
            )
          : const Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.heart_broken),
                  Text(
                    'Você ainda não adicionou nenhum favorito',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
    );
  }
}
