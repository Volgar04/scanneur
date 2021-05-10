import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanneur/blocs/qr_code_bloc.dart';
import 'package:scanneur/ui/components/button_scan.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BlocBuilder<QrCodeBloc, QrCodeState>(builder: (context, state) {
            if (state is QrCodeLoaded) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'CIP : ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                        ),
                        Text(state.gtin),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Lot : ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                        ),
                        Text(state.lotNumber),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Exp : ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                        ),
                        Text(state.expirationDate),
                      ],
                    ),
                  ],
                ),
              );
            } else if (state is QrCodeError) {
              return Column(
                children: [
                  Text(state.message),
                  if (state.data != null)
                    Column(
                      children: [
                        SizedBox(height: 20.0),
                        Text('Le résultat du scan est le code suivant :'),
                        Text(state.data),
                      ],
                    ),
                ],
              );
            } else {
              return Text('Merci de scanner un code QR');
            }
          }),
          ButtonScan(),
        ],
      ),
    );
  }
}
