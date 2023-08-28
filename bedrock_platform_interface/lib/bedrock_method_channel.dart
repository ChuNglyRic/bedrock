import 'package:flutter/services.dart';

import 'bedrock_platform_interface.dart';

/// The method channel implementation of [BedrockPlatform].
class MethodChannelBedrock extends BedrockPlatform {
  static const channel = MethodChannel('chunglyric.com/bedrock');

  @override
  Future<void> wakelockEnable(bool enable) async {
    await channel.invokeMethod('wakelockEnable', enable);
  }

  @override
  Future<bool?> wakelockStatus() async {
    final status = await channel.invokeMethod<bool>('wakelockStatus');
    return status;
  }
}
