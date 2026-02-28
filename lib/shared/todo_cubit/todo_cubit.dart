import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/todo_cubit/todo_states.dart';
import '../../module/archived_task_screen.dart';
import '../../module/done_task_screen.dart';
import '../../module/new_task_screen.dart';

class TodoCubit extends Cubit<TodoStates> {
  TodoCubit() : super(TodoInitialState());
  static TodoCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [
    NewTaskScreen(tasks: []),
    DoneTaskScreen(),
    ArchivedTaskScreen(),
  ];
  List<String> titles = ['New Tasks', 'Done Tasks ', 'Archived Tasks'];

  void changeIndex(index) {
    currentIndex = index;
    emit(TodoChangeIndexOfNavBar());
  }

  IconData fabIcon = Icons.mode_edit_outline_outlined;
  void changeIconToEdit() {
    fabIcon = Icons.mode_edit_outline_outlined;
    emit(TodoChangeIconToEditState());
  }

  void changeIconToAdd() {
    fabIcon = Icons.add;
    emit(TodoChangeIconToAddState());
  }

  //db
  late Database database;

  List<Map> tasks = [];

  Future<void> createDatabase() async {
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
      onOpen: (database) {},
    );
    print('database initialized, now loading tasks...');
    await getTasks();
    print('tasks loaded: ${tasks.length} tasks');
  }

  Future<void> getTasks() async {
    try {
      print('Fetching tasks from database...');
      final tasksData = await getDataFromDB(database);
      print('Tasks fetched: ${tasksData.length} tasks');
      tasks = tasksData;
      emit(TodoLoadTasksState());
      print('Tasks state emitted');
    } catch (e) {
      print('Error getting tasks: $e');
    }
  }

  Future insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    try {
      print('Inserting task: title=$title, time=$time, date=$date');
      await database.transaction((txn) async {
        await txn.rawInsert(
          'INSERT INTO tasks (title , date , time , status) VALUES (?, ?, ?, ?)',
          [title, date, time, 'new'],
        );
      });
      print('Task inserted successfully');
      await getTasks();
    } catch (error) {
      emit(TodoInsertErrorState(error));
      print('Error when inserting new record ${error.toString()}');
    }
  }

  List<Map> newTask = [];
  List<Map> doneTask = [];
  List<Map> archivedTask = [];

  Future<List<Map>> getDataFromDB(database) async {
    newTask = [];
    final value = await database.rawQuery('SELECT * FROM tasks');
    value.forEach((element) {
      print(element);
      if (element['status'] == 'new') {
        newTask.add(element);
      }
    });
    return newTask;
  }

  void updateDB({required String status, required int id}) {
    database
        .rawUpdate('UPDATE tasks SET status ? WHERE id = ?', ['${status}', id])
        .then((value) {
          getDataFromDB(database);
          emit(TodoLoadTasksState());
        });
  }
}
