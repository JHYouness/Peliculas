import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_vsc/providers/movies_providers.dart';
import 'package:prueba_vsc/search/search_delegate.dart';

import 'package:prueba_vsc/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Guardo en la variable la instancia de MoviesProvider
    final moviesProvider = Provider.of<MoviesProvider>(context);
    //print(moviesProvider.getOnDisplayMovies());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Peliculas en cines'),
        actions: [
          IconButton(
            onPressed: () =>
                showSearch(context: context, delegate: MovieSearchDelegate()),
            icon: const Icon(Icons.search_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        //Widget utlizado para poder realizar scroll
        child: Column(
          children: [
            //Targetas principales vertical
            CardSwiper(movies: moviesProvider.onDisplayMovie),

            //Slider de peliculas horizontal
            MovieSlider(
              movies: moviesProvider.popularMovies,
              title: 'Populares!',
              onFinalPage: () => moviesProvider.getPopularMovies(),
            ),
          ],
        ),
      ),
    );
  }
}
