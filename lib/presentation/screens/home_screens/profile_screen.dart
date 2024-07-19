import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progress_soft_app/blocs/authentication/login_bloc.dart';
import 'package:progress_soft_app/blocs/home/profile_bloc.dart';
import 'package:progress_soft_app/presentation/screens/auth_screens/login_screen.dart';
import 'package:progress_soft_app/presentation/widgets/loading_spinner_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(GetUserData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoggedOut) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileError) {
              return Center(
                child: Text(state.message),
              );
            } else if (state is ProfileLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full Name
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 8.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8.0),
                              const Text(
                                'Full Name: ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  state.user.fullName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        // Mobile Number
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 8.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8.0),
                              const Text(
                                'Mobile Number: ',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              Flexible(
                                child: Text(
                                  state.user.mobileNumber,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        // Age
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 8.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/age_picker.svg',
                                width: 25.0,
                                colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.primary,
                                    BlendMode.srcIn),
                              ),
                              const SizedBox(width: 8.0),
                              const Text(
                                'Age: ',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${state.user.age} years',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        // Gender
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 8.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/gender_symbol.svg',
                                width: 25.0,
                                colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.primary,
                                    BlendMode.srcIn),
                              ),
                              const SizedBox(width: 8.0),
                              const Text(
                                'Gender: ',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                state.user.gender,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Logout Button

                    Center(
                      child: BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return SizedBox(
                            width: double.infinity,
                            height: 50.0,
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<LoginBloc>().add(Logout());
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40.0, vertical: 0.0),
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Logout',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  const Icon(
                                    Icons.logout,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is LoggingOut) {
              return const LoadingSpinnerPage();
            } else {
              return const LoadingSpinnerPage();
            }
          },
        ),
      ),
    );
  }
}
