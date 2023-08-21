# bedrock

Make building app easier.

## Features

- BedrockWidgetBuilder (base on [Get](https://pub.dev/packages/get))

## Usage

You can use the BedrockWidgetBuilder to simplify update ui. 

- create a controller

```dart
class Controller extends GetxController {
  static Controller get instance => Get.find();

  int _count = 0;

  int get count => _count;

  void increase() {
    _count++;
    update();
  }
}
```

- create a class

```dart
class Counter extends BedrockWidget<Controller> {
  const Counter({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return Text('${controller.count}');
  }
}
```

- create a builder

```dart
class CounterBuilder extends BedrockWidgetBuilder<Controller, Counter> {
  const CounterBuilder({super.key, super.group, required super.child});
}
```

- insert controller and add builder where you want

```dart
Get.lazyPut<Controller>(() => Controller());

CounterBuilder(
  child: (Controller controller) => Counter(controller: controller),
)
```

- operating controller anywhere 

```
final Controller controller => Get.find();
controller.increase();
```
