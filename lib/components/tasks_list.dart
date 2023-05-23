import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_app/api/task_model.dart';
import 'package:intl/intl.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

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

  Future<void> updateTaskStatus(String taskId, bool newStatus) async {
    final requestBody = {'status': newStatus ? 2 : 1};

    try {
      final response = await http.put(
        Uri.parse('https://to-do.softwars.com.ua//tasks/taskId'),
        body: json.encode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Task status updated');
      } else {
        print('Failed to update task status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while updating task status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ),
            decoration: BoxDecoration(
              color: task.urgent
                  ? const Color(0xFFDBDBDB)
                  : const Color(0xFFFF8989),
              borderRadius:
                  BorderRadius.circular(15), // Радіус границі контейнера
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                task.type == 1
                    ? const Icon(
                        Icons.home_filled,
                        color: Color(0xFF383838),
                        size: 16,
                      )
                    : const Icon(
                        Icons.work_outline_outlined,
                        color: Color(0xFF383838),
                        size: 16,
                      ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 11.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.description,
                          style: const TextStyle(
                            color: Color(0xFF383838),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          DateFormat('dd.MM.yyyy')
                              .format(DateTime.parse(task.finishDate)),
                          style: const TextStyle(
                            color: Color(0xFF383838),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Checkbox(
                  value: task.status == 2,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      updateTaskStatus(task.taskId, newValue);
                    }
                  },
                  activeColor: Colors.green,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
