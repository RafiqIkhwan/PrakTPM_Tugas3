class Characters {
  final int id;
  final String name;
  final String imageUrl;
  final Family family;
  final Debut debut;
  final String kekeiGenkai;

  Characters({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.family,
    required this.debut,
    required this.kekeiGenkai,
  });

  factory Characters.fromJson(Map<String, dynamic> json) {
    return Characters(
      id: json['id'] ?? 0,
      name: json['name'] ?? "Unknown",
      imageUrl: (json['images'] != null && json['images'].isNotEmpty)
          ? json['images'][0]
          : 'https://placehold.co/600x400',
      family: Family.fromJson(json['family']),
      debut: Debut.fromJson(json['debut']),
      kekeiGenkai: (json['personal'] != null)
          ? (json['personal']['kekei_genkai']) ?? "Kekei Genkai is Null"
          : "Kekei Genkai is Null",
    );
  }
}

class Family {
  final String father;
  final String mother;
  final String wife;

  Family({
    required this.father,
    required this.mother,
    required this.wife,
  });

  factory Family.fromJson(Map<String, dynamic> json) {
    return Family(
      father: json['father'] ?? "Dia Yatim",
      mother: json['mother'] ?? "Dia Piatu",
      wife: json['wife'] ?? "Dia Jomblo",
    );
  }
}

class Debut {
  final String manga;
  final String anime;
  final String movie;

  Debut({
    required this.manga,
    required this.anime,
    required this.movie,
  });

  factory Debut.fromJson(Map<String, dynamic> json) {
    return Debut(
      manga: json['manga'] ?? "Tidak muncul di Manga",
      anime: json['anime'] ?? "Tidak muncul di Anime",
      movie: json['movie'] ?? "Tidak muncul di Movie",
    );
  }
}