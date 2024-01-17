import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login_task/business_logic/cubit/app_cubit.dart';
import 'package:login_task/presentations/screens/home_screen/home_screen.dart';
import 'package:login_task/presentations/widgets/default_text_field.dart';
import 'package:login_task/presentations/widgets/defualtButton.dart';
import 'package:login_task/styles/colors/color_manager.dart';
import '../../../core/local/cash_helper.dart';
import '../login_screen/login_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is SignUpSuccessState) {
          emailController.clear();
          passwordController.clear();
          nameController.clear();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ), (route) => false );
        }
        if (state is LoginSuccessState) {
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
              )),
              child: Padding(
                padding:   EdgeInsets.all(MediaQuery.sizeOf(context).width * .05),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Image for sign up
                        Image.asset(
                          'assets/images/sign_up.png',
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width * .4,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        // Sign Up Text
                        Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 5.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        //Text field for name
                        DefaultTextField(
                            isPass: false,
                            hintText: "Enter Your Name",
                            controller: nameController,
                            textInputType: TextInputType.text),
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
                        // Sign Up Button
                        state is SignUpLoadingState
                            ? const CircularProgressIndicator(
                                color: Colors.blue,
                              )
                            : DefaultButton(
                          width: MediaQuery.sizeOf(context).width >=150? MediaQuery.sizeOf(context).width * .3 : MediaQuery.sizeOf(context).width * .2,
                          buttonText: "Sign Up ",
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.createAccountWithFirebaseAuth(
                                        emailController.text,
                                        passwordController.text,
                                        nameController.text);
                                  }
                                  cubit.getCompanies();
                                  cubit.getBranches();
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
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        // Login with Google
                        GestureDetector(
                          onTap: () {
                            cubit.signInWithGoogle();
                          },
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * .3,
                            height: MediaQuery.sizeOf(context).height * .06,
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
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        // Already have an account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account?"),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ));
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(color: Colors.blue),
                                ))
                          ],
                        ),
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
