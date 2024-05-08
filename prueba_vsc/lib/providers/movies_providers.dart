import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:prueba_vsc/helpers/debouncer.dart';
import 'package:prueba_vsc/models/search_response.dart';

import '../models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = '4d42218554cc5333aeb81b84d783b09e';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovie = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> movieCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(duration: const Duration(milliseconds: 500));

  final StreamController<List<Movie>> _suggestionStreamController =
      new StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream =>
      this._suggestionStreamController.stream;

  MoviesProvider() {
    print('Movies providers inicializado');

    this.getOnDisplayMovies();
    this.getPopularMovies();
  }

  Future<String> _getJsonData(String P, [int page = 1]) async {
    final url = Uri.https(
      _baseUrl,
      '3/movie/$P',
      {
        'api_key': _apiKey,
        'language': _language,
        'page': '$page',
      },
    );

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }

  //Este metodo es llamado al inicializar la clase
  getOnDisplayMovies() async {
    final jsonData = await _getJsonData('now_playing');
    final nowPlayingresponse = NowPlayingResponse.fromJson(jsonData);
    onDisplayMovie = nowPlayingresponse.results;
    //Es necesario llamar a este metodo padre para cambiar los datos para cuenado cambien
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;

    final jsonData = await _getJsonData('popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);
    popularMovies = [...popularMovies, ...popularResponse.results];

    //Es necesario llamar a este metodo padre para cambiar los datos para cuenado cambien
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (movieCast.containsKey(movieId)) return movieCast[movieId]!;

    final jsonData = await _getJsonData('$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    movieCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(
      _baseUrl,
      '3/search/movie',
      {
        'api_key': _apiKey,
        'language': _language,
        'query': query,
      },
    );
    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }

  void getSuggestionsByQuery(String seachTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await this.searchMovies(value);
      this._suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = seachTerm;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((value) => timer.cancel());
  }
}
