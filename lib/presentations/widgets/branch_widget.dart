import 'package:flutter/material.dart';
import 'package:login_task/styles/colors/color_manager.dart';

class BranchWidget extends StatelessWidget {
  String branchName;
  String logoPath;

  BranchWidget({ required this.branchName, required this.logoPath, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: ColorManager.greyColor,
      ),
      child: Column(
        children: [
          Image.network(
            logoPath,
            width: MediaQuery.sizeOf(context).width * .15,
            height: MediaQuery.sizeOf(context).height * .1,
            fit: BoxFit.cover,
          ),
           SizedBox(
            height: MediaQuery.sizeOf(context).height * .01,
          ),
          Text(branchName, style: const TextStyle(color: Colors.black,fontSize: 18),)
        ],
      ),
    );
  }
}
