import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/gen/colors.gen.dart';
import 'package:flutter_clean_architecture/src/domain/usecase/movie/fetch_movies_usecase.dart';
import 'package:flutter_clean_architecture/src/presentation/base/base_stateless_view.dart';
import 'package:flutter_clean_architecture/src/presentation/di/view_model_provider.dart';
import 'package:flutter_clean_architecture/src/presentation/model/movie_view_data_model.dart';
import 'package:flutter_clean_architecture/src/presentation/ui/extension/build_context.dart';
import 'package:flutter_clean_architecture/src/presentation/ui/home/component/movie_view_holder.dart';
import 'package:flutter_clean_architecture/src/presentation/ui/home/home_view_model.dart';
import 'package:flutter_clean_architecture/src/presentation/ui/widget/loading.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyListView extends BaseStatelessView<HomeViewModel> {
  final Function(MovieViewDataModel) actionOpenMovie;
  final Function() actionLoadAll;

  const MyListView({
    Key? key,
    required this.actionOpenMovie,
    required this.actionLoadAll,
  }) : super(key: key);

  @override
  Widget createView(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return ref.watch(homeViewModelProvider).myListMovies.when(data: (data) {
        return _createMyListView(context, data);
      }, loading: () {
        return const Loading();
      }, error: (e, s) {
        return const SizedBox();
      });
    });
  }

  @override
  void pageErrorRetry(BuildContext context, WidgetRef ref) {
    ref.watch(homeViewModelProvider.notifier).getMovieWithType(MovieType.topRated, retry: true);
  }

  @override
  ProviderBase<HomeViewModel> get viewModelProvider => homeViewModelProvider;

  Widget _createMyListView(BuildContext context, List<MovieViewDataModel> movies) {
    final contentHeight = 4.0 * (MediaQuery.of(context).size.width / 2.4) / 3;
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 20.0, right: 16.0),
          height: 48.0,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  context.res().myList,
                  style: Theme.of(context).textTheme.headline5?.copyWith(color: ColorName.groupTitleColor),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward, color: ColorName.groupTitleColor),
                onPressed: actionLoadAll,
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(0.0),
          height: contentHeight,
          child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return MovieViewHolder(movies[index], actionOpenMovie);
            },
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const VerticalDivider(
              color: Colors.transparent,
              width: 6.0,
            ),
            itemCount: movies.length,
          ),
        ),
      ],
    );
  }
}
