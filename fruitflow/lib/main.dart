import 'package:flutter/material.dart';
import 'package:fruitflow/core/router/app_router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main() async {
  usePathUrlStrategy();
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
