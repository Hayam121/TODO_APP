import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import '../../modules/ArchivedTasks.dart';
import '../../modules/DoneTasks.dart';
import '../../modules/NewTasks.dart';
import 'States.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  var currentindex = 0;

  List<Widget> Screen = [
    const NewTasks(),
    const DoneTasks(),
    const ArchivedTasks(),
  ];

  List<String> Title = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void ChangeIndex(int index) {
    currentindex = index;
    emit(AppChangeBottomNavBarState());
  }
  // change in the icon and the ............
  bool isBottomSheetShow = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShowe,
    required IconData icon, required bool IsShow,
  }) {
    isBottomSheetShow = isShowe;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  //s--------------Database---------------//

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  // initializ the database
  late Database database;
  // create the database
  void createDataBase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('databae created new !!');
        // title ,time ,date , status
        database
            .execute(
                'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT,description TEXT, time TEXT, date TEXT, status TEXT,image VARCHAR)')
            .then((value) {
          print('Table created ');
        }).catchError((error) {
          print('Error when create table :> ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataBase(database);
        print('open database new ??');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  // insert in to the database
  void insertDataBase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO Tasks(title, time ,date, status) VALUES("$title","$time","$date","new")')
          .then((value) {
        print('Insert saccessfully $value');
        emit(AppInsertDatabaseState());
        // get the database

        getDataBase(database);
      }).catchError((error) {
        print('Error when create insert new Record :> ${error.toString()}');
      });
    });
  }

  void getDataBase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    // ------------------list of elements-----------------//
    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM Tasks').then((value) {
      print(' Data :=> $value');
      value.forEach(
        (element) {
          if (element['status'] == 'new') {
            newTasks.add(element);
          } else if (element['status'] == 'done') {
            doneTasks.add(element);
          } else {
            archiveTasks.add(element);
          }
        },
      );
      emit(AppGetDatabaseState());
    });
  }

  // updatethe function
  void updateDatabase({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
      'UPDATE Tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value) {
      getDataBase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  // to delete fromw database by the id

  void deleteDatabase({required int id}) {
    database.rawDelete(
      'DELETE FROM Tasks WHERE id= ?',
      [id],
    ).then((value) {
      getDataBase(database);
      emit(AppDeleteDatabaseState());
    });
  }
}
