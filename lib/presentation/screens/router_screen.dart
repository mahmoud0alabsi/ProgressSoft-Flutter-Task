import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:progress_soft_app/blocs/authentication/login_bloc.dart';
import 'package:progress_soft_app/presentation/screens/auth_screens/login_screen.dart';
import 'package:progress_soft_app/presentation/screens/home_screens/bottom_nav_bar.dart';
import 'package:progress_soft_app/presentation/widgets/loading_spinner_page.dart';

class RouterScreen extends StatefulWidget {
  const RouterScreen({super.key});

  @override
  State<RouterScreen> createState() => _RouterScreenState();
}

class _RouterScreenState extends State<RouterScreen> {
  late LoginBloc loginBloc;
  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
    loginBloc.add(AutoLogin());

    // Clear splash screen
    Future.delayed(const Duration(seconds: 1), () {
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavBar(),
              ),
            );
          } else if (state is LoginFailure) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          }
        },
        child: const Scaffold(
          body: LoadingSpinnerPage(),
        ));
  }
}
