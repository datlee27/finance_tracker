import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Widget loading toàn màn hình
class LoadingView extends StatelessWidget {
  final String? message;

  const LoadingView({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: colors.accent,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
