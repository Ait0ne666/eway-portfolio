class ChargeEndedResult  {

  final double amount;
  final double voltage;
  final int time;
  final int? id;


  ChargeEndedResult({this.id, required this.amount, required this.time, required this.voltage});

}