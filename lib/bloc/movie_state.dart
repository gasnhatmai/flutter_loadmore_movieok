import 'package:equatable/equatable.dart';

import '../model/model.dart';

enum MovieStatus { initial, loading,success, failure,loadingMore}

class MovieState extends Equatable {
  MovieState({
    this.status = MovieStatus.initial,
    this.posts =  const <Results>[],
    this.page=1,
    this.totalPages=1
  });

  final MovieStatus status;
  final List<Results> posts;
  late  int page;
  final int totalPages;

  MovieState copyWith({
    MovieStatus? status,
    List<Results>? posts,
    int? page,
    int? totalPages
  }) {
    return MovieState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      page: page?? this.page,
      totalPages: totalPages??this.totalPages
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${posts.length} }''';
  }

  @override
  List<Object> get props => [status, posts, hasReachedMax];

  bool get hasReachedMax {
    return page >= totalPages;
  }
}