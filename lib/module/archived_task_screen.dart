
import 'package:flutter/material.dart';

class ArchivedTaskScreen extends StatelessWidget{
  const ArchivedTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.archive_outlined),
          Text('Archived Tasks Screen',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}