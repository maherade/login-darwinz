import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login_task/styles/colors/color_manager.dart';

class DefaultTextField extends StatefulWidget {
  final String hintText;
  final String labelText;
  IconData? prefixIcon;
  IconData? suffixIcon;
  bool isPass;
  String value;
  int? lines;
  Color? hintColor;
  TextInputType textInputType;
  bool isEnabled;
  TextEditingController controller = TextEditingController();

  DefaultTextField(
      {required this.hintText,
      required this.controller,
      this.hintColor = Colors.grey,
      this.isPass = false,
      this.isEnabled = true,
      required this.textInputType,
      this.labelText = "",
      this.value = '',
      this.prefixIcon,
      this.suffixIcon,
      this.lines = 1,
      Key? key})
      : super(key: key);

  @override
  State<DefaultTextField> createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  bool isChecked = true;

  @override
  Widget build(BuildContext context) {
    return widget.isPass == false
        ? Container(
      width: MediaQuery.sizeOf(context).width >=150? MediaQuery.sizeOf(context).width * .3 : MediaQuery.sizeOf(context).width * .2,

      padding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
      constraints: BoxConstraints(
        maxWidth: 70.w,
        minWidth: 65.w,
      ),


      child: TextFormField(
              textInputAction: TextInputAction.next,
              style: const TextStyle(
                fontSize: 16.0,
                color: ColorManager.blackColor,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w300,
                    color: widget.hintColor),
                prefixIcon: Icon(
                  widget.prefixIcon,
                  color: Colors.grey,
                ),
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.white)),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                errorStyle: const TextStyle(
                  fontSize: 13.0,
                  color: ColorManager.redColor,
                ),
                fillColor: Colors.white,
                filled: true,
              ),
              maxLines: widget.lines,
              keyboardType: widget.textInputType,
              controller: widget.controller,
              enabled: widget.isEnabled,
              onChanged: (value) {
                widget.value = value;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Required Field';
                }
                return null;
              },
            ),
          )
        : Container(
      width: MediaQuery.sizeOf(context).width >=150? MediaQuery.sizeOf(context).width * .3 : MediaQuery.sizeOf(context).width * .2,

      padding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
      constraints: BoxConstraints(
        maxWidth: 70.w,
        minWidth: 65.w,
      ),

             child: TextFormField(
              textInputAction: TextInputAction.done,
              style: const TextStyle(
                fontSize: 15.0,
                color: ColorManager.textColor,
              ),
              decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    color: widget.hintColor,
                  ),
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                      borderSide: const BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.white)),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  errorStyle: const TextStyle(
                    fontSize: 13.0,
                    color: ColorManager.redColor,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(
                    widget.prefixIcon,
                    color: Colors.grey,
                  ),
                  suffixIcon: widget.isPass == true
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              isChecked = !isChecked;
                            });
                          },
                          icon: isChecked == true
                              ? const Icon(
                                  Icons.visibility_off,
                                  color: Colors.grey,
                                )
                              : const Icon(
                                  Icons.visibility,
                                  color: Colors.grey,
                                ),
                        )
                      : IconButton(
                          onPressed: () {},
                          icon: widget.suffixIcon != null
                              ? Icon(
                                  widget.suffixIcon,
                                  color: ColorManager.primaryColor,
                                )
                              : const SizedBox(
                                  height: 1,
                                  width: 1,
                                ),
                        )),
              keyboardType: widget.textInputType,
              controller: widget.controller,
              enabled: widget.isEnabled,
              obscureText: isChecked,
              onChanged: (value) {
                widget.value = value;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Required Field';
                }
                return null;
              },
            ),
          );
  }
}
