import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_loadmore_movie/bloc/movie_bloc.dart';
import 'package:flutter_loadmore_movie/bloc/movie_event.dart';
import 'package:flutter_loadmore_movie/page/home_page.dart';
import 'package:flutter_loadmore_movie/responsitory/movie_repo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (_) =>MoviesBloc(repository: Reponsitory()),
      child: HomePage())
    );
  }
}


