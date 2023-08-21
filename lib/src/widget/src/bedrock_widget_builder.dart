import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import 'bedrock_widget.dart';

class BedrockWidgetBuilder<T extends GetxController, K extends BedrockWidget<T>> extends StatelessWidget {
  const BedrockWidgetBuilder({
    super.key,
    this.group,
    required this.child,
  });

  final Object? group;
  final K Function(T controller) child;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
      id: group,
      builder: (T controller) {
        return child(controller);
      },
    );
  }
}
