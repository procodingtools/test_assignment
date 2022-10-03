import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_assignment/features/categories/cubits/categories_cubit.dart';
import 'package:test_assignment/ui/categories/widgets/categories_search_box.dart';
import 'package:test_assignment/ui/categories/widgets/category_button.dart';

/// {@category Category}
/// {@subCategory Widgets}
/// Widget which contains a wrapped list of [CategoryButton] with
/// a [CategoriesSearchBox] at the bottom.
class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CategoriesCubit>();
    return Column(
      children: [
        ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * .4,
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  ...cubit.state.categories
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
        ),
        const SizedBox(
          height: 10,
        ),
        const CategoriesSearchBox(),
      ],
    );
  }
}
