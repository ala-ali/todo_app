
import 'package:flutter/material.dart';

class NewTaskScreen extends StatelessWidget{
  final List<Map>  tasks;
  NewTaskScreen({required this.tasks}
      );

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context , index)=> TaskItem(),
        separatorBuilder: (context , index)=> Separator(),
        itemCount: 20,
    );

  }
}

Widget TaskItem ()=> Padding(
  padding: const EdgeInsets.all(20),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      CircleAvatar(
        radius: 42,
        backgroundColor: Colors.teal[800],
        child: Text(
          '06:00 PM',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      SizedBox(
        width: 20,
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Task title',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '22 April, 2025',
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
Widget Separator ()=> Padding(
  padding: const EdgeInsets.symmetric(
      horizontal: 25
  ),
  child: Container(
    width: double.infinity,
    height: 1,
    color: Colors.black54,
  ),
);