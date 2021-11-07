class ChargeProgress {


  final int pointId;
  final double? progress;
  final double paymentAmount;
  final double powerAmount;
  final DateTime createdAt;
  


  const ChargeProgress({required this.pointId, required this.createdAt,  required this.paymentAmount, required this.powerAmount, this.progress});

}


class ChargeResult {
  final Stream<ChargeProgress> stream;
  final ChargeProgress initialValue;


  ChargeResult({required this.initialValue, required this.stream});
}