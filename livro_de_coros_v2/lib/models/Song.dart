class Song {
  int id;
  int numero;
  String titulo;
  List<String> letra;
  bool favorito;
  List<String> tags;

  Song({
    required this.id,
    required this.numero,
    required this.titulo,
    required this.letra,
    required this.favorito,
    required this.tags,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      numero: json['numero'],
      titulo: json['titulo'],
      letra: List<String>.from(json['letra']),
      favorito: json['favorito'],
      tags: List<String>.from(json['tags']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numero': numero,
      'titulo': titulo,
      'letra': letra,
      'favorito': favorito,
      'tags': tags,
    };
  }
}
