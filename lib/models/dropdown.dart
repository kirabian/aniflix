// File: models/dropdown_models.dart

class Film {
  final int id;
  final String title;

  Film({required this.id, required this.title});

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(id: json['id'], title: json['title']);
  }
}

class Cinema {
  final int id;
  final String name;

  Cinema({required this.id, required this.name});

  factory Cinema.fromJson(Map<String, dynamic> json) {
    return Cinema(id: json['id'], name: json['name']);
  }
}
