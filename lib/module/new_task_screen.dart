
import 'package:flutter/material.dart';

class NewTaskScreen extends StatelessWidget{
  const NewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_rounded),
          Text('New Tasks Screen',
            style: TextStyle(
          fontWeight: FontWeight.bold,
          ),
          ),
        ],
      ),
    );
  }
}