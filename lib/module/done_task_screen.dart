
import 'package:flutter/material.dart';

class DoneTaskScreen extends StatelessWidget{
  const DoneTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.done_all_rounded),
          Text('Done Tasks Screen',
          style: TextStyle(
              fontWeight: FontWeight.bold,
          ),
          ),

        ],
      ),
    );
  }
}