import 'package:flutter_loadmore_movie/bloc/movie_event.dart';
import 'package:flutter_loadmore_movie/bloc/movie_state.dart';
import 'package:flutter_loadmore_movie/model/model.dart';
import 'package:flutter_loadmore_movie/responsitory/movie_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class MoviesBloc extends Bloc<MovieEvent,MovieState> {
  final Reponsitory repository;

  MoviesBloc({required this.repository}):super(MovieState()) {
    on<MovieEvent>((event, emit) async {
      if (event is MovieFetched) {
        print('loadmovieeeeeeee');
        emit(state.copyWith(status: MovieStatus.loading));
        try {
          final result = await repository.getMovie(1);
          var post = result.results;
          emit(state.copyWith(posts: post, status: MovieStatus.success));
        } catch (e) {
          emit(state.copyWith(status: MovieStatus.failure));
        }
      }else if(event is MovieFetchedMore){
       // if(state.page!=MovieStatus.success){
       //   return;
       // }
       print('loadmorreeer');
       emit(state.copyWith(status: MovieStatus.loadingMore));
       try{
         List<Results>? listResult=[];
         final result=await repository.getMovie(state.page+2);
           listResult=result.results;
           print(listResult!.first.title);
         emit(state.copyWith(status: MovieStatus.success,
           page: state.page++,
           totalPages: state.totalPages,
           posts: state.posts+listResult!
           ));
         print(state.page);
         // if(state.page==state.totalPages){ return;}
         // if(state.status==MovieStatus.success){
         // //   return;
         // }
       }catch(e){
      emit(state.copyWith(status: MovieStatus.success));
       }

      }
    });
  }
 }



  // void fetchInitialMovies() async {
  //   emit(state.copyWith(loadMovieStatus: LoadStatus.LOADING));
  //   try {
  //     final result = await repository.getMovie( 1);
  //     emit(state.copyWith(
  //       loadMovieStatus: LoadStatus.SUCCESS,
  //       result: result.results,
  //       page: result.page ?? 0,
  //       totalPages: result.totalPages ?? 0,
  //     ));
  //   } catch (e) {
  //     emit(state.copyWith(loadMovieStatus: LoadStatus.FAILURE));
  //   }
  // }
  //
  // void fetchNextMovies() async {
  //   if (state.page == state.totalPages) {
  //     return;
  //   }
  //   if (state.loadMovieStatus != LoadStatus.SUCCESS) {
  //     return;
  //   }
  //   emit(state.copyWith(loadMovieStatus: LoadStatus.LOADING_MORE));
  //   try {
  //     final result = await repository.getMovie( state.page + 1);
  //     List<Results>? lsResult = [];
  //     lsResult = result.results;
  //     emit(state.copyWith(
  //       loadMovieStatus: LoadStatus.SUCCESS,
  //       result: state.result! + lsResult!,
  //       page: result.page,
  //       totalPages: result.totalPages,
  //     ));
  //   } catch (e) {
  //     emit(state.copyWith(loadMovieStatus: LoadStatus.SUCCESS));
  //   }
  // }
