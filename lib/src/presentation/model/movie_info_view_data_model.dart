import 'package:flutter_clean_architecture/src/data/model/movie_info_data_model.dart';
import 'package:flutter_clean_architecture/src/presentation/base/model_item_mapper.dart';

class MovieInfoViewDataModel {
  final String? title;
  final String overview;
  final double voteAverage;
  final int runtime;
  final String countries;
  final String year;
  final String categories;

  MovieInfoViewDataModel({
    required this.title,
    required this.overview,
    required this.voteAverage,
    required this.runtime,
    required this.countries,
    required this.year,
    required this.categories,
  });
}

class MovieInfoViewDataModelMapper extends ModelItemMapper<MovieInfoDataModel, MovieInfoViewDataModel> {
  @override
  MovieInfoViewDataModel mapperTo(MovieInfoDataModel data) {
    return MovieInfoViewDataModel(
        title: data.title ?? '',
        overview: data.overview ?? '',
        voteAverage: data.voteAverage ?? 0.0,
        runtime: data.runtime ?? 0,
        countries: ((data.countries?.length ?? 0) > 0)
            ? data.countries?.skip(1).fold(data.countries?.first.code ?? '', (previousValue, element) {
                  return '${previousValue ?? ''}, ${element.code}';
                }) ??
                ''
            : '',
        year: (data.releaseDate?.length ?? 0) >= 4 ? data.releaseDate!.substring(0, 4) : '',
        categories: data.genres?.skip(1).fold(data.genres?.first.name ?? '', (previousValue, element) {
              return '${previousValue ?? ''}, ${element.name}';
            }) ??
            '');
  }
}
