import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(250, 300),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'notes',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        brightness: Brightness.light,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WindowListener {
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            DragToMoveArea(
              child: SizedBox(
                height: 32,
                child: Container(),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                maxLines: null,
                autofocus: true,
                focusNode: myFocusNode,
                decoration: const InputDecoration(
                  hintText: '메모를 작성하세요',
                  border: InputBorder.none,
                ),
                onTapOutside: (ev) {
                  myFocusNode.requestFocus();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onWindowBlur() {
    myFocusNode.unfocus();
  }
}
