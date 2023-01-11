import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_sound/public/tau.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../../main.dart';
import '../../../utilities/progress_dialog_utils.dart';

class ChatScreenController extends GetxController {
  //TODO: Implement ChatScreenController

  final count = 0.obs;
  RxBool showVoiceRecorderArea = false.obs;
  String callDuration = "00:00";

  final Rx<StopWatchTimer> stopWatchTimer = StopWatchTimer().obs;

  GlobalKey one = GlobalKey();

  /*     =========Audio stuff==========     */

  Rx<FlutterSoundPlayer> myPlayer = FlutterSoundPlayer().obs;
  Rx<FlutterSoundRecorder> myRecorder = FlutterSoundRecorder().obs;
  Rx<FlutterSound> flutterSound = FlutterSound().obs;

  RxString myPath = "".obs;
  Rx<TextEditingController> messageController = TextEditingController().obs;

  String? globalVoiceUrl;
  String? globalVoiceDuration;

  RxBool showTextMessageInput = true.obs;
  RxBool showGifMessageInput = false.obs;
  RxBool disableMessageWays = false.obs;
  RxBool showMicrophoneButton = true.obs;

  RxBool showReportAndRemoveScreen = true.obs;
  RxBool showUnblockUserScreen = false.obs;
  RxBool disableCalls = false.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> stopRecording() async {
    await myRecorder.value.stopRecorder();
  }

  Future<void> startRecording() async {
    Initialized.fullyInitialized;

    var tempDir = await getTemporaryDirectory();
    myPath.value = '${tempDir.path}/flutter_sound.aac';

    await myRecorder.value.startRecorder(
      toFile: myPath.value,
      codec: Codec.aacADTS,
    );

    showVoiceRecorderArea.value = true;
    showTextMessageInput.value = false;
    showGifMessageInput.value = false;

    stopWatchTimer.value.onExecute.add(StopWatchExecute.start);
  }

  checkMicPermission() async {
    var status = await Permission.microphone.status;
    if (status.isGranted) {
      startRecording();
    } else {
      getIt<CustomDialogs>().showDialogPermission(
          context: Get.context!,
          title: "Microphone Access",
          message:
              "To record voice message from your device, {app_name} needs to access your microphone. Please tap “Allow” in the next step",
          confirmButtonText: "Okay",
          onPressed: () async {
            Get.back();
            requestMicrophonePermission();
          });
    }
  }

  Future<void> requestMicrophonePermission() async {
    var asked = await Permission.microphone.request();

    if (asked.isGranted) {
      startRecording();
    } else if (asked.isDenied) {
      // QuickHelp.showAppNotification(
      //     context: context,
      //     title: "permissions.microphone_access_denied".tr(),
      //     isError: true);
    } else if (asked.isPermanentlyDenied) {
      getIt<CustomDialogs>().showDialogPermission(
          context: Get.context!,
          title: "Microphone Access Denied",
          message:
              "To record voice message from your device, {app_name} needs to access your microphone. Please change in your settings",
          confirmButtonText: "Settings",
          onPressed: () async {
            Get.back();
            openAppSettings();
          });
    }
  }

  void increment() => count.value++;
}
