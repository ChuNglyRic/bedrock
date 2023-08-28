import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bedrock_method_channel.dart';

abstract class BedrockPlatform extends PlatformInterface {
  BedrockPlatform() : super(token: _token);

  static final Object _token = Object();

  static BedrockPlatform _instance = MethodChannelBedrock();

  static BedrockPlatform get instance => _instance;

  static set instance(BedrockPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> wakelockEnable(bool enable) {
    throw UnimplementedError('wakelockEnable() has not been implemented.');
  }

  Future<bool?> wakelockStatus() {
    throw UnimplementedError('wakelockStatus() has not been implemented.');
  }
}
