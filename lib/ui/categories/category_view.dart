import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_assignment/features/categories/cubits/categories_cubit.dart';
import 'package:test_assignment/models/category.dart';
import 'package:test_assignment/ui/categorties/widgets/categories_search_box.dart';
import 'package:test_assignment/ui/categorties/widgets/category_button.dart';

class CategoryView extends StatelessWidget {
  const CategoryView(
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

        const SizedBox(height: 10,),

        const CategoriesSearchBox(),
      ],
    );

  }
}
