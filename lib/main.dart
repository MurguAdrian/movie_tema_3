import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: MoviePage(),
    );
  }
}

class MoviePage extends StatefulWidget {
  const MoviePage({Key? key}) : super(key: key);

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  @override
  void initState() {
    super.initState();
    _getMovie();
  }

  bool isLoading = false;
  final List<String> _title = <String>[];
  final List<String> _img = <String>[];
  final List<int> _years = <int>[];
  final List<int> _rate = <int>[];

  void _getMovie() {
    get(Uri.parse('https://yts.mx/api/v2/list_movies.json')).then((Response response) {
      response.body;
      final Map<String, dynamic> map = jsonDecode(response.body) as Map<String, dynamic>;
      final Map<String, dynamic> data = map['data'] as Map<String, dynamic>;
      final List<dynamic> movies = data["movies"] as List<dynamic>;

      setState(() {
        _title.addAll(movies.map((dynamic item) => item["title"] as String));
        _img.addAll(movies.map((dynamic item) => item["medium_cover_image"] as String));
        _years.addAll(movies.map((dynamic item) => item["year"] as int));
        _rate.addAll(movies.map((dynamic item) => item["runtime"] as int));
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(
        builder: (BuildContext) {
          if (isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: _title.length,
            itemBuilder: (BuildContext, int index) {
              final String title = _title[index];
              final String img = _img[index];
              final int years = _years[index];
              final int rate = _rate[index];

              return Builder(
                builder: (context) {
                  return Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(20),
                            alignment: Alignment.centerLeft,
                            height: 200,
                            width: 150,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              image: DecorationImage(image: NetworkImage(img), fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 200,
                            child: Text(
                              title,
                              maxLines: 2,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: 200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text('Anul '),
                                    Text(
                                      '$years',
                                      style: TextStyle(fontSize: 18, letterSpacing: 10),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('Runtime'),
                                    Text(
                                      '$rate',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
