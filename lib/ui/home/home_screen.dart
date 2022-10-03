import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_assignment/features/categories/cubits/categories_cubit.dart';
import 'package:test_assignment/features/dataset/cubits/dataset_cubit.dart';
import 'package:test_assignment/ui/home/widgets/categories_section.dart';
import 'package:test_assignment/ui/home/widgets/datasets_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => CategoriesCubit()..getCategories()),
            BlocProvider(
                create: (context) =>
                    DatasetCubit(categoryCubit: context.read<CategoriesCubit>()))
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener<CategoriesCubit, CategoriesState>(
                  listener: (context, state) {
                state.maybeWhen(
                    orElse: () {},
                    error: (_, __, err) => ScaffoldMessenger.of(context)
                        .showSnackBar( const SnackBar(
                            content:
                                Text('Error occurred. Please try again later'))));
              }),
              BlocListener<DatasetCubit, DatasetState>(
                  listener: (context, state) {
                state.maybeWhen(
                    orElse: () {},
                    error: (_, err) => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Error occurred. Please try again later'))));
              })
            ],
            child: _HomePage(),
          ),
        ),
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  _HomePage({super.key});

  bool isFetching = false;
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scroll) => _reloadListener(scroll, context),
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
  }

  _reloadListener(scroll, BuildContext context) {
    if (scroll.metrics.pixels > scroll.metrics.maxScrollExtent - 20 &&
        !isFetching) {
      isFetching = true;
      context
          .read<DatasetCubit>()
          .nextPage()
          .then((value) => isFetching = false);
    }
    return false;
  }
}
