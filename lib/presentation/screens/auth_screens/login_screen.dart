import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:progress_soft_app/blocs/authentication/login_bloc.dart';
import 'package:progress_soft_app/presentation/screens/home_screens/bottom_nav_bar.dart';
import 'package:progress_soft_app/presentation/widgets/loading_spinner_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  // get mobileRegex and passwordRegex from shared preferences
  String mobileRegex = '';
  String passwordRegex = '';

  @override
  void initState() {
    super.initState();
    initializeRegex();
  }

  void initializeRegex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // default regex values if not found in shared preferences
    mobileRegex = prefs.getString('mobile_regex') ?? r'^\+9627[789]\d{7}$';
    passwordRegex = prefs.getString('password_regex') ??
        r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const BottomNavBar()));
          } else if (state is LoginFailure) {
            // check if get dialog is open and close it
            if (!Get.isSnackbarOpen) {
              Get.snackbar(
                'Error',
                state.message,
                colorText: Theme.of(context).colorScheme.secondary,
                backgroundColor: Theme.of(context).colorScheme.error,
                icon: Icon(Icons.error,
                    color: Theme.of(context).colorScheme.secondary),
                margin: const EdgeInsets.all(10.0),
              );
            }
          } else if (state is PasswordIncorrect) {
            if (!Get.isSnackbarOpen) {
              Get.snackbar(
                'Error',
                state.message,
                colorText: Theme.of(context).colorScheme.secondary,
                backgroundColor: Theme.of(context).colorScheme.error,
                icon: Icon(Icons.error,
                    color: Theme.of(context).colorScheme.secondary),
                margin: const EdgeInsets.all(10.0),
              );
            }
          } else if (state is UserNotRegistered) {
            Get.dialog(
              AlertDialog(
                title: const Text('User Not Registered'),
                content: Text(state.message),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to the registration screen
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 5.0,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        'Register Now',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                ],
                actionsPadding: const EdgeInsets.symmetric(
                  horizontal: 5.0,
                  vertical: 5.0,
                ),
                actionsOverflowButtonSpacing: 0.0,
                icon: Icon(
                  Icons.error,
                  color: Theme.of(context).colorScheme.error,
                  size: 30.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            );
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if(state is LoginLoading) {
              return const LoadingSpinnerPage();
            }
            return SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 0.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                'assets/images/logo_icon.png',
                                width: 90,
                                height: 90,
                              ),
                              const SizedBox(height: 20.0),
                              Text(
                                'Welcome Back',
                                style: TextStyle(
                                  fontSize: 35.0,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              Text(
                                'Enter your credentials to login',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 40.0),
                              // Mobile Number
                              TextFormField(
                                controller: _mobileController,
                                keyboardType: TextInputType.phone,
                                maxLength: 9,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  labelText: 'Mobile Number',
                                  prefix: Text(
                                    '+962 ',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.phone_outlined,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  errorStyle: const TextStyle(fontSize: 12.0),
                                  errorMaxLines: 2,
                                  counterText: '',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your mobile number';
                                  }
                                  value = '+962$value';
                                  if (!RegExp(mobileRegex).hasMatch(value)) {
                                    return 'Please enter a valid mobile number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10.0),
                              // Password
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(
                                    Icons.lock_outline_rounded,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  errorStyle: const TextStyle(fontSize: 12.0),
                                  errorMaxLines: 2,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (!RegExp(passwordRegex).hasMatch(value)) {
                                    return 'Password must be at least 8 characters long and contain at least one letter and one number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10.0),
                              SizedBox(
                                width: double.infinity,
                                height: 50.0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      BlocProvider.of<LoginBloc>(context).add(
                                        LoginWithCredentials(
                                          mobileNumber:
                                              '+962${_mobileController.text}',
                                          password: _passwordController.text,
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40.0, vertical: 0.0),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: Text(
                                    'Login Now',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40.0),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Navigate to the registration screen
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterScreen()));
                                },
                                child: Text(
                                  'Don\'t have an account? Register',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    height: 0.0,
                                  ),
                                ),
                              ),
                              Divider(
                                color: Theme.of(context).colorScheme.primary,
                                thickness: 2.0,
                                indent: 70.0,
                                endIndent: 70.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
