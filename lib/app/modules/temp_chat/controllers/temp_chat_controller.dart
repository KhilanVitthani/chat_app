import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../main.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../../../model/chat_data_model.dart';
import '../../../model/user_model.dart';
import '../../../service/firebase_service.dart';
import '../views/temp_chat_view.dart';

class TempChatController extends GetxController with WidgetsBindingObserver {
  //TODO: Implement TempChatController
  UserModel? friendData;
  Rx<TextEditingController> chatController = TextEditingController().obs;
  RxList<ChatDataModel> chatDataList = RxList<ChatDataModel>([]);
  RxBool isUserOnline = false.obs;
  bool isFromNotification = false;
  Rx<ScrollController> scrollController = ScrollController().obs;
  RxBool showIndicator = false.obs;
  List<DocumentSnapshot>? documentList;
  //FireStoreRepository? fireStoreRepository;

  RxList<DocumentSnapshot> movieController = RxList();

  RxBool? showIndicatorController;
  String docId = "";
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    if (!isNullEmptyOrFalse(Get.arguments)) {
      friendData = Get.arguments[ArgumentConstant.userData];
      docId = Get.arguments[ArgumentConstant.docId] ?? "";
      isFromNotification = !isNullEmptyOrFalse(
          Get.arguments[ArgumentConstant.isFromNotification]);
      // fireStoreRepository = FireStoreRepository();

      getIt<FirebaseService>().setStatusForNotificationChatScreen(
          status: true, chatId: getChatId());
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.value.addListener(_scrollListener);
    });

    WidgetsBinding.instance.addObserver(this);
  }

  void _scrollListener() {
    if (scrollController.value.offset >=
            scrollController.value.position.maxScrollExtent &&
        !scrollController.value.position.outOfRange) {
      print("at the end of list");
      requestMoreData();
    }
  }

  String getChatId() {
    List<String> uids = [
      box.read(ArgumentConstant.userUid),
      friendData!.uId.toString()
    ];
    uids.sort((uid1, uid2) => uid1.compareTo(uid2));
    return uids.join("_chat_");
  }

  Future fetchFirstList() async {
    try {
      documentList =
          (await getIt<FirebaseService>().fetchFirstList(chatId: getChatId()));
      print(documentList);
      movieController.clear();
      movieController.addAll(documentList!);
      try {
        if (documentList!.length == 0) {
          // movieController!.sink.addError("No Data Available");
        }
      } catch (e) {}
    } on SocketException {
      // movieController.sink.addError(SocketException("No Internet Connection"));
    } catch (e) {
      print(e.toString());
      // movieController.sink.addError(e);
    }
  }

/*This will automatically fetch the next 10 elements from the list*/
  fetchNextMovies() async {
    try {
      updateIndicator(true);
      List<DocumentSnapshot> newDocumentList = await getIt<FirebaseService>()
          .fetchNextList(documentList ?? [], getChatId());
      documentList!.addAll(newDocumentList);
      movieController.value = documentList ?? [];
      try {
        if (documentList!.length == 0) {
          // movieController.sink.addError("No Data Available");
          updateIndicator(false);
        }
      } catch (e) {
        updateIndicator(false);
      }
    } on SocketException {
      // movieController.sink.addError(SocketException("No Internet Connection"));
      updateIndicator(false);
    } catch (e) {
      updateIndicator(false);
      print(e.toString());
      // movieController.sink.addError(e);
    }
  }

