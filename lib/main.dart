import 'package:flutter/material.dart';
import 'package:to_do_app/components/eror_dialog.dart';
import 'package:to_do_app/pages/tasks_screen.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    void navigateToTasksScreen(dynamic data) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TasksScreen(data: data),
        ),
      );
    }

    Future<void> fetchDataFromAPI(BuildContext context) async {
      try {
        final data =
            await http.get(Uri.parse('https://to-do.softwars.com.ua/'));
        navigateToTasksScreen(data);
      } catch (e) {
        ErrorDialog.showErrorDialog(context);
      }
    }

    return Scaffold(
        body: Center(
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFA9A9A9),
            Color(0xFF383838),
          ],
        )),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: ElevatedButton(
              onPressed: () {
                fetchDataFromAPI(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(140, 50),
                backgroundColor: const Color(0xFFFFD600),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Вхід',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'SanFrancisco',
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
