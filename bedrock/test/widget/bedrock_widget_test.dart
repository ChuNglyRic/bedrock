import 'package:bedrock/bedrock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  testWidgets('BedrockWidget and builder smoke test', (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(
      home: GetBuilder<Controller>(
        init: Controller(),
        builder: (_) {
          return Column(
            children: [
              CounterBuilder(
                child: (Controller controller) =>
                    Counter('global', controller: controller),
              ),
              CounterBuilder(
                group: 'group',
                child: (Controller controller) =>
                    Counter('group', controller: controller),
              ),
              ElevatedButton(
                onPressed: Controller.instance.increase,
                child: const Text('increaseAndRefreshGlobal'),
              ),
              ElevatedButton(
                onPressed: Controller.instance.increaseWithId,
                child: const Text('increaseAndRefreshGroup'),
              ),
              ElevatedButton(
                onPressed: Controller.instance.refreshUi,
                child: const Text('refreshAll'),
              ),
            ],
          );
        },
      ),
    ));

    expect(find.text('global: 0'), findsOneWidget);
    expect(find.text('group: 0'), findsOneWidget);

    await widgetTester.tap(find.text('increaseAndRefreshGlobal'));
    await widgetTester.pump();

    expect(find.text('global: 1'), findsOneWidget);
    expect(find.text('group: 0'), findsOneWidget);

    await widgetTester.tap(find.text('increaseAndRefreshGroup'));
    await widgetTester.pump();

    expect(find.text('global: 1'), findsOneWidget);
    expect(find.text('group: 2'), findsOneWidget);

    await widgetTester.tap(find.text('refreshAll'));
    await widgetTester.pump();

    expect(find.text('global: 2'), findsOneWidget);
    expect(find.text('group: 2'), findsOneWidget);
  });
}

class Controller extends BedrockController {
  static Controller get instance => Get.find();

  int _count = 0;

  int get count => _count;

  void increase() {
    _count++;
    update();
  }

  void increaseWithId() {
    _count++;
    update(['group']);
  }

  void refreshUi() {
    update();
    update(['group']);
  }
}

class Counter extends BedrockWidget<Controller> {
  const Counter(this.prefixText, {super.key, required super.controller});

  final String prefixText;

  @override
  Widget build(BuildContext context) {
    return Text('$prefixText: ${controller.count}');
  }
}

class CounterBuilder extends BedrockWidgetBuilder<Controller, Counter> {
  const CounterBuilder({super.key, super.group, required super.child});
}
