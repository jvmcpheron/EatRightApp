import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home_page/home.dart';
import 'pancake.dart';
//import 'package:groupies/Water_Clock/waterClockFuncs.dart';
import 'api.dart';
import 'search_page/search_button.dart';
import 'authentication_wrapper.dart';
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eat Right',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: AuthenticationWrapper(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(), // Add a spacer to push the title to the center
            Text(widget.title),
            const Spacer(flex: 2), // Add a larger spacer to keep title centered
          ],
        ),
        leading: const PancakeMenuButton(), // Move the pancake button to the leading position
        actions: const [SearchButton()], // search button
      ),
      body: const Center(
        child: Text('Welcome to Eat Right!'),
      ),
    );
  }
}

