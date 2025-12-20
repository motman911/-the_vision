import 'package:flutter/material.dart';

class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget? fallback;
  final VoidCallback? onError;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.fallback,
    this.onError,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    // تشغيل ErrorCatcher
    FlutterError.onError = (FlutterErrorDetails details) {
      setState(() {
        hasError = true;
      });
      if (widget.onError != null) {
        widget.onError!();
      }
      FlutterError.presentError(details);
    };
  }

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return widget.fallback ?? _defaultErrorWidget();
    }
    return widget.child;
  }

  Widget _defaultErrorWidget() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('خطأ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            const Text(
              'حدث خطأ غير متوقع',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'يرجى المحاولة مرة أخرى',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  hasError = false;
                });
              },
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
