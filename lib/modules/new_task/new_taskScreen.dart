import 'package:flutter/material.dart';
import '/shared/Cubit/Cubit.dart';

import '../../const/const.dart';
import '/layouts/home_layout.dart';
import '../../widget/taskItem.dart';


class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({super.key});

  

  @override
  Widget build(BuildContext context) {
        var tasks = AppCubit.get(context).newTasks;
    return ListView.separated(
      itemBuilder: (context,index)=>Taskitem(tasks[index]),
       separatorBuilder: (context,index)=>Container(

        width: double.infinity,
        height: 2,
        color: Colors.grey[300],
       ) ,
       itemCount: tasks.length);
  }
}