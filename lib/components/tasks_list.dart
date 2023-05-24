import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_app/api/task_model.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/pages/task_detail_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshTasks,
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];

          return GestureDetector(
            onTap: () {
              openTaskEditScreen(task);
            },
            child: Dismissible(
              key: Key(task.taskId),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              onDismissed: (direction) {
                deleteTask(task.taskId);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: task.urgent == 0
                        ? const Color(0xFFDBDBDB)
                        : const Color(0xFFFF8989),
                    borderRadius: BorderRadius.circular(15),
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
                                DateFormat('dd.MM.yyyy').format(
                                    DateTime.parse(task.finishDate.toString())),
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
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          setState(() {
                            if (task.status == 2) {
                              task.status = 1;
                            } else {
                              task.status = 2;
                            }
                          });
                          updateTaskStatus(task.taskId, task.status);
                        },
                        child: Container(
                          width: 33,
                          height: 33,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: const Color(0xFF383838)),
                            borderRadius: BorderRadius.circular(10),
                            color: task.status == 1
                                ? const Color(0xFFFBEFB4)
                                : Colors.transparent,
                          ),
                          child: task.status == 1
                              ? const Icon(Icons.check,
                                  color: Color(0xFF383838), size: 30)
                              : null,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void openTaskEditScreen(TaskModel task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TaskDetailScreen(),
      ),
    ).then((updatedTask) {
      if (updatedTask != null) {
        updateTaskStatus(updatedTask.taskId, updatedTask.status);
      }
    });
  }

  Future<void> refreshTasks() async {
    await fetchTasks();
  }

  Future<void> updateTaskStatus(String taskId, int newStatus) async {
    final requestBody = {'status': newStatus};

    try {
      final response = await http.put(
        Uri.parse('https://to-do.softwars.com.ua//tasks/$taskId'),
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
            finishDate: DateTime.parse(taskData['finishDate']),
            urgent: taskData['urgent'],
            syncTime: DateTime.parse(taskData['syncTime']),
            file: taskData['file'],
          );
        }).toList();
      });
    } else {
      print('Помилка при отриманні завдань: ${response.statusCode}');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      final response = await http.delete(
        Uri.parse('https://to-do.softwars.com.ua/tasks/$taskId'),
      );

      if (response.statusCode == 200) {
        print('Task deleted');
        await fetchTasks();
      } else {
        print('Failed to delete task: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while deleting task: $e');
    }
  }
}
