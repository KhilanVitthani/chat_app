import 'package:chat_app/app/constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../Widgets/container_with_courner.dart';
import '../../../Widgets/titleText.dart';
import '../../../utilities/date_utilities.dart';
import '../controllers/chat_screen_controller.dart';

class ChatScreenView extends GetView<ChatScreenController> {
  const ChatScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatScreenView'),
        centerTitle: true,
      ),
      body: Obx(() {
        return messageSpace(context);
      }),
    );
  }

  Widget messageSpace(BuildContext showContext) {
    return Column(
      children: [
        // Expanded(
        //   child: Padding(
        //     padding: EdgeInsets.only(left: 10, right: 10),
        //     child: FutureBuilder<List<dynamic>?>(
        //         future: loadMessages(), //_future, //loadUser(),
        //         builder: (BuildContext context, AsyncSnapshot snapshot) {
        //           if (snapshot.hasData) {
        //             results = snapshot.data as List<dynamic>;
        //             var reversedList = results.reversed.toList();
        //
        //             return StickyGroupedListView<dynamic, DateTime>(
        //               elements: reversedList,
        //               reverse: true,
        //               order: StickyGroupedListOrder.DESC,
        //               // Check first
        //               groupBy: (dynamic message) {
        //                 if (message.createdAt != null) {
        //                   return DateTime(message.createdAt!.year,
        //                       message.createdAt!.month, message.createdAt!.day);
        //                 } else {
        //                   return DateTime(DateTime.now().year,
        //                       DateTime.now().month, DateTime.now().day);
        //                 }
        //               },
        //               floatingHeader: true,
        //               groupComparator: (DateTime value1, DateTime value2) {
        //                 return value1.compareTo(value2);
        //               },
        //               itemComparator: (dynamic element1, dynamic element2) {
        //                 if (element1.createdAt != null &&
        //                     element2.createdAt != null) {
        //                   return element1.createdAt!
        //                       .compareTo(element2.createdAt!);
        //                 } else if (element1.createdAt == null &&
        //                     element2.createdAt != null) {
        //                   return DateTime.now().compareTo(element2.createdAt!);
        //                 } else if (element1.createdAt != null &&
        //                     element2.createdAt == null) {
        //                   return element1.createdAt!.compareTo(DateTime.now());
        //                 } else {
        //                   return DateTime.now().compareTo(DateTime.now());
        //                 }
        //               },
        //               groupSeparatorBuilder: (dynamic element) {
        //                 return Padding(
        //                   padding: EdgeInsets.only(bottom: 0, top: 3),
        //                   child: TextWithTap(
        //                     QuickHelp.getMessageTime(element.createdAt != null
        //                         ? element.createdAt!
        //                         : DateTime.now()),
        //                     textAlign: TextAlign.center,
        //                     color: kGreyColor1,
        //                     fontSize: 12,
        //                   ),
        //                 );
        //               },
        //               itemBuilder: (context, dynamic chatMessage) {
        //                 bool isMe = chatMessage.getAuthorId! ==
        //                     widget.currentUser!.objectId!
        //                     ? true
        //                     : false;
        //                 if (!isMe && !chatMessage.isRead!) {
        //                   _updateMessageStatus(chatMessage);
        //                 }
        //
        //                 if (chatMessage.getMessageList != null &&
        //                     chatMessage.getMessageList!.getAuthorId ==
        //                         widget.mUser!.objectId) {
        //                   MessageListModel chatList =
        //                   chatMessage.getMessageList as MessageListModel;
        //
        //                   if (!chatList.isRead! &&
        //                       chatList.objectId ==
        //                           chatMessage.getMessageListId) {
        //                     _updateMessageList(chatMessage.getMessageList!);
        //                   }
        //                 }
        //
        //                 return Padding(
        //                   padding: EdgeInsets.only(left: 5),
        //                   child: Container(
        //                     padding: EdgeInsets.only(top: 20),
        //                     child: isMe
        //                         ? mySentMessage(chatMessage)
        //                         : receivedMessage(chatMessage),
        //                   ),
        //                 );
        //               },
        //               // optional
        //               itemScrollController: listScrollController, // optional
        //             );
        //           } else if (snapshot.hasError) {
        //             return Center(
        //               child: QuickActions.noContentFound(
        //                   "message_screen.no_chat_title".tr(),
        //                   "message_screen.no_chat_explain".tr(),
        //                   "assets/svg/ic_tab_message.svg"),
        //             );
        //           } else {
        //             return Center(
        //               child: CircularProgressIndicator(),
        //             );
        //           }
        //         }),
        //   ),
        // ),
        Visibility(
          visible: controller.showVoiceRecorderArea.value,
          child: voiceRecorderArea(),
        ),
        // Visibility(visible: showGifMessageInput, child: gifInputField()),
        Visibility(
            visible: controller.showTextMessageInput.value,
            child: chatInputField(showContext)),
      ],
    );
  }

  Widget chatInputField(BuildContext showContext) {
    return Column(
      children: [
        // replyTextEditing(),
        // replyGifEditing(),
        // replyVoiceEditing(),
        ContainerCorner(
          // color: kTransparentColor,
          marginTop: 20,
          marginRight: 10,
          marginLeft: 10,
          child: ContainerCorner(
            // color: kTransparentColor,
            //shadowColor: kGrayColor,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ContainerCorner(
                        blurRadius: 20,
                        spreadRadius: 5,
                        borderRadius: 50,
                        marginBottom: 10,
                        child: Row(
                          children: [
                            // ContainerCorner(
                            //   color: appTheme.primaryTheme,
                            //   borderRadius: 50,
                            //   marginRight: 10,
                            //   marginLeft: 10,
                            //   onTap: () {
                            //     controller.showTextMessageInput.value = false;
                            //     controller.showGifMessageInput.value = true;
                            //     controller.showVoiceRecorderArea.value = false;
                            //   },
                            //   child: Center(
                            //     child: TextWithTap(
                            //       "Enter Message",
                            //       color: Colors.black,
                            //       fontSize: 14,
                            //       fontWeight: FontWeight.bold,
                            //       marginTop: 5,
                            //       marginBottom: 5,
                            //       marginLeft: 5,
                            //       marginRight: 5,
                            //     ),
                            //   ),
                            // ),
                            Expanded(
                              child: TextField(
                                // focusNode: messageTextFieldFocusNode,
                                minLines: 1,
                                maxLines: 3,
                                autocorrect: false,
                                controller: controller.messageController.value,
                                decoration: InputDecoration(
                                  hintText: "Enter Message",
                                  // border: InputBorder.none,
                                ),
                                onChanged: (text) {
                                  if (text.isNotEmpty) {
                                    controller.showMicrophoneButton.value =
                                        false;
                                  } else {
                                    controller.showMicrophoneButton.value =
                                        true;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: true,
                      child: ContainerCorner(
                        // shadowColor: QuickHelp.isDarkMode(context)
                        //     ? kContentColorGhostTheme
                        //     : kGreyColor3,
                        setShadowToBottom: true,
                        blurRadius: 20,
                        spreadRadius: 5,
                        borderRadius: 50,
                        marginLeft: 10,
                        marginBottom: 10,
                        onLongPress: () {
                          //TODO:PERMISSION
                          controller.checkMicPermission();
                        },
                        colors: [appTheme.primaryTheme, appTheme.primaryTheme],
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            "assets/svg/ic_microphone.svg",
                            color: Colors.white,
                            height: 10,
                            width: 10,
                          ),
                        ),
                        height: 50,
                        width: 50,
                        onTap: () {
                          controller.showTextMessageInput.value = true;
                          controller.showGifMessageInput.value = false;
                        },
                      ),
                    ),
                    Visibility(
                      visible: !controller.showMicrophoneButton.value,
                      child: ContainerCorner(
                        setShadowToBottom: true,
                        blurRadius: 20,
                        spreadRadius: 5,
                        borderRadius: 50,
                        marginLeft: 10,
                        marginBottom: 10,
                        colors: [appTheme.primaryTheme, appTheme.primaryTheme],
                        // colors: [kPrimaryColor, kSecondaryColor],
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            "assets/svg/send.svg",
                            color: Colors.white,
                            height: 10,
                            width: 10,
                          ),
                        ),
                        height: 50,
                        width: 50,
                        onTap: () {
                          if (controller
                              .messageController.value.text.isNotEmpty) {
                            //TODO://
                            // _saveMessage(messageController.text,
                            //     replyMessage: repliedMessage != null
                            //         ? repliedMessage
                            //         : null,
                            //     messageType: MessageModel.messageTypeText);
                            // setState(() {
                            controller.messageController.value.clear();
                            // controller.showReplyText = false;
                            // controller.textToBeReplied = "";
                            // controller.name = "";
                            // controller.repliedMessage = null;
                            // controller.showReplyGif = false;
                            // controller.showReplyVoice = false;
                            // controller.gifReplyUrl = "";
                            // });

                            //scrollToBottom(position: results.length);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget voiceRecorderArea() {
    return Column(
      children: [
        // replyTextEditing(),
        // replyGifEditing(),
        // replyVoiceEditing(),
        ContainerCorner(
          color: Colors.transparent,
          marginTop: 20,
          marginRight: 10,
          marginLeft: 10,
          child: ContainerCorner(
            color: Colors.transparent,
            //shadowColor: kGrayColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ContainerCorner(
                        color: Colors.white,
                        blurRadius: 20,
                        spreadRadius: 5,
                        borderRadius: 50,
                        marginBottom: 10,
                        child: Stack(clipBehavior: Clip.none, children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: SvgPicture.asset(
                                        "assets/svg/ic_microphone.svg",
                                        color: Colors.red,
                                        height: 18,
                                      ),
                                    ),
                                    StreamBuilder<int>(
                                      stream: controller
                                          .stopWatchTimer.value.secondTime,
                                      initialData: 0,
                                      builder: (context, snap) {
                                        final value = snap.data;

                                        return Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(8),
                                              child: TextWithTap(
                                                formatTime(value ?? 0),
                                                fontSize: 20,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              ContainerCorner(
                                // color: kTransparentColor,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_back,
                                      //  color: kGreyColor1,
                                    ),
                                    TextWithTap(
                                      "slide to cancel",
                                      // color: kGreyColor1,
                                      marginRight: 70,
                                      marginLeft: 10,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Positioned(
                            right: 0,
                            bottom: -6,
                            child: Draggable<String>(
                              data: "red",
                              axis: Axis.horizontal,
                              onDragEnd: (detail) {
                                // setState(() {
                                controller.stopRecording();

                                controller.showTextMessageInput.value = true;
                                controller.showGifMessageInput.value = false;
                                controller.showVoiceRecorderArea.value = false;
                                controller.stopWatchTimer.value.onExecute
                                    .add(StopWatchExecute.reset);

                                // });
                              },
                              child: ContainerCorner(
                                setShadowToBottom: true,
                                blurRadius: 20,
                                spreadRadius: 5,
                                borderRadius: 50,
                                colors: [appTheme.primaryTheme],
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                    "assets/svg/send.svg",
                                    color: Colors.white,
                                    height: 10,
                                    width: 10,
                                  ),
                                ),
                                height: 65,
                                width: 65,
                                onTap: () {
                                  // setState(() {
                                  controller.stopRecording();
                                  controller.showTextMessageInput.value = true;
                                  controller.showGifMessageInput.value = false;
                                  controller.showVoiceRecorderArea.value =
                                      false;
                                  // });

                                  //TODO:Save message

                                  // saveVoiceMessage(
                                  //     repliedMessage: repliedMessage != null
                                  //         ? repliedMessage
                                  //         : null);

                                  controller.stopWatchTimer.value.onExecute
                                      .add(StopWatchExecute.reset);
                                  // controller.showReplyText = false;
                                  // controller.textToBeReplied = "";
                                  // controller.name = "";
                                  // controller.repliedMessage = null;
                                  // controller.showReplyGif = false;
                                },
                              ),
                              feedback: ContainerCorner(
                                setShadowToBottom: true,
                                // colors: [kPrimaryColor, kSecondaryColor],
                                blurRadius: 20,
                                spreadRadius: 5,
                                borderRadius: 50,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                    "assets/svg/ic_microphone.svg",
                                    color: Colors.white,
                                    height: 10,
                                    width: 10,
                                  ),
                                ),
                                height: 65,
                                width: 65,
                                onTap: () {},
                              ),
                              childWhenDragging: Container(),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
