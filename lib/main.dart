import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:login_task/presentations/screens/signup_screen/signup_screen.dart';
import 'business_logic/cubit/app_cubit.dart';
import 'constants/constatnts.dart';
import 'core/local/cash_helper.dart';
import 'core/remote/dio_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CashHelper.init();
  await DioHelper.dioInit();
  uId = CashHelper.getData(key: 'isUid');
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBsiQ48HB6vdAnIPkOhxhTi4WxuUyn0oho",
        authDomain: "darwinz-login.firebaseapp.com",
        projectId: "darwinz-login",
        storageBucket: "darwinz-login.appspot.com",
        messagingSenderId: "237824966932",
        appId: "1:237824966932:web:5e53583db15500554a8201",
        measurementId: "G-NYQH133B3N"),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
          AppCubit()
            ..getUser(id: uId == null ? uId = '' : uId!)
            ..getCompanies()
            ..getBranches(),
        ),
      ],
      child:   ScreenUtilInit(
        designSize: const Size(150, 500),
        child: BlocConsumer<AppCubit, AppState>(
          listener: (context, state) {},
          builder: (context, state) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: SignUpScreen(),
            );
          },
        ),
      ),
    );
  }
}
