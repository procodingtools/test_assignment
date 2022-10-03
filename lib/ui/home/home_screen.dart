import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_assignment/app/constants.dart';
import 'package:test_assignment/features/categories/cubits/categories_cubit.dart';
import 'package:test_assignment/features/dataset/cubits/dataset_cubit.dart';
import 'package:test_assignment/ui/home/widgets/categories_section.dart';
import 'package:test_assignment/ui/home/widgets/datasets_section.dart';

/// First screen bootstrapped from the app. Initializing [CategoriesCubit] and
/// [DatasetCubit] providers and listeners and listens to user scrolling to
/// perform lazyLoading.
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Used to check if already fetching data to prevent multiple calls when user
  /// scrolling.
  bool _isFetching = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) => CategoriesCubit()..getCategories()),
            BlocProvider(
                create: (context) => DatasetCubit(
                    categoryCubit: context.read<CategoriesCubit>()))
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener<CategoriesCubit, CategoriesState>(
                  listener: (context, state) {
                state.maybeWhen(
                    orElse: () {},
                    error: (_, __, err) => ScaffoldMessenger.of(context)
                      ..clearSnackBars()
                      ..showSnackBar(const SnackBar(
                          content:
                              Text('Error occurred. Please try again later'))));
              }),
              BlocListener<DatasetCubit, DatasetState>(
                  listener: (context, state) {
                state.maybeWhen(
                    orElse: () {},
                    error: (_, err) => ScaffoldMessenger.of(context)
                      ..clearSnackBars()
                      ..showSnackBar(const SnackBar(
                          content:
                              Text('Error occurred. Please try again later'))));
              })
            ],
            child: Builder(builder: (context) {
              return NotificationListener<ScrollNotification>(
                onNotification: (scroll) =>
                    _reloadListener(scroll, context.read<DatasetCubit>()),
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  children: const [
                    CategoriesSection(),
                    SizedBox(
                      height: 20,
                    ),
                    DatasetsSection()
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  _reloadListener(scroll, DatasetCubit cubit) {
    if (scroll.metrics.pixels > scroll.metrics.maxScrollExtent - 100 &&
        !_isFetching) {
      _isFetching = true;
      cubit.nextPage().then((value) => _isFetching = false);
    }
    return false;
  }
}
