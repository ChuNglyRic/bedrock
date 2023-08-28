import 'dart:async';

import 'package:bedrock/bedrock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Native _native = Get.put(Native());

  @override
  void initState() {
    super.initState();
    _native.updateWakelockStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bedrock Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NativeWidgetBuilder(
                  child: (Native controller) =>
                      WakelockStatus(controller: controller)),
              NativeWidgetBuilder(
                  child: (Native controller) =>
                      ChangeWakelockButton(controller: controller)),
            ],
          ),
        ),
      ),
    );
  }
}

class Native extends BedrockController {
  bool? _wakelockStatus;

  bool? get wakelockStatus => _wakelockStatus;

  Future<bool?> updateWakelockStatus() async {
    try {
      _wakelockStatus = await Bedrock.instance.wakelock.status();
      update();
    } on PlatformException catch (_) {
      // do nothing
    }
  }

  Future<void> changeWakelock(bool enable) async {
    try {
      await Bedrock.instance.wakelock.enable(enable);
      _wakelockStatus = enable;
      update();
    } on PlatformException catch (_) {
      // do nothing
    }
  }
}

abstract class NativeWidget extends BedrockWidget<Native> {
  const NativeWidget({super.key, required super.controller});
}

class WakelockStatus extends NativeWidget {
  const WakelockStatus({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return Text('Wakelock status is: ${controller.wakelockStatus}\n');
  }
}

class ChangeWakelockButton extends NativeWidget {
  const ChangeWakelockButton({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () =>
          controller.changeWakelock(!(controller.wakelockStatus ?? false)),
      child: Text(controller.wakelockStatus ?? false ? 'disable' : 'enable'),
    );
  }
}

class NativeWidgetBuilder extends BedrockWidgetBuilder<Native, NativeWidget> {
  const NativeWidgetBuilder({super.key, super.group, required super.child});
}
