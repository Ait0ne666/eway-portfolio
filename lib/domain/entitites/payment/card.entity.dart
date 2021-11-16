class CreditCard {
  String mask;
  String month;
  String year;
  String id;
  bool isActive;

  CreditCard(
      {required this.mask,
      required this.month,
      required this.year,
      required this.id,
      required this.isActive});

  CreditCard copyWith({
    String? mask,
    String? month,
    String? year,
    String? id,
    bool? isActive,
  }) {
    return CreditCard(
      id: id ?? this.id,
      mask: mask ?? this.mask,
      year: year ?? this.year,
      month: month ?? this.month,
      isActive: isActive ?? this.isActive,
    );
  }
}
