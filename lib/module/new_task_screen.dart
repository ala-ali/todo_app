import 'package:flutter/material.dart';

class NewTaskScreen extends StatelessWidget {
  final List<Map> tasks;
  NewTaskScreen({required this.tasks});

  @override
  Widget build(BuildContext context) {
    print('[new-tasks]: ${tasks.length}');

    if (tasks.isEmpty) {
      return Center(
        child: Text(
          'No tasks yet. Add one to get started!',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      itemBuilder: (context, index) => taskItem(tasks[index]),
      separatorBuilder: (context, index) => Separator(),
      itemCount: tasks.length,
    );
  }
}

Widget taskItem(Map task) => Padding(
  padding: const EdgeInsets.all(20),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      CircleAvatar(
        radius: 43,
        backgroundColor: Colors.teal[700],
        child: Text(
          task['time'],
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(width: 20),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            task['title'],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            task['date'],
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ],
  ),
);
Widget Separator() => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Container(width: double.infinity, height: 1, color: Colors.black54),
);
