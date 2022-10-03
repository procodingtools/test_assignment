import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_tag_editor/tag_editor.dart';
import 'package:test_assignment/features/categories/cubits/categories_cubit.dart';
import 'package:test_assignment/features/dataset/cubits/dataset_cubit.dart';
import 'package:test_assignment/models/category.dart';
import 'package:test_assignment/ui/categorties/widgets/category_button.dart';
import 'package:test_assignment/ui/dataset/widgets/dataset_view.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => _Content(
            categories: state.categories,
            searchCategories: state.searchCategories,
          ),
          loading: (_, __) => SizedBox(
            height: 250,
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.center,
              children: const [CircularProgressIndicator()],
            ),
          ),
          initial: (_, __) => const SizedBox.shrink(),
        );
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content(
      {Key? key, required this.categories, required this.searchCategories})
      : super(key: key);

  final List<CategoryModel> categories;
  final List<CategoryModel> searchCategories;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CategoriesCubit>();
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .4,
          child: SingleChildScrollView(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                ...categories
                    .map((cat) => CategoryButton(
                          category: cat,
                          onTap: () => cubit.toggleSearchCategory(cat),
                          selected: cubit.state.searchCategories.contains(cat),
                        ))
                    .toList(),
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Row(
            children: [
              Expanded(
                child: TagEditor<CategoryModel>(
                    length: cubit.state.searchCategories.length,
                    inputDecoration: const InputDecoration(
                      hintText:
                      'Start typing or select from categories above...',
                      isDense: true,
                      border: InputBorder.none,
                    ),
                    tagBuilder: (context, index) => _Chip(
                      label: cubit.state.searchCategories[index].name,
                      onDeleted: () => cubit.toggleSearchCategory(
                          cubit.state.searchCategories[index]),
                    ),
                    suggestionsBoxMaxHeight: 200,
                    suggestionBuilder: (context, state, data) => ListTile(
                      key: ObjectKey(data),
                      title: Text(data.name),
                      onTap: () {
                        cubit.toggleSearchCategory(data);
                        state.selectSuggestion(data);
                      },
                    ),
                    onSubmitted: (_) {
                      context.read<DatasetCubit>().search();
                      FocusScope.of(context).unfocus();
                    },
                    suggestionsBoxElevation: 10,
                    findSuggestions: (String query) {
                      return cubit.state.categories
                          .where((element) => element.name
                          .replaceAll(' ', '')
                          .toLowerCase()
                          .contains(
                          query.replaceAll(' ', '').toLowerCase()))
                          .toList();
                    }),
              ),
              const SizedBox(
                width: 10,
              ),
              MaterialButton(
                onPressed: cubit.state.searchCategories.isEmpty
                    ? null
                    : () {
                  final cubit = context.read<DatasetCubit>();
                  //cubit.resizedImages.clear();
                  cubit.search();
                  FocusScope.of(context).unfocus();
                },
                color: Theme.of(context).primaryColor,
                disabledColor: Theme.of(context).disabledColor,
                textColor: Colors.white,
                child: const Text('Search'),
              )
            ],
          ),
        )
      ],
    );

  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.onDeleted,
  });

  final String label;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.only(left: 8.0),
      label: Text(label),
      deleteIcon: const Icon(
        Icons.close,
        size: 18,
      ),
      onDeleted: () {
        onDeleted();
      },
    );
  }
}
