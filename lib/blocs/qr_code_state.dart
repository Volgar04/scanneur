part of 'qr_code_bloc.dart';

abstract class QrCodeState extends Equatable {
  const QrCodeState();

  @override
  List<Object> get props => [];
}

class QrCodeInitial extends QrCodeState {}

class QrCodeLoaded extends QrCodeState {
  final String response;
  final String gtin;
  final String expirationDate;
  final String lotNumber;

  const QrCodeLoaded({
    @required this.response,
    @required this.gtin,
    @required this.expirationDate,
    @required this.lotNumber,
  });

  @override
  List<Object> get props => [
        response,
        gtin,
        expirationDate,
        lotNumber,
      ];
}

class QrCodeDummyState extends QrCodeState {}

class QrCodeError extends QrCodeState {
  final String message;
  final String data;

  const QrCodeError({
    @required this.message,
    @required this.data,
  });

  @override
  List<Object> get props => [message, data];
}
