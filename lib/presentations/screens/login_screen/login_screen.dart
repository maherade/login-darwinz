import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login_task/business_logic/cubit/app_cubit.dart';
import 'package:login_task/presentations/screens/home_screen/home_screen.dart';
import 'package:login_task/presentations/screens/signup_screen/signup_screen.dart';
import 'package:login_task/styles/colors/color_manager.dart';
import '../../widgets/default_text_field.dart';
import '../../widgets/defualtButton.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          emailController.clear();
          passwordController.clear();
          AppCubit.get(context).getCompanies();
          AppCubit.get(context).getBranches();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
              (route) => false);
        }

        if (state is LoginSuccessState) {
          AppCubit.get(context).getCompanies();
          AppCubit.get(context).getBranches();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return SafeArea(
          child: Scaffold(
            extendBodyBehindAppBar: true,
            body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ColorManager.whiteColor,
                    ColorManager.greyColor,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Image for login
                        Image.asset(
                          'assets/images/login.png',
                          height: MediaQuery.of(context).size.height * 0.35,
                          width: MediaQuery.of(context).size.width * .35,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        // Login Text
                        Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 3.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        //Text field for email
                        DefaultTextField(
                            isPass: false,
                            hintText: "Enter Your E-mail",
                            controller: emailController,
                            textInputType: TextInputType.emailAddress),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),

                        //Text field for password
                        DefaultTextField(
                            isPass: true,
                            hintText: "Enter Your Password",
                            controller: passwordController,
                            textInputType: TextInputType.text),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),

                        // Login button
                        state is LoginLoadingState
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                ),
                              )
                            : DefaultButton(
                                radies: 15,
                                width: MediaQuery.sizeOf(context).width * .3,
                                buttonText: "Login",
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.loginWithFirebaseAuth(
                                        emailController.text,
                                        passwordController.text);
                                  }
                                },
                              ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        // Or Text
                        const Text(
                          "Or",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        // Login with Google
                        state is LoginWithGoogleLoadingState
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  cubit.signInWithGoogle();
                                },
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * .3,
                                  height:
                                      MediaQuery.sizeOf(context).height * .06,
                                  decoration: const BoxDecoration(
                                    color: ColorManager.whiteColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    'assets/images/google.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),

                        // Don't have an account?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpScreen(),
                                      ));
                                },
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(color: Colors.blue),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
