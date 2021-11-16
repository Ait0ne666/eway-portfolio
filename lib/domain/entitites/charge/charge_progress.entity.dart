class ChargeProgress {
  final int pointId;
  final double? progress;
  final double paymentAmount;
  final double powerAmount;
  final DateTime createdAt;
  final double? timeLeft;
  final bool? canceled;

  const ChargeProgress(
      {required this.pointId,
      required this.createdAt,
      required this.paymentAmount,
      required this.powerAmount,
      this.progress,
      this.timeLeft,
      this.canceled});

  ChargeProgress copyWith({
    int? pointId,
    double? progress,
    double? paymentAmount,
    double? powerAmount,
    DateTime? createdAt,
    double? timeLeft,
    bool? canceled,
  }) {
    return ChargeProgress(
      createdAt: createdAt ?? this.createdAt,
      progress: progress ?? this.progress,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      powerAmount: powerAmount ?? this.powerAmount,
      timeLeft: timeLeft ?? this.timeLeft,
      canceled: canceled ?? this.canceled,
      pointId: pointId ?? this.pointId,
    );
  }
}

class ChargeResult {
  final Stream<ChargeProgress> stream;
  final ChargeProgress initialValue;

  ChargeResult({required this.initialValue, required this.stream});
}
