part of 'qr_code_bloc.dart';

abstract class QrCodeEvent extends Equatable {
  const QrCodeEvent();
}

class QrCodeScanned extends QrCodeEvent {
  final String data;

  const QrCodeScanned({@required this.data});

  @override
  List<Object> get props => [data];
}
