import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_tag_editor/tag_editor.dart';
import 'package:test_assignment/features/categories/cubits/categories_cubit.dart';
import 'package:test_assignment/features/dataset/cubits/dataset_cubit.dart';
import 'package:test_assignment/models/category.dart';

class CategoriesSearchBox extends StatelessWidget {
  const CategoriesSearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CategoriesCubit>();
    return Row(
      children: [
        Expanded(
          child: TagEditor<CategoryModel>(
              length: cubit.state.searchCategories.length,
              inputDecoration: const InputDecoration(
                hintText: 'Start typing or select from categories above...',
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
                        .contains(query.replaceAll(' ', '').toLowerCase()))
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
                  cubit.search();
                  FocusScope.of(context).unfocus();
                },
          color: Theme.of(context).primaryColor,
          disabledColor: Theme.of(context).disabledColor,
          textColor: Colors.white,
          child: const Text('Search'),
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
