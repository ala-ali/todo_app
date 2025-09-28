import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite_dev.dart';
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
  int currentIndex= 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[900],
        title: Text(titles[currentIndex],
            style: TextStyle(color: Colors.white,),
      )),
      floatingActionButton: FloatingActionButton(
          onPressed:() {},
        backgroundColor: Colors.teal[900],
          child: Icon(
              Icons.add,
            color: Colors.white,
          ),
      ),
      body: screens [currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.teal[900],
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          currentIndex: currentIndex,
          onTap: (numberOfIndex){
            setState(() {
              currentIndex= numberOfIndex;
            });

          },
          items:[
           BottomNavigationBarItem(
               icon:  Icon(Icons.menu),
           label: 'New Tasks'),
           BottomNavigationBarItem(
               icon:  Icon(Icons.done_outline),
           label: 'Done Tasks'),
           BottomNavigationBarItem(
               icon:  Icon(Icons.archive_outlined),
           label: 'Archived Tasks'),
          ]
      ),
    );
  }
  Database ? database;
  void createDatabase () async{
  //  databaseFactory = sqfliteDatabaseFactoryDefault;
    print ('[DB] createDB called');
 database = await openDatabase(
    'todoApp.db',
version: 1,
  onCreate: (database , version){
      print('database created');
      database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT , date TEXT , time  TEXT, status TEXT)').then((value){
        print('table created')  ;
      }).catchError((error){
        print('error when creating table ${error.toString()} ');
      });
  },
  onOpen: (database){
      print('database opened');
  }
);

  }
}


