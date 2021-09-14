import 'Location.dart';
import 'Origin.dart';

class Result {
  int _id;
  String _name;

  String _status;

  String _species;

  String _type;

  String _gender;

  Origin _origin;

  Location _location;

  String _image;

  List<dynamic> _episode;
  String _url;
  String _created;

  int get id => _id;

  String get name => _name;

  String get status => _status;

  String get species => _species;

  String get type => _type;

  String get gender => _gender;

  Origin get origin => _origin;

  Location get location => _location;

  String get image => _image;

  List<dynamic> get episode => _episode;

  String get url => _url;

  String get created => _created;

  Result.fromJson(Map<String, dynamic> json)
      : _id = json["id"],
        _name = json["name"],
        _status = json["status"],
        _species = json["species"],
        _type = json["type"],
        _gender = json["gender"],
        _origin = Origin.fromJson(json["origin"]),
        _location =Location.fromJson( json["location"]),
        _image = json["image"],
        _episode = json["episode"].map((e) => e).toList(),
        _url = json["url"],
        _created = json["created"];
}