/*For updating the indicator below every list and paginate*/
  updateIndicator(bool value) async {
    showIndicator.value = value;
    // showIndicatorController!.value = value;
  }
  //
  // final CollectionReference _chatCollectionReference = FirebaseFirestore
  //     .instance
  //     .collection("chat")
  //     .doc(getChatId())
  //     .collection("chats");

  final StreamController<List<ChatDataModel>> _chatController =
      StreamController<List<ChatDataModel>>.broadcast();

  List<List<ChatDataModel>> _allPagedResults = <List<ChatDataModel>>[];

  static const int chatLimit = 10;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;

  Stream listenToChatsRealTime() {
    _requestChats();
    return _chatController.stream;
  }

  void _requestChats() {
    var pagechatQuery = FirebaseFirestore.instance
        .collection("chat")
        .doc(getChatId())
        .collection("chats")
        .orderBy("dateTime", descending: true)
        .limit(chatLimit);

    if (_lastDocument != null) {
      pagechatQuery = pagechatQuery.startAfterDocument(_lastDocument!);
    }

    if (!_hasMoreData) return;

    var currentRequestIndex = _allPagedResults.length;

    pagechatQuery.snapshots().listen(
      (QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          var generalChats = snapshot.docs
              .map((snapshot1) => ChatDataModel.fromJson(
                  snapshot1.data() as Map<String, dynamic>))
              .toList();

          var pageExists = currentRequestIndex < _allPagedResults.length;

          if (pageExists) {
            _allPagedResults[currentRequestIndex] = generalChats;
          } else {
            _allPagedResults.add(generalChats);
          }

          var allChats = _allPagedResults.fold<List<ChatDataModel>>(
              <ChatDataModel>[],
              (initialValue, pageItems) => initialValue..addAll(pageItems));

          _chatController.add(allChats);

          if (currentRequestIndex == _allPagedResults.length - 1) {
            _lastDocument = snapshot.docs.last;
          }

          _hasMoreData = generalChats.length == chatLimit;
        } else {
          _chatController.add([]);
        }
      },
    );
  }

  void requestMoreData() => _requestChats();

  @override
  void onReady() {
    super.onReady();
  }

  gotoMaxScrooll() {
    Timer(
      const Duration(
        milliseconds: 200,
      ),
      () {
        scrollController.value
            .jumpTo(scrollController.value.position.minScrollExtent);
      },
    );
  }

  Future<void> sendPushNotification({
    required String nTitle,
    required String nBody,
    required String nType,
    required String nSenderId,
    required String nUserDeviceToken,
    // Call Info Map Data
    Map<String, dynamic>? nCallInfo,
  }) async {
    // Variables
    final Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    await http
        .post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAoICxc_o:APA91bHEIwawAazThtHUn0iv-9xgKBe0CMet-sA6WE2VE0qvujFg9qSKqrpsSeytHei-jtdMI0_h2aVURTyG_CwTH0CdW9LT04Xv8smdsXQhWFPMEWVHC2CMCUyxvZcSxILkzwcrBwZa',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'title': nTitle,
            'body': nBody,
            'color': '#F1F7B5',
            'priority': 'high',
            'sound': "default"
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            "N_TYPE": nType,
            "N_SENDER_ID": nSenderId,
            "chatId": getChatId(),
            'call_info': nCallInfo, // Call Info Data
            'status': 'done',
            'docId': docId,
          },
          'to': nUserDeviceToken,
        },
      ),
    )
        .then((http.Response response) {
      if (response.statusCode == 200) {
        print('sendPushNotification() -> success');
      }
    }).catchError((error) {
      print('sendPushNotification() -> error: $error');
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        getIt<FirebaseService>().setStatusForNotificationChatScreen(
            status: false, chatId: getChatId());

        break;
      case AppLifecycleState.resumed:
        getIt<FirebaseService>().setStatusForNotificationChatScreen(
            status: true, chatId: getChatId());

        break;
      case AppLifecycleState.detached:
        getIt<FirebaseService>().setStatusForNotificationChatScreen(
            status: false, chatId: getChatId());

        break;
      case AppLifecycleState.inactive:
        getIt<FirebaseService>().setStatusForNotificationChatScreen(
            status: false, chatId: getChatId());
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void onClose() {
    super.onClose();
    getIt<FirebaseService>()
        .setStatusForNotificationChatScreen(status: false, chatId: getChatId());

    WidgetsBinding.instance.removeObserver(this);
  }

  void increment() => count.value++;
}
