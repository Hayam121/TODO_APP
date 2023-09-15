import 'package:flutter/material.dart';

class DoneTaskScreen extends StatelessWidget {
  const DoneTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("done Tasks",
      style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
    );
  }
}