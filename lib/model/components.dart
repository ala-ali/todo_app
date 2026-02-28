import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/todo_cubit/todo_cubit.dart';

Widget taskItem(Map task , context) =>
    Padding(
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
      IconButton(
          onPressed: (){
            TodoCubit.get(context).updateDB(status: 'done', id: task['id']);
          },
          icon: Icon(
              Icons.check_circle_outline_outlined,
            color: Colors.green,
          )),
      IconButton(
          onPressed: (){
            TodoCubit.get(context).updateDB(status: 'archive', id: task['id']);
          },
          icon: Icon(
              Icons.archive_outlined,
            color: Colors.blueGrey[800],
          )),
    ],
  ),
);
Widget Separator() => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Container(width: double.infinity, height: 1, color: Colors.black54),
);
