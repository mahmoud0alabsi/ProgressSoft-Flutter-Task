import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:progress_soft_app/blocs/authentication/registration_bloc.dart';
import 'package:progress_soft_app/presentation/widgets/loading_spinner_page.dart';

class OTPCodeScreen extends StatefulWidget {
  final String verificationId;

  const OTPCodeScreen({super.key, required this.verificationId});

  @override
  _OTPCodeScreenState createState() => _OTPCodeScreenState();
}

class _OTPCodeScreenState extends State<OTPCodeScreen> {
  late final String verificationId = widget.verificationId;
  final TextEditingController _otpController1 = TextEditingController();
  final TextEditingController _otpController2 = TextEditingController();
  final TextEditingController _otpController3 = TextEditingController();
  final TextEditingController _otpController4 = TextEditingController();
  final TextEditingController _otpController5 = TextEditingController();
  final TextEditingController _otpController6 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
            )),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).colorScheme.primary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocListener<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state is OtpFaliure) {
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
          } else if (state is OtpVerified) {
            if (!Get.isSnackbarOpen) {
              Get.snackbar(
                'Success',
                "OTP Verified Successfully!",
                colorText: Theme.of(context).colorScheme.secondary,
                backgroundColor: Colors.green,
                icon: Icon(Icons.check,
                    color: Theme.of(context).colorScheme.secondary),
                margin: const EdgeInsets.all(10.0),
              );
            }
            // back to previous registration screen after snackbar is closed
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pop(context);
            });
          }
        },
        child: BlocBuilder<RegistrationBloc, RegistrationState>(
          builder: (context, state) {
            if (state is OtpLoading) {
              return const LoadingSpinnerPage();
            }
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sms,
                      size: 100.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'Enter the OTP sent to your mobile number',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildOTPDigitField(_otpController1),
                        _buildOTPDigitField(_otpController2),
                        _buildOTPDigitField(_otpController3),
                        _buildOTPDigitField(_otpController4),
                        _buildOTPDigitField(_otpController5),
                        _buildOTPDigitField(_otpController6),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: () {
                          String otp = _otpController1.text +
                              _otpController2.text +
                              _otpController3.text +
                              _otpController4.text +
                              _otpController5.text +
                              _otpController6.text;

                          if (otp.length != 6) {
                            if (!Get.isSnackbarOpen) {
                              Get.snackbar(
                                'Error',
                                "Please enter OTP correctly",
                                colorText:
                                    Theme.of(context).colorScheme.secondary,
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                                icon: Icon(Icons.error,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                margin: const EdgeInsets.all(10.0),
                              );
                            }
                            return;
                          }
                          BlocProvider.of<RegistrationBloc>(context).add(
                              VerifyOtp(
                                  otp: otp, verificationId: verificationId));
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
                          'Submit',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper method to build OTP digit input field
  Widget _buildOTPDigitField(TextEditingController controller) {
    return SizedBox(
      width: 50.0,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.primary),
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.0,
              style: BorderStyle.solid,
            ),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            // auto focus to next field if OTP digit is entered
            FocusScope.of(context).nextFocus();
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter OTP';
          }
          return null;
        },
      ),
    );
  }
}
