import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_app/api/task_model.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<TaskModel> tasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final response =
        await http.get(Uri.parse('https://to-do.softwars.com.ua/tasks'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final taskList = jsonData['data'] as List<dynamic>;

      setState(() {
        tasks = taskList.map((taskData) {
          return TaskModel(
            taskId: taskData['taskId'].toString(),
            status: taskData['status'],
            name: taskData['name'],
            type: taskData['type'],
            description: taskData['description'],
            finishDate: taskData['finishDate'],
            urgent: taskData['urgent'] == 1,
            syncTime: taskData['syncTime'],
            file: taskData['file'],
          );
        }).toList();
      });
    } else {
      print('Помилка при отриманні завдань: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.add, // Specify the desired icon from the Icons class
                color: Colors.blue, // Optionally, set the color of the icon
                size: 24, // Optionally, set the size of the icon
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        task.description,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Divider(
                        color: Colors.black12,
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                task.finishDate,
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
