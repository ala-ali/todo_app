import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/todo_cubit/todo_cubit.dart';
import 'package:todo_app/shared/todo_cubit/todo_states.dart';

import '../model/components.dart';

class NewTaskScreen extends StatelessWidget {
  final List<Map> tasks;
  NewTaskScreen({required this.tasks});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List newTasks = TodoCubit.get(context).newTask;
        if (newTasks.isEmpty) {
          return Center(
            child: Text(
              'No tasks yet. Add one to get started!',
              style: TextStyle(fontSize: 18, color: Colors.grey[800]),
            ),
          );
        }
        return ListView.separated(
          itemBuilder: (context, index) => taskItem(newTasks[index], context),
          separatorBuilder: (context, index) => Separator(),
          itemCount: newTasks.length,
        );
      },
    );
  }
}
