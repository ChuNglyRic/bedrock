import 'package:bedrock/bedrock.dart';
import 'package:bedrock_platform_interface/bedrock_method_channel.dart';
import 'package:bedrock_platform_interface/bedrock_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBedrockPlatform
    with MockPlatformInterfaceMixin
    implements BedrockPlatform {
  bool _state = false;

  @override
  Future<void> wakelockEnable(bool enable) async => _state = enable;

  @override
  Future<bool?> wakelockStatus() => Future.value(_state);
}

void main() {
  final BedrockPlatform initialPlatform = BedrockPlatform.instance;

  test('$MethodChannelBedrock is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBedrock>());
  });

  test('wakelock', () async {
    MockBedrockPlatform fakePlatform = MockBedrockPlatform();
    BedrockPlatform.instance = fakePlatform;

    expect(await Bedrock.instance.wakelock.status(), false);
    await Bedrock.instance.wakelock.enable();
    expect(await Bedrock.instance.wakelock.status(), true);
    await Bedrock.instance.wakelock.disable();
    expect(await Bedrock.instance.wakelock.status(), false);
  });
}
