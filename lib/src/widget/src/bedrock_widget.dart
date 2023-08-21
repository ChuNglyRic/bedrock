import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

abstract class BedrockWidget<T extends GetxController> extends StatelessWidget {
  const BedrockWidget({super.key, required this.controller});

  final T controller;
}
