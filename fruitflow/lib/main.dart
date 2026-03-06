import 'package:flutter/material.dart';
import 'package:fruitflow/core/router/app_router.dart';

Future<void> main() async {
 runApp(const FruitFlowApp());
}

class FruitFlowApp extends StatelessWidget {
  const FruitFlowApp({super.key});
  @override
  Widget build(BuildContext context) {
     return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'FruitFlow',
      routerConfig: appRouter,
    );
  }
}
