import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'movie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Movies'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Movie>> futureMovies;

  Future<List<Movie>> fetchMovies() async {
    const String _endpointUrl = 'https://yts.mx/api/v2/list_movies.json';
    Map<String, String> _queryParams = {
      'limit': '3',
      'minimum_rating': '6',
    };

    final Uri _uri =
        Uri.parse(_endpointUrl).replace(queryParameters: _queryParams);
    final Response response = await get(_uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> _mapBody = jsonDecode(response.body);
      final List<dynamic> _moviesList = _mapBody['data']['movies'];

      List<Movie> _moviesCurrentPage =
          _moviesList.map((movie) => Movie.fromJson(movie)).toList();
      return _moviesCurrentPage;
    } else {
      throw Exception('Get movies exception!');
    }
  }

  @override
  void initState() {
    super.initState();
    futureMovies = fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(),
    );
  }
}
