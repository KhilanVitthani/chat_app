import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import '../../main.dart';
import '../constants/app_constant.dart';
import '../constants/sizeConstant.dart';
import '../model/user_model.dart';
import '../utilities/progress_dialog_utils.dart';

class FirebaseService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  Future<void> addUserDataToFireStore({required UserModel userModel}) async {
    return await firebaseFireStore
        .collection("user")
        .doc(userModel.uId.toString())
        .set(userModel.toJson());
  }

  Future<DocumentReference<Map<String, dynamic>>> addChatDataToFireStore(
      {required String chatId, required Map<String, dynamic> chatData}) async {
    return await firebaseFireStore
        .collection("chat")
        .doc(chatId)
        .collection("chats")
        .add(chatData);
  }

  updateFriendsTime({
    required String docId,
    required String friendId,
  }) async {
    await firebaseFireStore
        .collection("myFriends")
        .doc(box.read(ArgumentConstant.userUid))
        .collection("friends")
        .doc(docId)
        .update({"timeStamp": DateTime.now().millisecondsSinceEpoch});

    var documentSnapshot = await firebaseFireStore
        .collection("myFriends")
        .doc(friendId)
        .collection("friends")
        .where("uId", isEqualTo: box.read(ArgumentConstant.userUid))
        .limit(1)
        .get();
    print(documentSnapshot.docs.first.id);
    await firebaseFireStore
        .collection("myFriends")
        .doc(friendId)
        .collection("friends")
        .doc(documentSnapshot.docs.first.id)
        .update({"timeStamp": DateTime.now().millisecondsSinceEpoch});
  }

  Future<String> uplordImage(File? imgFile) async {
    String filename = path.basename(imgFile!.path);
    Reference reference =
        await FirebaseStorage.instance.ref().child("$filename");
    UploadTask uploadTask = reference.putFile(imgFile);

    var downlord =
        await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    String url = downlord.toString();
    print("URL:$url");
    return url;
  }

  Stream<QuerySnapshot> getChatData({required String chatId}) {
    return firebaseFireStore
        .collection("chat")
        .doc(chatId)
        .collection("chats")
        .orderBy("dateTime", descending: true)
        .snapshots();
  }

  Future<User?> registerUserInFirebase(
      {required BuildContext context, required UserModel userModel}) async {
    getIt<CustomDialogs>().showCircularDialog(context);
    User? user;
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
              email: userModel.email.toString(),
              password: userModel.password.toString());
      user = userCredential.user;
      if (!isNullEmptyOrFalse(user)) {
        if (!isNullEmptyOrFalse(user!.uid)) {
          userModel.uId = user.uid;
          box.write(ArgumentConstant.userUid, user.uid);
          await addUserDataToFireStore(userModel: userModel).then((value) {});
        }
      }
    } on FirebaseAuthException catch (e) {
      dynamic status = AuthExceptionHandler.handleAuthException(e);
      String msg = AuthExceptionHandler.generateErrorMessage(status);
      getSnackBar(context: context, text: msg.toString());
    }
    getIt<CustomDialogs>().hideCircularDialog(context);
    return user;
  }

  Future<User?> logInUserInFirebase(
      {required BuildContext context, required UserModel userModel}) async {
    getIt<CustomDialogs>().showCircularDialog(context);
    User? user;
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
              email: userModel.email.toString(),
              password: userModel.password.toString());
      user = userCredential.user;
      if (!isNullEmptyOrFalse(user)) {
        if (!isNullEmptyOrFalse(user!.uid)) {
          userModel.uId = user.uid;
          box.write(ArgumentConstant.userUid, user.uid);
        }
      }
    } on FirebaseAuthException catch (e) {
      dynamic status = AuthExceptionHandler.handleAuthException(e);
      String msg = AuthExceptionHandler.generateErrorMessage(status);
      getSnackBar(context: context, text: msg.toString());
    }
    getIt<CustomDialogs>().hideCircularDialog(context);
    return user;
  }

  Future<void> updateFcmToken({required String fcmToken}) async {
    await firebaseFireStore
        .collection("user")
        .doc(box.read(ArgumentConstant.userUid))
        .update({"FCM": fcmToken});
  }

  String getChatId({required String friendUid}) {
    List<String> uids = [
      box.read(ArgumentConstant.userUid),
      friendUid.toString()
    ];
    uids.sort((uid1, uid2) => uid1.compareTo(uid2));
    return uids.join("_chat_");
  }

  Future<UserModel?> getUserData(
      {required String uid, BuildContext? context, bool isLoad = true}) async {
    if (isLoad) {
      getIt<CustomDialogs>().showCircularDialog(context!);
    }
    var data = await firebaseFireStore.collection("user").doc(uid).get();
    if (isLoad) {
      getIt<CustomDialogs>().hideCircularDialog(context!);
    }
    return UserModel.fromJson(data.data()!);
  }

  Future<Map<String, dynamic>?> getUserNotificationStatus(
      {required String chatId,
      required String uid,
      BuildContext? context,
      bool isLoad = true}) async {
    if (isLoad) {
      getIt<CustomDialogs>().showCircularDialog(context!);
    }
    var data = await firebaseFireStore
        .collection("chat")
        .doc(chatId)
        .collection("chatOnlineStatus")
        .doc(uid)
        .get();
    if (isLoad) {
      getIt<CustomDialogs>().hideCircularDialog(context!);
    }
    return data.data() ?? {"isOnline": false};
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStreamData(
      {required String uid}) {
    return firebaseFireStore.collection("user").doc(uid).snapshots();
  }

  Future<void> logOut({required BuildContext context}) async {
    getIt<CustomDialogs>().showCircularDialog(context);
    setStatusForChatScreen(status: false);
    return await firebaseAuth.signOut();
  }

  Future<void> addFriend(
      {required BuildContext context,
      required String friendsUid,
      required UserModel friendsModel,
      required List<dynamic> myFriendList}) async {
    getIt<CustomDialogs>().showCircularDialog(context);
    await firebaseFireStore
        .collection("pendingRequest")
        .doc(friendsUid.toString())
        .collection("request")
        .add(friendsModel.toJson());

    await firebaseFireStore
        .collection("user")
        .doc(box.read(ArgumentConstant.userUid))
        .update({"requestedFriendsList": myFriendList});
    getIt<CustomDialogs>().hideCircularDialog(context);
  }

  Future<void> rejectFriendRequest(
      {required BuildContext context,
      required String friendsUid,
      required String docId,
      required UserModel friendsModel,
      required List<dynamic> myFriendsRequestedList}) async {
    getIt<CustomDialogs>().showCircularDialog(context);
    await firebaseFireStore
        .collection("pendingRequest")
        .doc(box.read(ArgumentConstant.userUid))
        .collection("request")
        .doc(docId)
        .delete();

    await firebaseFireStore
        .collection("user")
        .doc(friendsUid.toString())
        .update({"requestedFriendsList": myFriendsRequestedList});
    getIt<CustomDialogs>().hideCircularDialog(context);
  }

  Future<void> acceptRequest(
      {required BuildContext context,
      required String friendsUid,
      required String docId,
      required UserModel friendsModel,
      required UserModel userModel,
      required List<dynamic> myFriendsRequestedList,
      required List<dynamic> myUpdatedFriendList}) async {
    getIt<CustomDialogs>().showCircularDialog(context);
    await firebaseFireStore
        .collection("myFriends")
        .doc(box.read(ArgumentConstant.userUid))
        .collection("friends")
        .add(friendsModel.toJson());
    await firebaseFireStore
        .collection("myFriends")
        .doc(friendsUid)
        .collection("friends")
        .add(userModel.toJson());
    List<String> uids = [
      box.read(ArgumentConstant.userUid),
      friendsUid.toString()
    ];
    uids.sort((uid1, uid2) => uid1.compareTo(uid2));
    uids.join("_chat_");
    await firebaseFireStore
        .collection("chat")
        .doc(uids.join("_chat_"))
        .collection("chatOnlineStatus")
        .doc(box.read(ArgumentConstant.userUid))
        .set({"isOnline": false});
    await firebaseFireStore
        .collection("chat")
        .doc(uids.join("_chat_"))
        .collection("chatOnlineStatus")
        .doc(friendsUid)
        .set({"isOnline": false});
    await firebaseFireStore
        .collection("pendingRequest")
        .doc(box.read(ArgumentConstant.userUid))
        .collection("request")
        .doc(docId)
        .delete();

    await firebaseFireStore.collection("user").doc(friendsUid).update({
      "requestedFriendsList": myFriendsRequestedList,
      "friendsList": friendsModel.friendsList
    });
    await firebaseFireStore
        .collection("user")
        .doc(box.read(ArgumentConstant.userUid))
        .update({"friendsList": myUpdatedFriendList});
    getIt<CustomDialogs>().hideCircularDialog(context);
  }

  Stream<QuerySnapshot> getAllUsersList() {
    return firebaseFireStore.collection("user").orderBy("name").snapshots();
  }

  Stream<QuerySnapshot> getAllFriendsOfUser() {
    return firebaseFireStore
        .collection("myFriends")
        .doc(box.read(ArgumentConstant.userUid))
        .collection("friends")
        .orderBy("timeStamp", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllPendingRequestList() {
    return firebaseFireStore
        .collection("pendingRequest")
        .doc(box.read(ArgumentConstant.userUid).toString())
        .collection("request")
        // .orderBy("name")
        .snapshots();
  }

  Future<void> setStatusForChatScreen({required bool status}) async {
    return await firebaseFireStore
        .collection("user")
        .doc(box.read(ArgumentConstant.userUid))
        .update({"inChatScreen": status});
  }

  Future<void> setStatusForNotificationChatScreen(
      {required bool status, required String chatId}) async {
    await firebaseFireStore
        .collection("chat")
        .doc(chatId)
        .collection("chatOnlineStatus")
        .doc(box.read(ArgumentConstant.userUid))
        .set({"isOnline": status});
  }
}

enum AuthStatus {
  successful,
  wrongPassword,
  emailAlreadyExists,
  userNotFound,
  invalidEmail,
  weakPassword,
  unknown,
}

class AuthExceptionHandler {
  static handleAuthException(FirebaseAuthException e) {
    AuthStatus status;
    switch (e.code) {
      case "invalid-email":
        status = AuthStatus.invalidEmail;
        break;
      case "wrong-password":
        status = AuthStatus.wrongPassword;
        break;
      case "user-not-found":
        status = AuthStatus.userNotFound;
        break;
      case "weak-password":
        status = AuthStatus.weakPassword;
        break;
      case "email-already-in-use":
        status = AuthStatus.emailAlreadyExists;
        break;
      default:
        status = AuthStatus.unknown;
    }
    return status;
  }

  static String generateErrorMessage(error) {
    String errorMessage;
    switch (error) {
      case AuthStatus.invalidEmail:
        errorMessage = "Your email address appears to be malformed.";
        break;
      case AuthStatus.userNotFound:
        errorMessage = "No user found for that email.";
        break;
      case AuthStatus.weakPassword:
        errorMessage = "Your password should be at least 6 characters.";
        break;
      case AuthStatus.wrongPassword:
        errorMessage = "Your email or password is wrong.";
        break;
      case AuthStatus.emailAlreadyExists:
        errorMessage =
            "The email address is already in use by another account.";
        break;
      default:
        errorMessage = "An error occured. Please try again later.";
    }
    return errorMessage;
  }
}
