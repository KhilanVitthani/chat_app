import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/temp_chat1_controller.dart';

class TempChat1View extends GetView<TempChat1Controller> {
  const TempChat1View({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TempChat1View'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'TempChat1View is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
