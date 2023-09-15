import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/shared/Cubit/Cubit.dart';
import '/shared/Cubit/States.dart';
import '/shared/component/Components.dart';

class ArchivedTasks extends StatelessWidget {
  const ArchivedTasks ({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,AppStates){},
     builder: (context,AppStates){
        var Tasks = AppCubit.get(context).archiveTasks;
        return ConditionalBuilder(
          condition: Tasks.isNotEmpty,
          builder: (context) => ListView.separated(
            itemBuilder: (context, index) =>
                builedtItem(Tasks[index], context),
            separatorBuilder: (context, index) => Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
            ),
            itemCount: Tasks.length,
          ),
          fallback: (context) => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu_outlined,
                  size: 120,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'No Tasks Yet',
                  style: TextStyle(fontSize: 40,color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
