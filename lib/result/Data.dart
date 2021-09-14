import 'Info.dart';
import 'Result.dart';

class DataResults {
  Info _info;
  List<dynamic> _results;

  Info get info => _info;

  List<dynamic> get results => _results;

  DataResults.fromJson(Map<String, dynamic> json)
      : _info = Info.fromJson(json["info"]),
        _results = json["results"].map((e) => Result.fromJson(e)).toList();
}
