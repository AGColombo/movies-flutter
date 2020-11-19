import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

import 'package:flutter/material.dart';
import '../controllers/movie_detail_controller.dart';
import '../widgets/centered_message.dart';
import '../widgets/centered_progress.dart';
import '../widgets/chip_date.dart';
import '../widgets/rate.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;

  MovieDetailPage(this.movieId);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final _controller = MovieDetailController();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  _initialize() async {
    setState(() {
      _controller.loading = true;
    });

    await _controller.fetchMovieById(widget.movieId);

    setState(() {
      _controller.loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildMovieDetail(),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: Text(_controller.movieDetail?.title ?? ''),
    );
  }

  _buildMovieDetail() {
    if (_controller.loading) {
      return CenteredProgress();
    }

    if (_controller.movieError != null) {
      return CenteredMessage(message: _controller.movieError.message);
    }

    return ListView(
      children: [
        _buildCover(),
        _buildStatus(),
        _buildTitle(),
        _buildTagline(),
        _buildOverview(),
      ],
    );
  }

  _buildOverview() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Text(
        _controller.movieDetail.overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }

  _buildStatus() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Rate(_controller.movieDetail.voteAverage),
          _buildStatusTwo(),
          ChipDate(date: _controller.movieDetail.releaseDate),
        ],
      ),
    );
  }

  _buildStatusTwo() {
    return Container(
      padding: const EdgeInsets.only(right: 10.0),
      child: Text(
        _controller.movieDetail.runtime.toString() + ' min',
        style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.left,
      ),
    );
  }

  _buildTitle() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        _controller.movieDetail.title,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  _buildTagline() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        _controller.movieDetail.tagline,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  _buildCover() {
    return FancyShimmerImage(
      imageUrl:
          'https://image.tmdb.org/t/p/w500${_controller.movieDetail.backdropPath}',
      shimmerBaseColor: Colors.grey[800],
      shimmerBackColor: Colors.grey[800],
      shimmerHighlightColor: Colors.grey[800],
      errorWidget: Image.network(
          'https://i0.wp.com/www.dobitaobyte.com.br/wp-content/uploads/2016/02/no_image.png?ssl=1'),
    );
  }
}
