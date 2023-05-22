class TaskModel {
  final String taskId;
  late final int status;
  final String name;
  final int type;
  final String description;
  final String finishDate;
  final bool urgent;
  final String syncTime;
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
}
