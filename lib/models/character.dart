class Character {
  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
    required this.url,
    required this.created,
  });

  int id;
  String name;
  String status;
  String species;
  String type;
  String gender;
  Location origin;
  Location location;
  String image;
  List<String> episode;
  String url;
  DateTime created;

  factory Character.fromMap(Map<String, dynamic> json) => Character(
        id: int.parse(json["id"].toString()),
        name: json["name"].toString(),
        status: json["status"].toString(),
        species: json["species"].toString(),
        type: json["type"].toString(),
        gender: json["gender"].toString(),
        origin: Location.fromMap(json["origin"] as Map<String, dynamic>),
        location: Location.fromMap(json["location"] as Map<String, dynamic>),
        image: json["image"].toString(),
        episode: List<String>.from(json["episode"].map((x) => x) as Iterable),
        url: json["url"].toString(),
        created: DateTime.parse(json["created"].toString()),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "status": status,
        "species": species,
        "type": type,
        "gender": gender,
        "origin": origin.toMap(),
        "location": location.toMap(),
        "image": image,
        "episode": List<dynamic>.from(episode.map((x) => x)),
        "url": url,
        "created": created.toIso8601String(),
      };
}

class Location {
  Location({
    required this.name,
    required this.url,
  });

  String name;
  String url;

  factory Location.fromMap(Map<String, dynamic> json) => Location(
        name: json["name"].toString(),
        url: json["url"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "url": url,
      };
}
