import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import '../shared/todo_cubit/todo_cubit.dart';
import '../shared/todo_cubit/todo_states.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout(){
    databaseFactory = databaseFactoryFfi ;
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isBottomSheetShown = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
        create: (BuildContext context)=> TodoCubit()..createDatabase(),
        child: BlocConsumer<TodoCubit , TodoStates>(
            builder: (context , state){
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
                floatingActionButton: cubit.currentIndex == 0 ? FloatingActionButton(
                  onPressed: () {
                    if (isBottomSheetShown) {
                      if (
                      formKey.currentState!.validate()){

                        Navigator.pop(
                            context);

                        isBottomSheetShown = false;
                        cubit.changeIconToEdit();

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
                                      lastDate:DateTime.parse('2031-12-31'),
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

                        cubit.changeIconToEdit();

                      });

                      cubit.changeIconToAdd();
                      isBottomSheetShown = true;
                    }
                  },
                  backgroundColor: Colors.teal[900],
                  child: Icon(
                    cubit.fabIcon,
                    color: Colors.white,
                    size: 25,
                  ),
                ): null,
                body:cubit.screens[cubit.currentIndex],
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
            },
            listener: (context , state){},
        ) ,
    );
  }

}






