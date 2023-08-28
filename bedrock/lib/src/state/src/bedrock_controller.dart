import 'package:get/get_state_manager/get_state_manager.dart';

abstract class BedrockController extends GetxController {
  static String get globalGroup => 'bedrock_controller';

  @override
  void update([List<Object>? ids, bool condition = true]) =>
      super.update(ids ?? [globalGroup], condition);
}
