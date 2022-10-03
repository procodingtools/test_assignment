import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_assignment/features/categories/cubits/categories_cubit.dart';
import 'package:test_assignment/ui/categories/category_view.dart';

/// {@category Category}
/// {@subCategory Widgets}
/// Widget contains [CategoriesCubit] BLoC builder to show [CategoryView]
class CategoriesSection extends StatelessWidget {
  const CategoriesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => const CategoryView(),
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
