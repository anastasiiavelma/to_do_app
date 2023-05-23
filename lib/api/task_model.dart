class TaskModel {
  final String taskId;
  final int status;
  final String name;
  final int? type;
  final String description;
  final DateTime finishDate;
  final bool urgent;
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

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'status': status,
      'name': name,
      'type': type,
      'description': description,
      'finishDate': finishDate.toIso8601String(),
      'urgent': urgent,
      'syncTime': syncTime.toIso8601String(),
      'file': file,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      taskId: json['taskId'],
      status: json['status'],
      name: json['name'],
      type: json['type'],
      description: json['description'],
      finishDate: DateTime.parse(json['finishDate']),
      urgent: json['urgent'],
      syncTime: DateTime.parse(json['syncTime']),
      file: json['file'],
    );
  }
}
