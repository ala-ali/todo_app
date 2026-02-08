import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/todo_cubit/todo_states.dart';
import '../../module/archived_task_screen.dart';
import '../../module/done_task_screen.dart';
import '../../module/new_task_screen.dart';

class TodoCubit extends Cubit<TodoStates>{
  TodoCubit() : super(TodoInitialState());
  static TodoCubit get(context)=> BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [
    NewTaskScreen(tasks: [],),
    DoneTaskScreen(),
    ArchivedTaskScreen(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks ',
    'Archived Tasks',
  ];

  void changeIndex(index){
    currentIndex = index;
    emit(TodoChangeIndexOfNavBar());
  }

  IconData fabIcon = Icons.mode_edit_outline_outlined;
  void changeIconToEdit(){
    fabIcon = Icons.mode_edit_outline_outlined;
    emit(TodoChangeIconToEditState());
  }

  void changeIconToAdd(){
    fabIcon = Icons.add;
    emit(TodoChangeIconToAddState());
  }





  //db
  late Database database;

  List<Map>tasks = [];

  void createDatabase() async {
    database = await openDatabase(
      'todoApp.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT , date TEXT , time  TEXT, status TEXT)',
        )
            .then((value) {
          print('table created');
        })
            .catchError((error) {
          print('error when creating table ${error.toString()} ');
        });
      },
      onOpen: (database) {
        getDataFromDB(database).then((value){
            tasks = value; // Update the list

          //tasks=value;
        });
        print('database opened');
      },
    );
  }

  Future insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async
  {
    await database.transaction((txn) async
    {
      txn
          .rawInsert(
        'INSERT INTO tasks (title , date , time , status) VALUES ("${title}" , "${date}" , "${time}" , "new")',
      )
          .then((value) {
        print('$value inserted successfully');
        title = '';
        time = '';
        date = '';
      })
          .catchError((error) {
        print('Error when inserting new record ${error.toString()}');
      });
    });
  }

  Future<List<Map>> getDataFromDB(database) async{
    return await database.rawQuery('SELECT * FROM tasks ');

  }
}

