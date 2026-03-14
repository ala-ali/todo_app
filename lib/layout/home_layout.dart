import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/todo_cubit/todo_cubit.dart';
import '../shared/todo_cubit/todo_states.dart';
import '../module/new_task_screen.dart';
import '../module/done_task_screen.dart';
import '../module/archived_task_screen.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout() {}

  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isBottomSheetShown = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  TimeOfDay parseTimeFromText(String timeText) {
    final parts = timeText.split(':');
    final _hour = int.parse(parts[0]);
    final _minute = int.parse(parts[1]);
    print('====>>>>>>>$_hour , $_minute');
    return TimeOfDay(hour: _hour, minute: _minute);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TodoCubit()..createDatabase(),
      child: BlocConsumer<TodoCubit, TodoStates>(
        builder: (context, state) {
          TodoCubit cubit = TodoCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            backgroundColor: Colors.teal[50],
            appBar: AppBar(
              backgroundColor: Colors.teal[900],
              title: Text(
                " ${cubit.titles[cubit.currentIndex]} ",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            floatingActionButton: cubit.currentIndex == 0
                ? FloatingActionButton(
                    onPressed: () {
                      if (isBottomSheetShown) {
                        if (formKey.currentState!.validate()) {
                          final taskDate = DateTime.parse(dateController.text);
                          final taskTime = parseTimeFromText(
                            timeController.text,
                          );
                          print(
                            '====>>>>>>>${taskDate.year}, ${DateTime.now().year} , ${taskDate.month} , ${DateTime.now().month} , ${taskDate.day} , ${DateTime.now().day} ',
                          );
                          if ((taskDate.year == DateTime.now().year) &&
                              (taskDate.month == DateTime.now().month) &&
                              (taskDate.day == DateTime.now().day) &&
                              ((taskTime.hour < TimeOfDay.now().hour) ||
                                  (taskTime.hour == TimeOfDay.now().hour &&
                                      taskTime.minute <
                                          TimeOfDay.now().minute))) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Can't select past dates."),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                                //  behavior: SnackBarBehavior
                                //     .floating, // we can remove this line so that the snackbar will be at the bottom of the screen instead of floating
                              ),
                            );
                            return;
                          }
                          cubit.insertToDatabase(
                            title: titleController.text,
                            time: timeController.text,
                            date: dateController.text,
                          );
                          titleController.clear();
                          dateController.clear();
                          timeController.clear();

                          Navigator.pop(context);

                          isBottomSheetShown = false;
                          cubit.changeIconToEdit();
                        }
                      } else {
                        scaffoldKey.currentState!
                            .showBottomSheet(
                              (context) => Container(
                                padding: EdgeInsets.only(top: 40),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        controller: titleController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.teal,
                                            ),
                                          ),
                                          focusColor: Colors.teal[900],
                                          labelText: 'Title',
                                          prefixIcon: Icon(Icons.title),
                                          labelStyle: TextStyle(
                                            color: Colors.teal[900],
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Title must NOT be empty';
                                          }
                                          return null;
                                        },
                                      ), //title
                                      SizedBox(height: 20),
                                      TextFormField(
                                        controller: timeController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.teal,
                                            ),
                                          ),
                                          focusColor: Colors.teal[900],
                                          labelText: 'Time',
                                          prefixIcon: Icon(Icons.timer),
                                          labelStyle: TextStyle(
                                            color: Colors.teal[900],
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Time must NOT be empty';
                                          }
                                          return null;
                                        },
                                        onTap: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ).then((value) {
                                            timeController.text =
                                                '${value!.hour.toString().padLeft(2, '0')}:${value!.minute.toString().padLeft(2, '0')}';
                                          });
                                        },
                                      ), //time
                                      SizedBox(height: 20),
                                      TextFormField(
                                        enabled: true,
                                        controller: dateController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.teal,
                                            ),
                                          ),
                                          focusColor: Colors.teal[900],
                                          labelText: 'Date',
                                          prefixIcon: Icon(Icons.date_range),
                                          labelStyle: TextStyle(
                                            color: Colors.teal[900],
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Date must NOT be empty';
                                          }
                                          return null;
                                        },
                                        onTap: () {
                                          final today = DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day,
                                          );
                                          showDatePicker(
                                            context: context,
                                            initialDate: today,
                                            firstDate: today,
                                            lastDate: DateTime.parse(
                                              '21000-12-31',
                                            ),
                                          ).then((value) {
                                            if (value != null) {
                                              if (value.isBefore(today)) {
                                                return;
                                              }
                                            }
                                            dateController.text = value!
                                                .toString()
                                                .substring(0, 10);
                                          });
                                        },
                                      ), //date
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .closed
                            .then((value) {
                              isBottomSheetShown = false;
                              cubit.changeIconToEdit();
                            });

                        cubit.changeIconToAdd();
                        isBottomSheetShown = true;
                      }
                    },
                    backgroundColor: Colors.teal[900],
                    child: Icon(cubit.fabIcon, color: Colors.white, size: 25),
                  )
                : null,
            body: Builder(
              builder: (context) {
                print(
                  '[HomeLayout] Building body with ${TodoCubit.get(context).tasks.length} tasks',
                );
                return [
                  NewTaskScreen(tasks: cubit.tasks),
                  DoneTaskScreen(),
                  ArchivedTaskScreen(),
                ][cubit.currentIndex];
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.teal[900],
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'New Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.done_outline),
                  label: 'Done Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived Tasks',
                ),
              ],
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}
