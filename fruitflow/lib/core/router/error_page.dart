import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fruitflow/core/router/app_routes.dart';

class ErrorPage extends StatelessWidget {
  final Exception? error;

  const ErrorPage({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    final message = _parseError(error);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Something went wrong'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Oops! An error occurred.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(fontSize: 14, color: Colors.red),
            ),
            const SizedBox(height: 8),
            if (error != null) ...[
              const Text(
                'Technical details:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              SelectableText(
                error.toString(),
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.goNamed(AppRoutes.splash),
                child: const Text('Go to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _parseError(Exception? error) {
    if (error == null) return 'An unknown error occurred.';

    final errorString = error.toString();

    if (errorString.contains('No routes for location')) {
      return 'The page you\'re looking for doesn\'t exist.';
    }
    if (errorString.contains('network') || errorString.contains('socket')) {
      return 'A network error occurred. Please check your connection.';
    }
    if (errorString.contains('permission') || errorString.contains('denied')) {
      return 'You don\'t have permission to access this page.';
    }

    return 'Something unexpected happened. Please try again.';
  }
}