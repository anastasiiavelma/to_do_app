import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        backgroundColor: Color(0xFFA9A9A9), // Прозорий фон AppBar
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 58, 14, 25),
              child: Container(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: TaskListScreen()),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
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
              color: Colors.black,
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
