import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_app/pages/task_detail_screen.dart';
import '../components/tasks_list.dart';

class TaskScreen extends StatefulWidget {
  final dynamic data;

  const TaskScreen({super.key, this.data});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  String selectedButton = 'Усі';

  void _selectButton(String buttonName) {
    setState(() {
      selectedButton = buttonName;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFFA9A9A9),
    ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA9A9A9),
        elevation: 0,
        actions: [
          _buildButton('Усі'),
          _buildButton('Робочі'),
          _buildButton('Особисті'),
        ],
      ),
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
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 25,
            ),
            Expanded(child: TaskListScreen()),
          ],
        ),
      )),
      floatingActionButton: SizedBox(
        height: 70, // Adjust the height of the FloatingActionButton
        width: 70,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const TaskDetailScreen()), // Replace SecondPage with the desired page you want to navigate to
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25), // Half of the width
          ),
          backgroundColor: const Color(0xFFFFD600),
          child: const Icon(
            color: Color(0xFF383838),
            Icons.add,
            size: 45,
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String buttonName) {
    final isSelected = buttonName == selectedButton;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: ElevatedButton(
          onPressed: () => _selectButton(buttonName),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(106, 48),
            backgroundColor:
                isSelected ? const Color(0xFFFBEFB4) : const Color(0xFFDBDBDB),
            elevation: isSelected ? 4 : 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Text(
            buttonName,
            style: const TextStyle(
              color: Color(0xFF383838),
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: 'SanFrancisco',
            ),
          ),
        ),
      ),
    );
  }
}
