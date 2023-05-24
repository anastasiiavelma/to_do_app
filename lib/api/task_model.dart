class TaskModel {
  final String taskId;
  int status;
  final String name;
  final int? type;
  final String description;
  final DateTime finishDate;
  final int? urgent;
  final DateTime syncTime;
  final String file;

  TaskModel({
    required this.taskId,
    required this.status,
    required this.name,
    required this.type,
    required this.description,
    required this.finishDate,
    required this.urgent,
    required this.syncTime,
    required this.file,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      taskId: json['taskId'],
      status: json['status'],
      name: json['name'],
      type: json['type'],
      description: json['description'],
      file: json['file'],
      finishDate: DateTime.parse(json['finishDate']),
      urgent: json['urgent'],
      syncTime: DateTime.parse(json['syncTime']),
    );
  }
}
