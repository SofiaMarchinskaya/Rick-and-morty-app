class Origin {
  String _name;
  String _url;

  String get name => _name;

  String get url => _url;

  Origin.fromJson(Map<String, dynamic> json)
      : _url = json["url"],
        _name = json["name"];
}
