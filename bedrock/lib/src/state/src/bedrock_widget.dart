import 'package:flutter/widgets.dart';

import 'bedrock_controller.dart';

abstract class BedrockWidget<T extends BedrockController>
    extends StatelessWidget {
  const BedrockWidget({super.key, required this.controller});

  final T controller;
}
