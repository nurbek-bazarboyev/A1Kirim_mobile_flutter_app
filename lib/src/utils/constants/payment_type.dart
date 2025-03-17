import 'package:a1_kirim_mobile/src/core/entities/payment_type.dart';

class PaymentTypeData{
  static List<PaymentType> types = [
    PaymentType(name: "Naqt",shortName: "naqt"),
    PaymentType(name: "Plastik",shortName: 'plastik'),
    PaymentType(name: "Bank hisobi",shortName: 'per'),
  ];
}