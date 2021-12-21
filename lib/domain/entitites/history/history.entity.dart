class HistoryItem {
  final int id;
  final int pointId;
  final double amount;
  final String address;
  final DateTime date;
  final String? receiptUrl;
  final String? refundReceiptUrl;


  HistoryItem({required this.amount, required this.address, required this.date, required this.id, required this.pointId, this.receiptUrl, this.refundReceiptUrl});


}