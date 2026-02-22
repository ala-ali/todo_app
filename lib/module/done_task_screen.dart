
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/components.dart';
import '../shared/todo_cubit/todo_cubit.dart';
import '../shared/todo_cubit/todo_states.dart';

class DoneTaskScreen extends StatelessWidget{
  const DoneTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('[new-tasks]: ${tasks.length}');
    if (tasks.isEmpty) {
      return Center(
        child: Text(
          'No tasks yet. Add one to get started!',
          style: TextStyle(fontSize: 18, color: Colors.grey[900]),
        ),
      );
    }
    return BlocConsumer<TodoCubit , TodoStates>(
      listener: (context , state){},
      builder: (context , state){
        List tasks = TodoCubit.get(context).doneTask;
        return ListView.separated(
          itemBuilder: (context, index) => taskItem(tasks[index] , context),
          separatorBuilder: (context, index) => Separator(),
          itemCount: tasks.length,
        );
      },
    );
  }
}