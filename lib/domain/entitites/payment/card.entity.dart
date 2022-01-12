enum PaymentTypes {
  CARD,
  GOOGLE_PAY,
  APPLE_PAY
}


class CreditCard {
  String mask;
  String month;
  String year;
  String id;
  bool isActive;
  PaymentTypes type;

  CreditCard(
      {required this.mask,
      required this.month,
      required this.year,
      required this.id,
      required this.isActive, required this.type});

  CreditCard copyWith({
    String? mask,
    String? month,
    String? year,
    String? id,
    bool? isActive,
    PaymentTypes? type,
  }) {
    return CreditCard(
      id: id ?? this.id,
      mask: mask ?? this.mask,
      year: year ?? this.year,
      month: month ?? this.month,
      isActive: isActive ?? this.isActive,
      type: type ?? this.type
    );
  }
}
