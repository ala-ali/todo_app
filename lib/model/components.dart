import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/todo_cubit/todo_cubit.dart';
Future<bool?> showOkCancelDialog({
  required BuildContext context,
  required String title,
  required String message,
  String okLabel = 'OK',
  String cancelLabel = 'Cancel',
}) async {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Cancel
            child: Text(cancelLabel,
            style: TextStyle(
              color: Colors.teal,
            )),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // OK
            child: Text(okLabel,
                style: TextStyle(
                  color: Colors.red,
                )),
          ),
        ],
      );
    },
  );
}
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
      Spacer(),
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
      IconButton(
          onPressed: () async {
            final confirmed = await showOkCancelDialog(
              context: context,
              title: 'Confirm delete',
              message: 'Are you sure you want to proceed?',
            );
            if (confirmed == true) {
              // User clicked OK - perform action
              print('Action confirmed');
              TodoCubit.get(context).deleteData(task['id']);
            } else {
              // User clicked Cancel or dismissed
              print('Action cancelled');
            }
          },
          icon: Icon(
              Icons.delete_outline_outlined,
            color: Colors.red,
          )),
    ],
  ),
);
Widget Separator() => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Container(width: double.infinity, height: 1, color: Colors.black54),
);
