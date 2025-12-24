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
    NewTaskScreen(tasks: [],),
    DoneTaskScreen(),
    ArchivedTaskScreen(),
  ];

  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isBottomSheetShown = false;
  int currentIndex = 0;
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  IconData fabIcon = Icons.mode_edit_outline_outlined;
  @override
  Widget build(BuildContext context) {
    List<String> titles = [
      'New Tasks',
      'Done Tasks ',
      'Archived Tasks',
    ];
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        backgroundColor: Colors.teal[900],
        title: Text(
          titles[currentIndex],
          style: TextStyle(
              color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: currentIndex == 0 ? FloatingActionButton(
              onPressed: () {
                if (isBottomSheetShown) {
                  if (
                   formKey.currentState!.validate()){
                    insertToDatabase(
                      title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                    );
                    Navigator.pop(
                        context);

                    isBottomSheetShown = false;
                    setState(() {
                      fabIcon = Icons.mode_edit_outline_outlined;
                    });

                  }
                } else {
                  scaffoldKey.currentState!.showBottomSheet (
                  (context) => Container(
                      padding: EdgeInsets.only(
                          top: 40),
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
                                    lastDate:DateTime.parse('90000000-12-31'),
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
                  ).closed.then((value){
                    isBottomSheetShown = false;
                    setState(() {
                      fabIcon = Icons.mode_edit_outline_outlined;
                    });
                  });
                  setState(() {
                    fabIcon = Icons.add;
                  });
                  isBottomSheetShown = true;
                }
              },
              backgroundColor: Colors.teal[900],
              child: Icon
                (
                  fabIcon,
                  color: Colors.white,
                size: 25,
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
          BottomNavigationBarItem(
              icon: Icon(Icons.menu), label: 'New Tasks'),
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
          tasks=value;
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


