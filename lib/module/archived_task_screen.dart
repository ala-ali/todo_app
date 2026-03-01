import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/components.dart';
import '../shared/todo_cubit/todo_cubit.dart';
import '../shared/todo_cubit/todo_states.dart';

class ArchivedTaskScreen extends StatelessWidget {
  const ArchivedTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List tasks = TodoCubit.get(context).archivedTask;
        return ListView.separated(
          itemBuilder: (context, index) => taskItem(tasks[index], context),
          separatorBuilder: (context, index) => Separator(),
          itemCount: tasks.length,
        );
      },
    );

  }
}
