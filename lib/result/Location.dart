class Location {
  String _name;

  String _url;

  String get name => _name;

  String get url => _url;

  Location.fromJson(Map<String, dynamic> json)
      : _name = json["name"],
        _url = json["url"];
}
