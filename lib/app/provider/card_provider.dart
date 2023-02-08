import 'package:flutter/cupertino.dart';

class CardProvider extends ChangeNotifier {
  int pageIndex=0;
  bool isLast=false;
  void setIndex(int index) {
    pageIndex = index;
    notifyListeners();
  }
  void setLastIndex(bool isLast) {
    this.isLast = isLast;
    notifyListeners();
  }
  void reset() {
    pageIndex = 0;
    notifyListeners();
  }
}