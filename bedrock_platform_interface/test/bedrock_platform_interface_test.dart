import 'package:bedrock_platform_interface/bedrock_method_channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelBedrock platform = MethodChannelBedrock();
  const MethodChannel channel = MethodChannel('chunglyric.com/bedrock');

  setUp(() {
    bool status = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'wakelockStatus':
            return status;
          case 'wakelockEnable':
            status = methodCall.arguments;
            break;
        }
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('wakelock', () async {
    expect(await platform.wakelockStatus(), false);
    await platform.wakelockEnable(true);
    expect(await platform.wakelockStatus(), true);
    await platform.wakelockEnable(false);
    expect(await platform.wakelockStatus(), false);
  });
}
