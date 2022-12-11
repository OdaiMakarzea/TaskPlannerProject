import 'package:flutter/material.dart';
import 'package:odaiproject/class.dart';
import 'package:odaiproject/show_task_details.dart';

class TasksListPage extends StatelessWidget {
  final List<TaskModel> tasks;
  const TasksListPage({Key? key, required this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks Page"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (builder) => TaskDetails(task: tasks[index],))),
          title: Text(tasks[index].taskTitle!),
        );
      },

      ),
    );
  }
}
