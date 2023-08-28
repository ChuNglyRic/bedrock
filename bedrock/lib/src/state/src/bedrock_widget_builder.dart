import 'package:bedrock/src/state/src/bedrock_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import 'bedrock_widget.dart';

class BedrockWidgetBuilder<T extends BedrockController,
    K extends BedrockWidget<T>> extends StatelessWidget {
  const BedrockWidgetBuilder({
    super.key,
    this.tag,
    this.group,
    required this.child,
  });

  final String? tag;
  final Object? group;
  final K Function(T controller) child;

  @override
  Widget build(BuildContext context) {
    assert(group != BedrockController.globalGroup);
    return GetBuilder<T>(
      tag: tag,
      id: group ?? BedrockController.globalGroup,
      builder: (T controller) {
        return child(controller);
      },
    );
  }
}
