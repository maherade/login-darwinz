import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
      UserModel userModel = UserModel(
        uId: credential.user?.uid ?? "",
        name: name,
        email: email,
      );
      await getUsersCollection()
          .doc(userModel.uId)
          .set(userModel)
          .then((value) {
        emit(SignUpSuccessState());
        customToast(
          title: 'Account Created Successfully',
          color: Colors.blue,
        );
        print("--------------Account Created");
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
        await getUser();
        print(CashHelper.getData(key: 'isUid'));
        emit(LoginSuccessState());
        print("-----------Login Successfully");
        return;
      }
    } on FirebaseAuthException catch (e) {
      emit(LoginErrorState());
      print("-----------Login Failed");

      customToast(
          title: 'Invalid email or password', color: ColorManager.redColor);
    } catch (e) {
      customToast(
          title: 'Something went wrong $e', color: ColorManager.redColor);
    }
  }

  // Get User From FireStore without parameters using ID
  UserModel? user;

  Future<void> getUser() async {
    emit(GetUserLoadingState());
    FirebaseFirestore.instance
        .collection('Users')
        .doc('${CashHelper.getData(key: 'isUid')}')
        .get()
        .then((value) {
      user = UserModel.fromJson(value.data()!);
      print(user!.name);
      emit(GetUserSuccessState());
    }).catchError((error) {
      emit(GetUserErrorState());
    });
  }

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    emit(LoginLoadingState());
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return;
      }
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(LoginSuccessState());
    } catch (error) {
      emit(LoginErrorState());
      print("google sign in error $error");
    }
  }

// final FirebaseAuth auth = FirebaseAuth.instance;
// final GoogleSignIn googleSignIn = GoogleSignIn();
// UserModel? login;
//
// Future<String> signInWithGoogle() async {
//   emit(LoginWithGoogleLoadingState());
//
//   GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
//   final GoogleSignInAuthentication googleSignInAuthentication =
//       await googleSignInAccount!.authentication;
//   final AuthCredential credential = GoogleAuthProvider.credential(
//     accessToken: googleSignInAuthentication.accessToken,
//     idToken: googleSignInAuthentication.idToken,
//   );
//   final UserCredential authResult =
//       await auth.signInWithCredential(credential);
//   final User? user = authResult.user;
//   if (user != null) {
//     assert(user.email != null);
//     assert(user.displayName != null);
//      var name = user.displayName;
//     var email = user.email;
//      assert(!user.isAnonymous);
//     assert(await user.getIdToken() != null);
//     final User? currentUser = auth.currentUser;
//     assert(user.uid == currentUser!.uid);
//     print('signInWithGoogle succeeded: $user');
//     DioHelper.postData(
//       url: "auth/social/google",
//       data: {
//         "name": user.displayName,
//         "email": user.email,
//         "google_token": user.uid
//       },
//     ).then((value) {
//       login = UserModel.fromJson(value.data);
//       CashHelper.saveData(key: "google", value: true);
//       emit(LoginWithGoogleSuccessState());
//     }).catchError((e) {
//       emit(LoginWithGoogleSuccessState());
//     });
//     return '$user';
//   }
//
//   return "";
// }
}
