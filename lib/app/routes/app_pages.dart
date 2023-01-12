import 'package:get/get.dart';

import '../../main.dart';
import '../constants/app_constant.dart';
import '../constants/sizeConstant.dart';
import '../modules/add_user/bindings/add_user_binding.dart';
import '../modules/add_user/views/add_user_view.dart';
import '../modules/chat_screen/bindings/chat_screen_binding.dart';
import '../modules/chat_screen/views/chat_screen_view.dart';
import '../modules/friend_request/bindings/friend_request_binding.dart';
import '../modules/friend_request/views/friend_request_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/my_friends/bindings/my_friends_binding.dart';
import '../modules/my_friends/views/my_friends_view.dart';
import '../modules/sign_up/bindings/sign_up_binding.dart';
import '../modules/sign_up/views/sign_up_view.dart';
import '../modules/temp_chat/bindings/temp_chat_binding.dart';
import '../modules/temp_chat/views/temp_chat_view.dart';
import '../modules/temp_chat1/bindings/temp_chat1_binding.dart';
import '../modules/temp_chat1/views/temp_chat1_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static String INITIAL =
      (!isNullEmptyOrFalse(box.read(ArgumentConstant.userUid)))
          ? Routes.HOME
          : Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_UP,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.ADD_USER,
      page: () => const AddUserView(),
      binding: AddUserBinding(),
    ),
    GetPage(
      name: _Paths.FRIEND_REQUEST,
      page: () => const FriendRequestView(),
      binding: FriendRequestBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_SCREEN,
      page: () => const ChatScreenView(),
      binding: ChatScreenBinding(),
    ),
    GetPage(
      name: _Paths.TEMP_CHAT,
      page: () => const TempChatView(),
      binding: TempChatBinding(),
    ),
    GetPage(
      name: _Paths.TEMP_CHAT1,
      page: () => const TempChat1View(),
      binding: TempChat1Binding(),
    ),
    GetPage(
      name: _Paths.MY_FRIENDS,
      page: () => const MyFriendsView(),
      binding: MyFriendsBinding(),
    ),
  ];
}
