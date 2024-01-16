import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_task/business_logic/cubit/app_cubit.dart';
import 'package:login_task/constants/constatnts.dart';
import 'package:login_task/core/local/cash_helper.dart';
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
    print("companies  ${AppCubit.get(context).getCompanies(userId: CashHelper.getData(key: "isUid"))}");
    print("branches  ${AppCubit.get(context).getBranches(userId: CashHelper.getData(key: "isUid"))}");
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if(state is SignOutSuccessState) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              )
          );

        };
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title:  Text(cubit.companyModel!.name!,style: const TextStyle(color: ColorManager.blackColor),),
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
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * .3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(colors: [
                          ColorManager.whiteColor,
                          ColorManager.greyColor,
                        ])),
                    child: Image.network(cubit.companyModel!.logo!),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * .05,
                  ),
                  const Align(
                      alignment: Alignment.topLeft, child: Text("Branch")),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * .05,
                  ),
                  Row(
                    children: [
                      BranchWidget(
                        branchName: cubit.branchModel?.name??"Maher Branch",
                        logoPath: cubit.branchModel?.logo ?? "",
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
