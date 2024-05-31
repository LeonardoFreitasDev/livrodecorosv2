// ignore: file_names
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/Song.dart';
import '../views/SongScreen.dart';
import 'package:path_provider/path_provider.dart';

class SongListScreen extends StatefulWidget {
  final List<Song> filteredList;
  final List<Song> originalSongList;

  const SongListScreen(
      {super.key, required this.filteredList, required this.originalSongList});

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
        // await saveSongsToJson(originalSongs);
      }
    }

    // Carregar as músicas existentes do arquivo JSON
    // List<Song> songs = await filteredList;
    // List<Song> originalSongs = List.from(await widget.originalSongList);

    // // Encontrar o índice do Song na lista
    // int songIndex = songs.indexWhere((element) => element.id == song.id);
    // int originalIndex =
    //     originalSongs.indexWhere((element) => element.id == song.id);

    // // Atualizar o estado de favorito do Song
    // songs[songIndex].favorito = !songs[songIndex].favorito;
    // originalSongs[originalIndex].favorito =
    //     originalSongs[originalIndex].favorito;

    // Salvar os dados atualizados no arquivo JSON
    // await saveSongsToJson(originalSongs);
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
          itemCount: widget.filteredList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: widget.filteredList[index].favorito == true
                    ? Color(0x33D4006C)
                    : Colors.white,
              ),
              margin: EdgeInsets.all(3.0),
              child: ListTile(
                title: Text(
                  'Nº ${'${widget.filteredList[index].numero} - ${widget.filteredList[index].titulo}'}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontWeight: FontWeight.bold),
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
                    color: widget.filteredList[index].favorito == true
                        ? Colors.red
                        : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      updateSongFavorite(
                          widget.filteredList[index], widget.filteredList);
                    });
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SongScreen(song: widget.filteredList[index]),
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
