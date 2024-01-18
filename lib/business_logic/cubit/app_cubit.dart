import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login_task/data/models/branch_model.dart';
import 'package:login_task/data/models/company_model.dart';
import '../../constants/firebase_errors.dart';
import '../../core/local/cash_helper.dart';
import '../../data/models/user_model.dart';
import '../../presentations/widgets/toast.dart';
import '../../styles/colors/color_manager.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static AppCubit get(context) => BlocProvider.of<AppCubit>(context);

  // Create Account with name , email and password parameters
  void createAccountWithFirebaseAuth(
    String email,
    String password,
    String name,
  ) async {
    try {
      emit(SignUpLoadingState());
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await saveUser(
        name: name,
        email: email,
        id: (credential.user?.uid)!,
      ).then((value) {
        getUser(id: (credential.user?.uid)!);
        CashHelper.saveData(key: 'isUid', value: credential.user?.uid);
        customToast(
          title: "account_created_successfully",
          color: Colors.green.shade700,
        );
        emit(SignUpSuccessState());
        debugPrint("--------------Account Created");
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == FirebaseErrors.weakPassword) {
      } else if (e.code == FirebaseErrors.emailInUse) {
        emit(SignUpErrorState());
        customToast(
          title: 'This account already exists',
          color: ColorManager.redColor,
        );
        print("--------------Failed To Create Account");
      }
    }
  }

  // Read User with ID
  Future<UserModel?> readUserFromFireStore(String id) async {
    DocumentSnapshot<UserModel> user = await getUsersCollection().doc(id).get();
    var userModel = user.data();
    return userModel;
  }

  CollectionReference<UserModel> getUsersCollection() {
    return FirebaseFirestore.instance
        .collection(UserModel.collectionName)
        .withConverter(
          fromFirestore: (snapshot, options) =>
              UserModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
  }

  Future<void> saveUser({
    required String name,
    required String email,
    required String id,
  }) async {
    emit(SaveUserLoadingState());
    UserModel userModel = UserModel(
      uId: id,
      name: name,
      email: email,
    );
    FirebaseFirestore.instance
        .collection('Users')
        .doc(userModel.uId)
        .set(userModel.toJson())
        .then((value) {
      debugPrint('Save User Success');
      emit(SaveUserSuccessState());
    }).catchError((error) {
      debugPrint('Error in user Register is ${error.toString()}');
      emit(SaveUserErrorState());
    });
  }

  // Login using email and password
  Future<void> loginWithFirebaseAuth(String email, String password) async {
    try {
      emit(LoginLoadingState());
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel? userModel =
          await readUserFromFireStore(credential.user?.uid ?? "");
      if (userModel != null) {
        CashHelper.saveData(key: 'isUid', value: credential.user?.uid);
        await getUser(id: "${CashHelper.getData(key: "isUid")}");
        print(CashHelper.getData(key: 'isUid'));
        emit(LoginSuccessState());
        print("-----------Login Successfully");
        return;
      }
    } on FirebaseAuthException catch (e) {
      emit(LoginErrorState());
      print("-----------Login Failed $e");
      customToast(
          title: 'Invalid email or password', color: ColorManager.redColor);
    } catch (e) {
      customToast(
          title: 'Something went wrong $e', color: ColorManager.redColor);
    }
  }

  // Get User From FireStore without parameters using ID
  UserModel? user;

  Future<void> getUser({required String id}) async {
    emit(GetUserLoadingState());
    FirebaseFirestore.instance.collection('Users').doc(id).get().then((value) {
      user = UserModel.fromJson(value.data()!);
      print(user!.name);
      emit(GetUserSuccessState());
    }).catchError((error) {
      emit(GetUserErrorState());
    });
  }

  // Login with Google
  Future signInWithGoogle() async {
    // Trigger the authentication flow
    emit(LoginLoadingState());
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return;
      }
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      user = UserModel(
        uId: googleUser.id,
        name: googleUser.displayName,
        email: googleUser.email,
      );
      FirebaseFirestore.instance.collection('Users').doc(googleUser.id).set(
        user!.toJson(),
      ) .then((value) {
        emit(LoginSuccessState());
      });
      CashHelper.saveData(key: "isUid", value: googleUser.id);
      emit(LoginSuccessState());
    } catch (error) {
      emit(LoginErrorState());
      print("google sign in error $error");
    }
  }

  // Sign Out
  signOut() async {
    emit(SignOutLoadingState());
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    CashHelper.removeData(key: "isUid");
    emit(SignOutSuccessState());
  }

  CompanyModel? companyModel;

  Future<void> getCompanies() async {
    emit(GetCompaniesLoadingState());
    getUser(id: CashHelper.getData(key: "isUid"));
    FirebaseFirestore.instance
        .collection("My Company")
        .doc(CashHelper.getData(key: "isUid"))
        .get()
        .then((value) {
      if (value.data() != null) {
        companyModel = CompanyModel.fromJson(value.data()!);
      }else{
        companyModel = CompanyModel(uId: " ", name: " ", logo: " ");
      }
      emit(GetCompaniesSuccessState());
      print("Company Name is : ${companyModel!.name}");
      print("Company Logo is : ${companyModel!.logo}");
    }).catchError((error) {
      emit(GetCompaniesErrorState());
      companyModel = CompanyModel(uId: " ", name: " ", logo: " ");
      print("error in get Companies is : $error");
      print("Error Company Name is : ${companyModel!.name}");
      print("Error Company Logo is : ${companyModel!.logo}");
    });
  }

  BranchModel? branchModel;

  Future<void> getBranches() async {
    emit(GetBranchesLoadingState());
    getUser(id: CashHelper.getData(key: "isUid"));
    FirebaseFirestore.instance
        .collection("Branchs")
        .doc(CashHelper.getData(key: "isUid"))
        .get()
        .then((value) {
      if (value.data() != null) {
        branchModel = BranchModel.fromJson(value.data()!);
      } else {
        branchModel = BranchModel(uId: " ", name: " ", logo: " ");
      }
      emit(GetBranchesSuccessState());
      print("Branch Name is : ${branchModel!.name}");
      print("Branch Logo is : ${branchModel!.logo}");
    }).catchError((error) {
      emit(GetBranchesErrorState());
      branchModel = BranchModel(uId: " ", name: " ", logo: " ");
      print("error in get Branchs is : $error");
      print("Error Branch Name is : ${branchModel.toString()}");
    });
  }
}
