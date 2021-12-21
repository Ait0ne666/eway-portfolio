class ChargeProgress {
  final int pointId;
  final double? progress;
  final double paymentAmount;
  final double powerAmount;
  final double chargePower;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? timeLeft;
  final bool? canceled;
  final int? chargeId;

  const ChargeProgress(
      {required this.pointId,
      required this.createdAt,
      required this.paymentAmount,
      required this.powerAmount,
      required this.updatedAt,
      required this.chargePower,
      this.progress,
      this.timeLeft,
      this.canceled,
      this.chargeId
      });

  ChargeProgress copyWith({
    int? pointId,
    double? progress,
    double? paymentAmount,
    double? powerAmount,
    DateTime? createdAt,
    double? timeLeft,
    bool? canceled,
    int? chargeId,
    DateTime? updatedAt,
    double? chargePower,
  }) {
    return ChargeProgress(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      progress: progress ?? this.progress,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      powerAmount: powerAmount ?? this.powerAmount,
      timeLeft: timeLeft ?? this.timeLeft,
      canceled: canceled ?? this.canceled,
      pointId: pointId ?? this.pointId,
      chargeId: chargeId ?? this.chargeId,
      chargePower: chargePower ?? this.chargePower
    );
  }
}

class ChargeResult {
  final Stream<ChargeProgress> stream;
  final ChargeProgress initialValue;

  ChargeResult({required this.initialValue, required this.stream});
}
