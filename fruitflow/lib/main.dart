import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:fruitflow/core/router/app_router.dart';
import 'package:fruitflow/features/initial/presentation/cubit/splash_cubit.dart';

void main() {
  usePathUrlStrategy();
  runApp(const FruitFlowApp());
}

class FruitFlowApp extends StatelessWidget {
  const FruitFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashCubit>(
          create: (_) => SplashCubit(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Layered',
        routerConfig: appRouter,
      ),
    );
  }
}