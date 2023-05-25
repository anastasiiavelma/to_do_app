import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_app/api/task_model.dart';
import 'package:uuid/uuid.dart';

class TaskDetailScreen extends StatefulWidget {
  final TaskModel? task;
  final bool isEdit;
  const TaskDetailScreen({
    Key? key,
    this.task,
    this.isEdit = false,
  }) : super(key: key);

  @override
  TaskDetailScreenState createState() => TaskDetailScreenState();
}

class TaskDetailScreenState extends State<TaskDetailScreen> {
  List<TaskModel> tasks = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  int? _type;
  int? isUrgent;
  DateTime? _selectedDate;
  bool isEdit = false;

  String generateUniqueId() {
    const uuid = Uuid();
    return uuid.v4();
  }

  @override
  void initState() {
    if (widget.task != null) {
      TaskModel task = widget.task!;
      _nameController.text = task.name;
      _descriptionController.text = task.description;
      _dateController.text = DateFormat('yyyy-MM-dd').format(task.finishDate);
      _type = task.type == 1 ? 1 : 2;
      isUrgent = task.urgent == 0 ? 0 : 1;
      isEdit = widget.isEdit;
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFFA9A9A9),
    ));

    final nameOfTaskField = TextField(
      controller: _nameController,
      decoration: const InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintText: 'Назва завдання...',
        labelText: 'Назва завдання...',
        labelStyle: TextStyle(
          fontFamily: 'SanFrancisco',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xFF383838),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
    );
    final descriptionOfTaskField = TextField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(30, 17, 0, 0),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintText: 'Додати опис...',
        labelText: 'Додати опис...',
        labelStyle: TextStyle(
          fontFamily: 'SanFrancisco',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF383838),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
    );
    final datePickerField = TextField(
      controller: _dateController,
      readOnly: true,
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: 216,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime.now(),
                minimumYear: 2000,
                maximumYear: 2100,
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    _selectedDate = newDate;
                    _dateController.text =
                        DateFormat('yyyy-MM-dd').format(_selectedDate!);
                  });
                },
              ),
            );
          },
        );
      },
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(30, 5, 0, 0),
        border: InputBorder.none,
        labelText: 'Дата завершення:',
        labelStyle: TextStyle(
          fontFamily: 'SanFrancisco',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF383838),
        ),
      ),
    );
    final createTaskButton = ElevatedButton(
      onPressed: () {
        isEdit ? updateTaskData() : createTask();
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(169, 50),
        backgroundColor: const Color(0xFFFFD600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        isEdit ? 'Оновити' : 'Створити',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.w500,
          fontFamily: 'SanFrancisco',
        ),
      ),
    );

    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFA9A9A9),
          Color(0xFF383838),
        ],
      )),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(1, 40, 1, 16),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back,
                          color: Color(0xFFFFD600), size: 24),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: nameOfTaskField,
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Container(
                  height: 50,
                  padding: const EdgeInsets.only(left: 34),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFBEFB4),
                  ),
                  child: Row(
                    children: [
                      Radio<int>(
                        value: 1,
                        groupValue: _type,
                        activeColor: const Color(0xFFFFD600),
                        onChanged: (value) {
                          setState(() {
                            _type = value!;
                          });
                        },
                      ),
                      const Text(
                        'Робочі',
                        style: TextStyle(
                          fontFamily: 'SanFrancisco',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF383838),
                        ),
                      ),
                      const SizedBox(width: 65.0),
                      Radio<int>(
                        value: 2,
                        groupValue: _type,
                        activeColor: const Color(0xFFFFD600),
                        onChanged: (value) {
                          setState(() {
                            _type = value!;
                          });
                        },
                      ),
                      const Text(
                        'Особисті',
                        style: TextStyle(
                          fontFamily: 'SanFrancisco',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF383838),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  height: 98,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFBEFB4),
                  ),
                  child: descriptionOfTaskField,
                ),
                const SizedBox(height: 16.0),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFFBEFB4),
                  ),
                  child: datePickerField,
                ),
                const SizedBox(height: 16.0),
                Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(30, 13, 0, 0),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFBEFB4),
                  ),
                  child: const Text(
                    'Прикріпити файл',
                    style: TextStyle(
                        fontFamily: 'SanFrancisco',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF383838)),
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(13, 13, 0, 15),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFBEFB4),
                    ),
                    child: Row(
                      children: [
                        Radio(
                          value: 1,
                          groupValue: isUrgent,
                          activeColor: const Color(0xFFFFD600),
                          onChanged: (value) {
                            setState(() {
                              isUrgent = value!;
                            });
                          },
                        ),
                        const Text(
                          'Термінове',
                          style: TextStyle(
                            fontFamily: 'SanFrancisco',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF383838),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(height: 16.0),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: createTaskButton,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  Future<void> updateTaskData() async {
    try {
      final task = widget.task;
      final taskId = task?.taskId;
      final name = _nameController.text;
      final desc = _descriptionController.text;
      final finishDate = DateTime.parse(_dateController.text);
      final status = task!.status;
      final type = task.type;
      final urgent = task.urgent;

      final body = {
        "status": status,
        "name": name,
        "type": type.toString(),
        "description": desc,
        "finishDate": finishDate.toIso8601String(),
        "urgent": urgent,
        "syncTime": DateTime.now().toIso8601String(),
      };
      final url = 'https://to-do.softwars.com.ua/tasks/$taskId';
      final uri = Uri.parse(url);
      final response = await http.put(
        uri,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );
      debugPrint('${response.statusCode}');
      debugPrint(response.body);
      if (response.statusCode == 200) {
        debugPrint('Updating is success');
      } else {
        debugPrint('Update is failed');
      }
    } catch (e) {
      debugPrint("Something went wrong");
    }
  }

  Future<void> createTask() async {
    try {
      final name = _nameController.text;
      final desc = _descriptionController.text;
      final finishDate = DateTime.parse(_dateController.text);
      const status = 1;
      final type = _type;

      final body = [
        {
          "taskId": generateUniqueId().toString(),
          "status": status,
          "name": name,
          "type": type.toString(),
          "description": desc,
          "finishDate": finishDate.toIso8601String(),
          "urgent": isUrgent,
          "syncTime": DateTime.now().toIso8601String(),
        }
      ];

      const url = 'https://to-do.softwars.com.ua/tasks';
      final uri = Uri.parse(url);
      final response = await http.post(uri,
          body: jsonEncode(body),
          headers: {'Content-Type': 'application/json'});

      debugPrint('${response.statusCode}');
      debugPrint(response.body);
    } catch (e) {
      debugPrint("Smt was wrong");
    }
  }
}
