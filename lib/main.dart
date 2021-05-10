import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanneur/ui/screens/home_page.dart';

import 'blocs/qr_code_bloc.dart';

void main() {
  runApp(BlocProvider<QrCodeBloc>(create: (context) => QrCodeBloc(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
