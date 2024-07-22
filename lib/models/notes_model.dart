class Notes {
  int? id;
  String title;
  String description;
  String date;

  Notes({this.id, required this.title, required this.description, required this.date});

  Notes.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        title = map["title"],
        description = map["description"],
        date = map["date"];

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "date": date
    };
  }
}
