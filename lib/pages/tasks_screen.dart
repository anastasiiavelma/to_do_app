import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  final dynamic data;

  const TasksScreen({super.key, this.data});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String selectedButton = 'Усі';

  void _selectButton(String buttonName) {
    setState(() {
      selectedButton = buttonName;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 58, 14, 25),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButton('Усі'),
                  _buildButton('Робочі'),
                  _buildButton('Особисті'),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text('Вибрана кнопка: $selectedButton'),
        ],
      ),
    )));
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
