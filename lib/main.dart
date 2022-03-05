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
  int _page = 1;
  List<Movie> _allMovies = [];

  Future<List<Movie>> fetchMovies() async {
    const String _endpointUrl = 'https://yts.mx/api/v2/list_movies.json';
    Map<String, String> _queryParams = {
      'limit': '20',
      'minimum_rating': '6',
      'page': _page.toString(),
    };

    final Uri _uri =
        Uri.parse(_endpointUrl).replace(queryParameters: _queryParams);
    final Response response = await get(_uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> _mapBody = jsonDecode(response.body);
      final List<dynamic> _moviesList = _mapBody['data']['movies'];

      List<Movie> _moviesCurrentPage =
          _moviesList.map((movie) => Movie.fromJson(movie)).toList();
      _allMovies.addAll(_moviesCurrentPage);
      return _allMovies;
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
      body: FutureBuilder(
        future: futureMovies,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Movie> data = snapshot.data! as List<Movie>;

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                crossAxisCount: 1,
              ),
              itemCount: data.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index < data.length) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridTile(
                      child: Image.network(
                        data[index].imageUrl ?? '',
                        fit: BoxFit.cover,
                      ),
                      footer: Container(
                        child: GridTileBar(
                          title: Text(data[index].title),
                          subtitle: Text(data[index].rating.toString()),
                        ),
                        color: Colors.blue,
                      ),
                    ),
                  );
                } else {
                  return ElevatedButton(
                      onPressed: () {
                        _page++;

                        setState(
                          () {
                            futureMovies = fetchMovies();
                          },
                        );
                      },
                      child: const Text('Load More'));
                }
              },
            );
          } else if (snapshot.hasError) {
            return Text("--${snapshot.error}--");
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
