class Transaction {
  final String id;
  final String type;
  final double amount;
  final String status;
  final DateTime date;
  final Map<String, dynamic> fullData;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.status,
    required this.date,
    required this.fullData,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      type: json['data_type'],
      amount: (json['amount']).toDouble(),
      status: json['status'],
      date: DateTime.parse(json['date']),
      fullData: json,
    );
  }
}





