class HistoryItemModel {

  final double amount;
  final String address;
  final DateTime date;
  final int id;
  final int pointId;
  final String? receiptUrl;
  final String? refundReceiptUrl;

  HistoryItemModel({required this.amount, required this.address, required this.date, required this.pointId, required this.id , this.receiptUrl, this.refundReceiptUrl });


}