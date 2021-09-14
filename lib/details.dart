import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'data.dart';

class Detail extends StatefulWidget {
  const Detail() : super();

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Map<String, dynamic>? _data;
  String? lastLocation;
  List<Map<String, dynamic>> _episodes = [];

  final double marginLeft = 40;
  final double height = 15;

  void download(BuildContext context) async {
    var response = await http.get(
      Uri.parse("https://rickandmortyapi.com/api/character/" +
          context.watch<Data>().selectedId),
    );
    if (response.statusCode == 200) {
      setState(() {
        _data = convert.jsonDecode(response.body) as Map<String, dynamic>;
      });
      downloadLastLocation();
      downloadEpisodeData();
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void downloadLastLocation() async {
    var response = await http.get(
      Uri.parse(_data?["episode"][0] as String),
    );
    if (response.statusCode == 200) {
      setState(() {
        lastLocation =
            (convert.jsonDecode(response.body) as Map<String, dynamic>)["name"];
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void downloadEpisodeData() async {
    List<Map<String, dynamic>> episodesLocale = [];
    for (int i = 0; i < (_data?["episode"] as List<dynamic>).length; i++) {
      var response = await http.get(
        Uri.parse(_data?["episode"][i] as String),
      );
      if (response.statusCode == 200) {
        episodesLocale
            .add(convert.jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    }
    setState(() {
      _episodes = episodesLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_data == null || _episodes.length == 0) {
      if (_data == null) download(context);
      return Scaffold(
        appBar: AppBar(
          title: Text("Person details"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/Home');
            },
          ),
        ),
        body: Center(
          child: Column(
            children: [
              CircularProgressIndicator(color: Colors.white),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Loading... Please, wait"),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      );
    } else
      return Scaffold(
        appBar: AppBar(
          title: Text("Person details"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/Home');
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Image.network(
                  _data?["image"],
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                child: Text(
                  _data?["name"],
                  style: TextStyle(fontSize: 25),
                ),
                alignment: Alignment.topLeft,
                margin: EdgeInsets.fromLTRB(marginLeft, 8, 0, 8),
              ),
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Colors.white,
                  ThemeData.dark().canvasColor,
                ], stops: [
                  0.0,
                  0.8
                ])),
                height: 3,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(marginLeft, 8, 0, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Live status",
                      style: TextStyle(fontSize: 17, color: Colors.grey),
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: (_data?["status"] == "Alive")
                              ? Colors.green
                              : Colors.grey,
                          radius: 5,
                        ),
                        SizedBox(width: 3),
                        Text(_data?["status"], style: TextStyle(fontSize: 17)),
                      ],
                    ),
                    ...buildWidget("Species and gender ",
                        "${_data?["species"]}(${_data?["gender"]})"),
                    ...buildWidget(
                        "Last known location  ", _data!["location"]["name"]),
                    ...buildWidget("First seen in  ", lastLocation),
                    SizedBox(
                      height: height,
                    ),
                    Text(
                      "Episodes",
                      style:
                          TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              for (int i = 0;
                  i < (_data?["episode"] as List<dynamic>).length;
                  i++)
                EpisodeCard(_episodes[i]["name"], _episodes[i]["air_date"],
                    _episodes[i]["episode"])
            ],
          ),
        ),
      );
  }

  List<Widget> buildWidget(title, subtitle) => [
        SizedBox(
          height: height,
        ),
        Text(
          title,
          style: TextStyle(fontSize: 17, color: Colors.grey),
        ),
        Text(
          subtitle,
          style: TextStyle(fontSize: 17),
        ),
      ];
}

class EpisodeCard extends StatelessWidget {
  String title;
  String subtitle;
  String episodeId;

  EpisodeCard(this.title, this.subtitle, this.episodeId);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 40, 0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          bottomRight: Radius.circular(15),
        )),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width:200,
                      child: Text(
                        title,
                        style: TextStyle(fontSize: 17),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 7, 7, 0),
                child: Text(episodeId,
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
