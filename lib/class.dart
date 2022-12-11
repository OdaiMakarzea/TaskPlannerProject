class TaskModel {
  int? taskId;
  String? taskTitle;
  String? taskDate;
  int? taskCheck;

  TaskModel(
      {this.taskId,
        this.taskTitle,
        this.taskDate,
        this.taskCheck});

  TaskModel.fromJson(Map<String, dynamic> json) {
    taskId = json['task_id'];
    taskTitle = json['task_title'];
    taskDate = json['task_date'];
    taskCheck = json['task_check'];
  }

}

class SubTaskModel {
  int? subTaskId;
  String? subTaskTitle;
  int? subTaskCheck;
  int? subTaskTaskId;

  SubTaskModel(
      {this.subTaskId,
        this.subTaskTitle,
        this.subTaskCheck,
        this.subTaskTaskId});

  SubTaskModel.fromJson(Map<String, dynamic> json) {
    subTaskId = json['sub_task_id'];
    subTaskTitle = json['sub_task_title'];
    subTaskCheck = json['sub_task_check'];
    subTaskTaskId = json['sub_task_taskid'];
  }
}

