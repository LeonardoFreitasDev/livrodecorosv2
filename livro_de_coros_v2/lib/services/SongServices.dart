// import 'dart:io';
// import 'dart:convert';
// import 'package:flutter/services.dart' show ByteData, rootBundle;
// import '../models/Song.dart';
// import 'package:path_provider/path_provider.dart';

// class Songservices {
//   Future<void> _initializeAppData() async {
//     bool songsFileExists = await _checkSongsFileExists();

//     if (!songsFileExists) {
//       await _copySongsFileToDocumentsDirectory();
//     }

//     // Carrega os dados do arquivo JSON
//     await _loadJsonData();
//   }

//   Future<bool> _checkSongsFileExists() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     File file = File('${documentsDirectory.path}/songs.json');
//     return file.exists();
//   }

//   Future<void> _copySongsFileToDocumentsDirectory() async {
//     ByteData data = await rootBundle.load('./assets/songs.json');
//     List<int> bytes = data.buffer.asUint8List();
//     String songsFilePath =
//         '${(await getApplicationDocumentsDirectory()).path}/songs.json';
//     await File(songsFilePath).writeAsBytes(bytes);
//   }

//   Future<void> _loadJsonData() async {
//     String jsonString = await _loadSongsJson();
//     if (jsonString.isNotEmpty) {
//       List<dynamic> jsonData = json.decode(jsonString);
//       List<Song> songs = jsonData.map((data) => Song.fromJson(data)).toList();
//       setState(() {
//         songList = songs;
//       });
//     }
//   }

//   Future<String> _loadSongsJson() async {
//     try {
//       Directory documentsDirectory = await getApplicationDocumentsDirectory();
//       File file = File('${documentsDirectory.path}/songs.json');
//       return await file.readAsString();
//     } catch (e) {
//       print('Erro ao carregar músicas do arquivo JSON: $e');
//       return '';
//     }
//   }

//   // Função para salvar os dados no arquivo JSON
//   Future<void> saveSongsToJson(List<Song> songs) async {
//     try {
//       // Obter o diretório de documentos do aplicativo
//       Directory directory = await getApplicationDocumentsDirectory();
//       File file = File('${directory.path}/songs.json');

//       // Converter a lista de músicas para JSON
//       List<Map<String, dynamic>> jsonData =
//           songs.map((song) => song.toJson()).toList();

//       // Escrever os dados JSON de volta no arquivo
//       await file.writeAsString(json.encode(jsonData));
//     } catch (e) {
//       print('Erro ao salvar músicas no arquivo JSON: $e');
//     }
//   }

//   // Função para atualizar o estado de favorito de um Song e salvar os dados atualizados no arquivo JSON
//   Future<void> updateSongFavorite(Song song, List<Song> songList) async {
//     // Carregar as músicas existentes do arquivo JSON
//     List<Song> songs = await songList;

//     // Encontrar o índice do Song na lista
//     int songIndex = songs.indexWhere((element) => element.id == song.id);

//     // Atualizar o estado de favorito do Song
//     songs[songIndex].favorito = !songs[songIndex].favorito;

//     // Salvar os dados atualizados no arquivo JSON
//     await saveSongsToJson(songs);
//   }
// }
