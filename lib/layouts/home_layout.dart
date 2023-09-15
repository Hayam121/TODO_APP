import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '/shared/Cubit/Cubit.dart';
import '/shared/Cubit/States.dart';
import '/shared/component/Components.dart';

class HomeLayout extends StatelessWidget {
  var ScaffoldKey = GlobalKey<ScaffoldState>();
  var FormKey = GlobalKey<FormState>();
  var TitleController = TextEditingController();
  var TimeController = TextEditingController();
  var DateController = TextEditingController();

  HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: ScaffoldKey,
            appBar: AppBar(
              title: Text(cubit.Title[cubit.currentindex],
                  style: const TextStyle(fontSize: 27,color:Colors.white)),
              centerTitle: true,
              backgroundColor:const Color.fromARGB(255, 50, 45, 117),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.Screen[cubit.currentindex],
              fallback: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentindex,
                onTap: (index) {
                  cubit.ChangeIndex(index);
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu_outlined,
                      size: 25,
                    ),
                    label: 'Tasks',
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline,size: 25), label: 'Done',),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined,size: 25), label: 'Archived'),
                ]),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShow) {
                  if (FormKey.currentState!.validate()) {
                    cubit.insertDataBase(
                       title:TitleController.text ,
                        time: TimeController.text,
                         date: DateController.text,
                    );
                  }
                } else {
                  ScaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          padding: const EdgeInsets.all(20),
                          color: Colors.white,
                          child: Form(
                            key: FormKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment:MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'Add Task',
                                  style: TextStyle( 
                                      fontWeight: FontWeight.bold,
                                      fontSize: 35,
                                      color:Color.fromARGB(255, 40, 35, 110),
                                      ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                DefaultFormField(
                                  Controller: TitleController,
                                  Type: TextInputType.text,
                                  Validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Title Must Not Be Empty';
                                    }
                                    return null;
                                  },
                                  Label: 'Task Title',
                                  Prefix: Icons.title_outlined,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: DefaultFormField(
                                        Controller: TimeController,
                                        Type: TextInputType.text,
                                        onTap: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ).then((value) {
                                            TimeController.text =
                                                value!.format(context);
                                          });
                                        },
                                        Validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Time Must Not Be Empty';
                                          }
                                          return null;
                                        },
                                        Label: 'Task Time',
                                        Prefix: Icons.watch_later_outlined,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: DefaultFormField(
                                        Controller: DateController,
                                        Type: TextInputType.datetime,
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2025-09-15'),
                                          ).then((value) {
                                            DateController.text =
                                                DateFormat.yMMMd()
                                                    .format(value!);
                                          });
                                        },
                                        Validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Date Must Not Be Empty';
                                          }
                                          return null;
                                        },
                                        Label: 'Task Date',
                                        Prefix: Icons.calendar_today_outlined,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 15,
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        IsShow: false, icon: Icons.edit,
                         isShowe: false);
                  });
                  cubit.changeBottomSheetState(IsShow: true, icon: Icons.add, isShowe: true);
                }
              },
              backgroundColor: const Color.fromARGB(255, 50, 45, 117),
              child: Icon(cubit.fabIcon,color: Colors.white,),
            ),
          );
        },
      ),
    );
  }
}
