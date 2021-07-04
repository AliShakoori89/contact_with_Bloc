import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phonebook_with_bloc/repository/contactPage_repository.dart';
import 'package:phonebook_with_bloc/view/home_page.dart';

import 'bloc/contactPage_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => ContactBloc(ContactRepository()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SQFlite',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: HomePage(),
        ));
  }
}
