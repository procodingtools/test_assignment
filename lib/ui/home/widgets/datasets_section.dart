import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_assignment/features/categories/cubits/categories_cubit.dart';
import 'package:test_assignment/features/dataset/cubits/dataset_cubit.dart';
import 'package:test_assignment/models/dataset.dart';
import 'package:test_assignment/ui/dataset/dataset_view.dart';

/// {@category Datasets}
/// {@subCategory Widgets}
/// Widget contains [DatasetCubit] BLoC builder to show [DatasetView]
class DatasetsSection extends StatelessWidget {
  const DatasetsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatasetCubit, DatasetState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => _Content(datasets: state.datasets),
          initial: (_) => const SizedBox.shrink(),
          loading: (_) => SizedBox(
            height: 250,
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.center,
              children: const [CircularProgressIndicator()],
            ),
          ),
        );
      },
    );
  }

}

class _Content extends StatelessWidget {
  const _Content({Key? key, required this.datasets}) : super(key: key);

  final List<DatasetModel> datasets;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (datasets.isNotEmpty)
          ...datasets
              .map((e) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DatasetView(dataset: e),
                  ))
              .toList()
        else if (context
                .read<CategoriesCubit>()
                .state
                .searchCategories
                .isNotEmpty &&
            datasets.isEmpty)
          Center(
            child: Text(
              'Nothing to show',
              style: TextStyle(
                  color: Theme.of(context).disabledColor, fontSize: 20),
            ),
          ),
        context.watch<DatasetCubit>().state.maybeWhen(
              orElse: SizedBox.shrink,
              loaded: (_) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: CircularProgressIndicator(),
              ),
            ),
      ],
    );
  }
}
