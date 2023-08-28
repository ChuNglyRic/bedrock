part of bedrock;

class Bedrock {
  static Bedrock? _instance;
  static WakeLock? _wakeLock;

  static Bedrock get instance => _instance ??= const Bedrock._();

  WakeLock get wakelock => _wakeLock ??= WakeLock();

  const Bedrock._();
}

class WakeLock {
  Future<bool> status() async =>
      (await BedrockPlatform.instance.wakelockStatus()) ?? false;

  Future<void> enable([bool enable = true]) async =>
      await BedrockPlatform.instance.wakelockEnable(enable);

  Future<void> disable() => enable(false);
}
