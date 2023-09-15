import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'layouts/home_layout.dart';
import 'shared/Bloc_Observe.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}