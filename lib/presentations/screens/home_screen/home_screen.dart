import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_task/business_logic/cubit/app_cubit.dart';
import 'package:login_task/presentations/widgets/branch_widget.dart';
import 'package:login_task/styles/colors/color_manager.dart';
import '../login_screen/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is SignOutSuccessState) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ));
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return  Scaffold(
          appBar: AppBar(
            title: Text(
             cubit.user!.uId ==null? " ":  cubit.user!.name!,
              style: const TextStyle(color: ColorManager.blackColor),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    cubit.signOut();
                  },
                  child: const Row(
                    children: [
                      Text(
                        "Logout",
                        style: TextStyle(
                            color: ColorManager.redColor, fontSize: 18),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.logout_outlined,
                        color: ColorManager.redColor,
                        size: 22,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          body:
          cubit.user!.uId ==null||
          cubit.companyModel!.uId == " " ||
                  cubit.companyModel!.logo == " " ||
                  cubit.branchModel!.name == " "
              ? const SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: Text("There is no Company "),
                  ),
                )
              : SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        cubit.companyModel!.logo == ""
                            ? const SizedBox()
                            : Container(
                                width: double.infinity,
                                height: MediaQuery.sizeOf(context).height * .3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: const LinearGradient(
                                    colors: [
                                      ColorManager.whiteColor,
                                      ColorManager.greyColor,
                                    ],
                                  ),
                                ),
                                child: Image.network(cubit.companyModel!.logo!),
                              ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * .05,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child:
                                Text("Branch", style: TextStyle(fontSize: 20))),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * .03,
                        ),
                       cubit.branchModel!.logo == "" ? const SizedBox() :
                       Row(
                         children: [
                           BranchWidget(
                              branchName: cubit.branchModel!.name!,
                              logoPath: cubit.branchModel!.logo!,
                            ),
                         ],
                       ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
