import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSpinnerPage extends StatelessWidget {
  const LoadingSpinnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitWave(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
