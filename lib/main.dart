import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test_assignment/ui/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  bool supported = true;
  if (Platform.isIOS) {
    IosDeviceInfo value = await deviceInfo.iosInfo;
    String model = value.utsname.machine!;
    if (!model.contains('iPhone')) {
      exit(0);
    }
    model = model.replaceAll('iPhone', '').replaceAll(',', '.');
    supported = double.parse(model) > 11.2;
  }
  runApp(MyApp(
    supported: supported,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.supported = true}) : super(key: key);

  final bool supported;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'COCO Explorer',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) =>
          ScrollConfiguration(behavior: _NoGlowOverScroll(), child: child!),
      home: supported ? const HomeScreen() : const _UnsupportedDeviceWidget(),
    );
  }
}

class _UnsupportedDeviceWidget extends StatelessWidget {
  const _UnsupportedDeviceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(
            'This device is not supported',
            style: TextStyle(color: Colors.grey, fontSize: 21),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _NoGlowOverScroll extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
