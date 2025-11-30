import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/module/archived_task_screen.dart';
import 'package:todo_app/module/done_task_screen.dart';
import 'package:todo_app/module/new_task_screen.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  List<Widget> screens = [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen(),
  ];
  List<String> titles = [
    'New Tasks Screen',
    'Done Tasks Screen',
    'Archived Tasks Screen',
  ];
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isBottomSheetShown = false;
  int currentIndex = 0;
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        backgroundColor: Colors.teal[900],
        title: Text(
          titles[currentIndex],
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: currentIndex == 0 ? FloatingActionButton(
              onPressed: () {
                if (isBottomSheetShown) {
                  if (
                  formKey.currentState!.validate()
                  ){
                    Navigator.pop(context);
                    isBottomSheetShown = false;
                  }


                } else {
                  scaffoldKey.currentState!.showBottomSheet(
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
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                ),
                                focusColor: Colors.teal[900],
                                labelText: 'Title',
                                prefixIcon: Icon(Icons.title),
                                labelStyle: TextStyle(color: Colors.teal[900]),
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
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                ),
                                focusColor: Colors.teal[900],
                                labelText: 'Time',
                                prefixIcon: Icon(Icons.timer),
                                labelStyle: TextStyle(color: Colors.teal[900]),
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
                                  timeController.text = value!.format(context).toString();
                        
                                });
                              },
                            ), //time
                            SizedBox(height: 20),
                            TextFormField(
                              enabled: true,
                              controller: dateController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                ),
                                focusColor: Colors.teal[900],
                                labelText: 'Date',
                                prefixIcon: Icon(Icons.date_range),
                                labelStyle: TextStyle(color: Colors.teal[900]),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Date must NOT be empty';
                                }
                                return null;
                              },
                              onTap: (){
                                showDatePicker(
                                  context: context,
                                    initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                    lastDate:DateTime.parse('3000-12-31'),
                                ).then((value) {
                                  dateController.text = value!.toString().substring(0,10);
                                });
                                },
                            ), //date
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  );
                  isBottomSheetShown = true;
                }
              },
              backgroundColor: Colors.teal[900],
              child: Icon
                (
                  Icons.add, color: Colors.white
              ),
            ): null,
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.teal[900],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: currentIndex,
        onTap: (numberOfIndex) {
          setState(() {
            currentIndex = numberOfIndex;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'New Tasks'),
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
  }

  Database? database;
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
        print('database opened');
      },
    );
  }

  Future<void> insertToDatabase() async {
    return database!.transaction((txn) async
    {
      txn
          .rawInsert(
            'INSERT INTO tasks (title , date , time , status) VALUES ("first task" , "18/9/2025" , "12:34PM" , "new")',
          )
          .then((value) {
            print('$value inserted successfully');
          })
          .catchError((error) {
            print('Error when inserting new record ${error.toString()}');
          });
    });
  }
}


