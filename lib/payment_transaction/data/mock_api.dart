import 'dart:convert';

import 'package:fintech_app/payment_transaction/presentation/model/transaction_model.dart';

class MockApi {
  Future<List<Transaction>> mockApiService() async {
     print("Fetching mock data...");
    final mockData = '''
[
{
 
        "id": "1",
        "data_type": "Credit",
        "amount": 1200.5,
        "status": "Payment Failed",
        "date": "2025-07-10"
      
},
{
      "id": "2",
      "data_type": "Debit",
      "amount": 1325.7,
      "status": "Payment Pending",
      "date": "2025-07-12"
},

{
"id": "3",
"data_type": "Credit",
"amount": 2400.4,
"status": "Payment Success",
"date": "2025-07-13"
},
{
"id": "4",
"data_type": "Debit",
"amount": 1400.4,
"status": "Payment Failed",
"date": "2025-07-14"
},
{
"id": "5",
"data_type": "Debit",
"amount": 2400.4,
"status": "Payment Success",
"date": "2025-07-15"
},
{
"id": "5",
"data_type": "Credit",
"amount": 1800.6,
"status": "Payment Pending",
"date": "2025-07-15"
},
{
"id": "6",
"data_type": "Credit",
"amount": 200.4,
"status": "Payment Success",
"date": "2025-07-16"
},
{
"id": "7",
"data_type": "Debit",
"amount": 5630.4,
"status": "Payment Pending",
"date": "2025-07-16"
}
] ''';

    await Future.delayed(Duration(seconds: 1));

    final decode = jsonDecode(mockData) as List;
     print("Decoded mock data: ${decode.length} items");
    return decode.map((json) => Transaction.fromJson(json)).toList();
  }
}
