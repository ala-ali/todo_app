import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
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
        return ConditionalBuilder(
          condition: tasks.length > 0,
          builder:(context)=> ListView.separated(
            itemBuilder: (context, index) => taskItem(tasks[index], context),
            separatorBuilder: (context, index) => Separator(),
            itemCount: tasks.length,
          ),
          fallback:(context)=> Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.archive_outlined,
                    color:Colors.grey[600]),
                Text(
                  "No archived tasks yet, archive some!",
                  style: TextStyle(
                    color:Colors.grey[600],),
                ),
              ],
            ),
          ) ,
        );
      },
    );

  }
}
