import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:progress_soft_app/blocs/authentication/registration_bloc.dart';
import 'package:progress_soft_app/presentation/widgets/loading_spinner_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';
import 'otp_Screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _selectedGender;
  DateTime? _selectedDateOfBirth;
  int? _userAge;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String mobileRegex = '';
  String passwordRegex = '';

  List<String> genders = ['Male', 'Female'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (picked != null && picked != _selectedDateOfBirth) {
      setState(() {
        _selectedDateOfBirth = picked;
        _userAge = calculateAge(_selectedDateOfBirth!);
        if (_userAge! <= 0) {
          _userAge = null;
        }
      });
    }
  }

  int calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

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
      body: BlocListener<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationSuccess) {
            Future.delayed(const Duration(seconds: 1), () {
              Get.snackbar(
                'Success',
                "Registration Successful!",
                colorText: Theme.of(context).colorScheme.secondary,
                backgroundColor: Colors.green,
                icon: Icon(Icons.check,
                    color: Theme.of(context).colorScheme.secondary),
                margin: const EdgeInsets.all(10.0),
              );
            });

            Future.delayed(const Duration(seconds: 2), () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
              );
            });
          } else if (state is RegistrationFailure) {
            Get.snackbar(
              'Error',
              state.message,
              colorText: Theme.of(context).colorScheme.secondary,
              backgroundColor: Theme.of(context).colorScheme.error,
              icon: Icon(Icons.error,
                  color: Theme.of(context).colorScheme.secondary),
              margin: const EdgeInsets.all(10.0),
            );
          } else if (state is OtpSent) {
            // Navigate to OTP screen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OTPCodeScreen(
                  verificationId: state.verificationId,
                ),
              ),
            );
          } else if (state is OtpSentError) {
            Get.snackbar(
              'Error',
              state.message,
              colorText: Theme.of(context).colorScheme.secondary,
              backgroundColor: Theme.of(context).colorScheme.error,
              icon: Icon(Icons.error,
                  color: Theme.of(context).colorScheme.secondary),
              margin: const EdgeInsets.all(10.0),
            );
          } else if (state is OtpVerified) {
            // check if get dialog is open and close it
            if (Get.isDialogOpen == true) Get.back();
            // trigger RegisterUser event
            BlocProvider.of<RegistrationBloc>(context).add(RegisterUser(
              fullName: _fullNameController.text,
              mobileNumber: '+962${_mobileController.text}',
              age: _userAge!,
              gender: _selectedGender!,
              password: _passwordController.text,
            ));
          }
        },
        child: BlocBuilder<RegistrationBloc, RegistrationState>(
          builder: (context, state) {
            if (state is RegistrationLoading) {
              return const LoadingSpinnerPage();
            }
            return SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
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
                              // Sign up
                              Text(
                                'Sign up',
                                style: TextStyle(
                                  fontSize: 35.0,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              // Create your account
                              Text(
                                'Create your account',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 40.0),
                              // Full Name
                              TextFormField(
                                controller: _fullNameController,
                                decoration: InputDecoration(
                                  labelText: 'Full Name',
                                  prefixIcon: Icon(
                                    Icons.person_outline_rounded,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  errorStyle: const TextStyle(fontSize: 12.0),
                                  errorMaxLines: 2,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your full name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10.0),
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
                                  prefixIcon: Icon(
                                    Icons.phone_outlined,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  prefix: Text(
                                    '+962 ',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade400,
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
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
                              // Age picker
                              Container(
                                width: double.infinity,
                                color: const Color.fromRGBO(0, 51, 102, 0.05),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _selectDate(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    surfaceTintColor:
                                        const Color.fromRGBO(0, 51, 102, 0.05),
                                    shadowColor:
                                        const Color.fromRGBO(0, 0, 0, 0.0),
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        color: Color.fromRGBO(189, 189, 189, 1),
                                        width: 1.0,
                                        style: BorderStyle.solid,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 10.0),
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/age_picker.svg',
                                          width: 25.0,
                                          colorFilter: ColorFilter.mode(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              BlendMode.srcIn),
                                        ),
                                        const SizedBox(width: 10.0),
                                        Text(
                                          _userAge != null
                                              ? '$_userAge Years'
                                              : 'Select Date of Birth',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: _userAge != null
                                                ? FontWeight.w500
                                                : FontWeight.normal,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              // Gender
                              DropdownButtonFormField(
                                value: _selectedGender,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedGender = newValue;
                                  });
                                },
                                items: genders.map((gender) {
                                  return DropdownMenuItem(
                                    value: gender,
                                    child: Row(
                                      children: [
                                        Icon(
                                          gender == 'Male'
                                              ? Icons.male_outlined
                                              : Icons.female_outlined,
                                        ),
                                        const SizedBox(width: 10.0),
                                        Text(gender),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  labelText: 'Gender',
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0, right: 10.0),
                                    child: SvgPicture.asset(
                                      'assets/icons/gender_symbol.svg',
                                      colorFilter: ColorFilter.mode(
                                          Theme.of(context).colorScheme.primary,
                                          BlendMode.srcIn),
                                    ),
                                  ),
                                  prefixIconConstraints: const BoxConstraints(
                                    maxWidth: 45.0,
                                    maxHeight: 35.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select your gender';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10.0),
                              // Password
                              TextFormField(
                                obscureText: _obscurePassword,
                                controller: _passwordController,
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
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
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
                              // Confirm Password
                              TextFormField(
                                obscureText: _obscureConfirmPassword,
                                controller: _confirmPasswordController,
                                decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  prefixIcon: Icon(
                                    Icons.lock_outline_rounded,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  errorStyle: const TextStyle(fontSize: 12.0),
                                  errorMaxLines: 2,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match';
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
                                    if (_userAge == 0 || _userAge == null) {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        if (!Get.isSnackbarOpen) {
                                          Get.snackbar(
                                            'Error',
                                            'Please select your date of birth to calculate your age, you must be at least 1 year old',
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .error,
                                            colorText: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            icon: Icon(
                                              Icons.error,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                            margin: const EdgeInsets.all(10.0),
                                          );
                                        }
                                      }
                                      return;
                                    }
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      // Send OTP Verification Code
                                      BlocProvider.of<RegistrationBloc>(context)
                                          .add(SendOtp(
                                        mobileNumber:
                                            '+962${_mobileController.text}',
                                      ));
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
                                    'Register',
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
                                  // Navigate to the Login screen
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Already have an account? Login',
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
