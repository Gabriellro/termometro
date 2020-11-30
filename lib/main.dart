import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    return MaterialApp(
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _temp = 25;

  Map mapResponse;
  List listOfFacts;

  Future fetchData() async {
    http.Response response;

    response = await http.get(
        'https://api.thingspeak.com/channels/1240502/feeds.json?api_key=DR94BSKWMGG22Q9U&results=1');

    if (response.statusCode == 200) {
      setState(
        () {
          mapResponse = json.decode(response.body);
          listOfFacts = mapResponse['feeds'];
        },
      );
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: (int.parse(listOfFacts[0]['field1']) <= 10)
                  ? Colors.lightBlue
                  : (int.parse(listOfFacts[0]['field1']) >= 11 &&
                          int.parse(listOfFacts[0]['field1']) <= 20)
                      ? Colors.amber
                      : Colors.red,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    listOfFacts[0]['field1'] + 'º',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {},
        child: Icon(
          Icons.sync_rounded,
          color: (int.parse(listOfFacts[0]['field1']) <= 10)
              ? Colors.lightBlue
              : (int.parse(listOfFacts[0]['field1']) >= 11 &&
                      int.parse(listOfFacts[0]['field1']) <= 20)
                  ? Colors.amber
                  : Colors.red,
        ),
      ),
    );
  }
}
