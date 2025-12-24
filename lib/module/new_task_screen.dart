
import 'package:flutter/material.dart';

class NewTaskScreen extends StatelessWidget{
  final List<Map>  tasks;
  NewTaskScreen(
      {required this.tasks}
      );
  @override
  Widget build(BuildContext context) {
  return ListView.separated(
      itemBuilder: (context , index)=> taskItem(),
      separatorBuilder: (context , index)=> Separator(),
      itemCount: 5,
  );

  }
}
Widget taskItem()=> Padding(
  padding: const EdgeInsets.all(20),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      CircleAvatar(
        radius: 43,
        backgroundColor: Colors.teal[700],
        child: Text(
          '06:00pm',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
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
            'Task Title',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            '24 December 2025',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      )
    ],
  ),
);
Widget Separator()=> Padding(
  padding: const EdgeInsets.symmetric(
      horizontal: 20
  ),
  child: Container(
    width: double.infinity,
    height: 1,
    color: Colors.black54,
  ),
);