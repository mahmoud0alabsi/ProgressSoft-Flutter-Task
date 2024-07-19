import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:progress_soft_app/blocs/authentication/login_bloc.dart';
import 'package:progress_soft_app/blocs/authentication/registration_bloc.dart';
import 'package:progress_soft_app/blocs/home/posts_bloc.dart';
import 'package:progress_soft_app/blocs/home/profile_bloc.dart';
import 'package:progress_soft_app/firebase_options.dart';
import 'package:progress_soft_app/repository/repos/system_configuration_repo.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'theme.dart';
import 'presentation/screens/router_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Preserve Flutter Native Splash
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize System Configuration
  SystemConfigurationRepository.initialSystemConfiguration();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<RegistrationBloc>(
          create: (BuildContext context) => RegistrationBloc(),
        ),
        BlocProvider<LoginBloc>(
          create: (BuildContext context) => LoginBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (BuildContext context) => ProfileBloc(),
        ),
        BlocProvider<PostsBloc>(
          create: (BuildContext context) => PostsBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: const RouterScreen(),
    );
  }
}
