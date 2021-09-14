import 'dart:convert' as convert;

import 'package:Rick_and_Morty/result/Data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


import 'data.dart';
import 'details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() : super();
  final routes = <String, WidgetBuilder>{
    '/Home': (BuildContext context) => HomePage(),
    '/Details': (BuildContext context) => Detail()
  };

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Data>(
      create: (BuildContext context) {
        return Data();
      },
      child: MaterialApp(
        title: "Спасите!!!!!",
        theme: ThemeData.dark(),
        home: HomePage(),
        routes: routes,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("The Rick and Morty Characters"),
      ),
      body: List(),
    );
  }
}

class List extends StatefulWidget {
  List() : super();

  @override
  _ListState createState() => _ListState();
}

class _ListState extends State<List> {
  DataResults? _data;
  var list = <MyCard>[];

  void download() async {
    var response = await http.get(
      Uri.parse("https://rickandmortyapi.com/api/character"),
    );
    if (response.statusCode == 200) {
      setState(() {
        _data = DataResults.fromJson(
            convert.jsonDecode(response.body) as Map<String, dynamic>);
        _data!.results.forEach((element) {
          list.add(MyCard(
              title: element.name,
              status: element.status,
              race: element.species,
              lastloc: element.location.name,
              img: element.image,
              id: element.id));
        });
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_data == null) {
      download();
      return Center(
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
      );
    } else {
      return ListView(
        children: [...list],
      );
    }
  }
}

class MyCard extends StatelessWidget {
  MyCard(
      {required title,
      required status,
      required race,
      required lastloc,
      required img,
      required id})
      : _img = img,
        _lastloc = lastloc,
        _race = race,
        _status = status,
        _title = title,
        _id = id.toString(),
        super();

  String _img;
  String _title;
  String _status;
  String _race;
  String _lastloc;
  String _id;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                child: Image.network(_img,fit: BoxFit.fitHeight,),
                margin: EdgeInsets.fromLTRB(0, 0, 7, 0),
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                alignment: Alignment.topCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              (_status == "Alive") ? Colors.green : Colors.grey,
                          radius: 5,
                        ),
                        SizedBox(width: 3),
                        Text(_status),
                        SizedBox(width: 7),
                        Text(_race),
                      ],
                    ),
                    SizedBox(height: 25),
                    Text(
                      "Last Known location",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 11,
                      ),
                    ),
                    Container(
                        height: 16,
                        child: Text(
                          _lastloc,
                          overflow: TextOverflow.ellipsis,
                        )),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
            Flexible(child: SizedBox())
          ],
        ),
      ),
      onTap: () {
        context.read<Data>().selectId(_id);
        Navigator.of(context).pushReplacementNamed('/Details');
      },
    );
  }
}
