class Info {

  int _count;
  int _pages;
  String _next;
  String get count =>count;

  String  get pages =>pages;

  String  get next =>next;
  Info.fromJson(Map<String, dynamic> json)
      : _count= json["count"],
        _pages = json["pages"],
        _next = json["next"];

}
