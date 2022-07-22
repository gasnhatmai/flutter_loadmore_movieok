import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_loadmore_movie/bloc/movie_event.dart';
import 'package:http/http.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:shimmer/shimmer.dart';

import '../bloc/movie_bloc.dart';
import '../bloc/movie_event.dart';
import '../bloc/movie_event.dart';
import '../bloc/movie_state.dart';
import '../bloc/movie_state.dart';
import '../bloc/movie_state.dart';
import '../enum/load_state.dart';
import '../model/model.dart';
import '../responsitory/movie_repo.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  @override
  void initState()  {
    BlocProvider.of<MoviesBloc>(context).add(MovieFetched());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MoviesBloc,MovieState>(
        buildWhen: (prev, current) {
          return prev.status != current.status;
        },
          builder: (context,state) {

             if(state.status == MovieStatus.loading){
                return _buildLoadingList();}
              else if(state.status == MovieStatus.failure){
                return Center(child: Text('Failure'),);
              }
              else{
                return _buildSuccessList(state.posts,
                  showLoadingMore: !state.hasReachedMax
                );
            }
          }),
    );
  }

  Widget _buildSuccessList(List<Results>? items, {bool showLoadingMore = false}) {
    return Container(
        child: LazyLoadScrollView(
          scrollDirection: Axis.horizontal,
          onEndOfPage: () {
                print('haaaaaaaaaa');
              BlocProvider.of<MoviesBloc>(context).add(MovieFetchedMore());
            },


            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index < items!.length) {
                  final item = items[index];
                  return Container(
                    height: 160,
                    width: 82,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: MovieWidget(
                      results: item,
                      onPressed: () {},
                    ),
                  );
                } else {
                  return LoadingMoreRowWidget();
                }
              },
              itemCount: showLoadingMore? items!.length +1 : items!.length,
              // controller: _scrollController,
            ),

        ),
      );
  }
}


class MovieWidget extends StatelessWidget {
  final Results? results;
  final VoidCallback? onPressed;

  MovieWidget({this.results, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        padding: EdgeInsets.all(0),
        child: Container(
          height: 200,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  height: 160,
                  child: _buildThumbWidget(),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Text(results!.title ?? '', maxLines: 2),
                      height: 32,
                      margin: EdgeInsets.only(top: 5),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      child: Icon(Icons.more_vert, size: 16),
                      height: 32,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildThumbWidget() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        child: AppCacheImage(
          url: 'https://image.tmdb.org/t/p/w185${results!.posterPath}' ?? '',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
class AppCacheImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxFit fit;

  AppCacheImage({
    this.url = "",
    this.width,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    bool isValidUrl = Uri.tryParse(url)?.isAbsolute == true;
    return Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      child: isValidUrl
          ? ClipRRect(
        child: CachedNetworkImage(
          imageUrl: url,
          progressIndicatorBuilder: (context, url, downloadProgress) {
            return Center(
              child: Container(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            );
          },
          errorWidget: (context, url, error) {
            return Image.network(
              url,
              errorBuilder: (context, error, stackTrace) => _buildPlaceHolderImage(),
              fit: fit,
            );
          },
          fit: fit,
        ),
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
      )
          : _buildPlaceHolderImage(),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
      ),
    );
  }

  Widget _buildPlaceHolderImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 0),
      child: Container(
        color: Color(0xFFe6e6e6),
        child: Center(
          child: Text('Fail'),
        ),
      ),
    );
  }
}

class AppCircleAvatar extends StatelessWidget {
  final String url;
  final double? size;

  AppCircleAvatar({this.url = "", this.size});

  @override
  Widget build(BuildContext context) {
    bool isValidUrl = Uri.tryParse(url)?.isAbsolute == true;
    return Container(
      width: size ?? double.infinity,
      height: size ?? double.infinity,
      child: isValidUrl
          ? ClipRRect(
        child: CachedNetworkImage(
          imageUrl: url,
          progressIndicatorBuilder: (context, url, downloadProgress) {
            return Container(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                value: downloadProgress.progress,
                strokeWidth: 2,
              ),
            );
          },
          errorWidget: (context, url, error) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              child: Text('fail'),
            );
          },
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.circular((size ?? 0) / 2),
      )
          : Container(
        width: double.infinity,
        height: double.infinity,
        child: Text('haha'),
      ),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular((size ?? 0) / 2),
      ),
    );
  }
}
class LoadingMoreRowWidget extends StatelessWidget {
  final double height;
  final Color color;

  LoadingMoreRowWidget({this.height = 80, this.color = Colors.red});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Container(
        alignment: Alignment.center,
        child: Container(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            backgroundColor: color,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }
}
Widget _buildLoadingList() {
  return LoadingListWidget();
}
class AppShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double cornerRadius;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color? baseColor;
  final Color? highlightColor;

  AppShimmer({
    this.width = double.infinity,
    this.height = double.infinity,
    this.cornerRadius = 0,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey[350]!,
      highlightColor: highlightColor ?? Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        padding: padding,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(cornerRadius),
            ),
          ),
        ),
      ),
    );
  }
}
class LoadingListWidget extends StatelessWidget {
  final EdgeInsets? rowPadding;
  final double rowHeight;

  LoadingListWidget({this.rowPadding, this.rowHeight = 100});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 15),
        itemBuilder: (context, index) {
          return Container(
            height: 160,
            width: 82,
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                AppShimmer(
                  height: 122,
                  width: 82,
                  cornerRadius: 8,
                ),
                SizedBox(height: 10),
                AppShimmer(
                  height: 10,
                  width: 82,
                  cornerRadius: 8,
                ),
                SizedBox(height: 4),
                AppShimmer(
                  height: 10,
                  width: 82,
                  cornerRadius: 8,
                ),
                SizedBox(height: 4),
              ],
            ),
          );
        },
        itemCount: 20,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}
