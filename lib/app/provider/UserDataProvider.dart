import 'package:flutter/cupertino.dart';

import '../model/user_model.dart';


class UserDataProvider extends ChangeNotifier {
  UserModel? userData;

  void setUserData(UserModel user) {
    this.userData = user;
    notifyListeners();
  }

  void updateLastRefreshedAt(int lastUpdatedAt){
    userData!.lastUpdatedAt=lastUpdatedAt;
    print('last updated at ${DateTime.fromMillisecondsSinceEpoch(userData!.lastUpdatedAt??DateTime.now().toUtc().millisecondsSinceEpoch)}');
    notifyListeners();
  }


}
