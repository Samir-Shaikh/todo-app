import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Screen/ToDoListScreen.dart';

import 'Provider/ProviderAppState.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(notifier: ProviderAppState())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ToDo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ToDoListScreen(),
      ),
    );
  }
}
