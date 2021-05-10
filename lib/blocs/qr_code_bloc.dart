import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

part 'qr_code_event.dart';
part 'qr_code_state.dart';

class QrCodeBloc extends Bloc<QrCodeEvent, QrCodeState> {
  QrCodeBloc() : super(QrCodeInitial());

  @override
  Stream<QrCodeState> mapEventToState(
    QrCodeEvent event,
  ) async* {
    if (event is QrCodeScanned) {
      yield* _mapQrCodeScannedToState(data: event.data);
    }
  }

  Stream<QrCodeState> _mapQrCodeScannedToState({@required String data}) async* {
    if (data != null) {
      int firstCode;
      int secondCode;
      int thirdCode;

      try {
        firstCode = _getCode(data, 0, 3);
        secondCode = _getCode(data, 17, 19);
        thirdCode = _getCode(data, 25, 27);
      } catch (_) {
        yield QrCodeDummyState();
        yield QrCodeError(message: 'Une erreur est survenue.', data: data);
      }

      if (firstCode == 01 && secondCode == 17 && thirdCode == 10) {
        try {
          String gtin = data.substring(3, 17);
          String expirationDate = data.substring(19, 25);
          String lotNumber = data.substring(27, data.length);

          yield QrCodeDummyState();
          yield QrCodeLoaded(
            response: data,
            gtin: gtin,
            expirationDate: _formatDate(expirationDate),
            lotNumber: lotNumber,
          );
        } catch (_) {
          yield QrCodeDummyState();
          yield QrCodeError(message: 'Une erreur est survenue.', data: data);
        }
      } else if (firstCode == 01 && secondCode == 10 && thirdCode == 17) {
        try {
          String gtin = data.substring(3, 17);
          String expirationDate = data.substring(data.length - 6, data.length);
          String lotNumber = data.substring(19, data.length - 6);

          yield QrCodeDummyState();
          yield QrCodeLoaded(
            response: data,
            gtin: gtin,
            expirationDate: _formatDate(expirationDate),
            lotNumber: lotNumber,
          );
        } catch (_) {
          yield QrCodeDummyState();
          yield QrCodeError(message: 'Une erreur est survenue.', data: data);
        }
      } else {
        yield QrCodeDummyState();
        yield QrCodeError(message: 'Une erreur est survenue.', data: data);
      }
    } else {
      yield QrCodeDummyState();
      yield QrCodeError(message: 'Une erreur est survenue.', data: null);
    }
  }

  int _getCode(String data, int start, int end) {
    return int.parse(data.substring(start, end));
  }

  String _formatDate(String date) {
    String dd = date.substring(4);
    String mm = date.substring(2, 4);
    String yy = date.substring(0, 2);
    return '$dd/$mm/$yy';
  }
}
