import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/model.dart';
class Reponsitory {
  Future<Movie> getMovie(int page) async {
    String url = "https://api.themoviedb.org/3/discover/movie?api_key=26763d7bf2e94098192e629eb975dab0&page=$page";
    var repo = await http.get(Uri.parse(url));
    var data = jsonDecode(repo.body);
    if (repo.statusCode == 200) {
      Movie movie = Movie.fromJson(data);
      print(movie);
      return movie;
    } else {
      throw Exception();
    }
  }
}