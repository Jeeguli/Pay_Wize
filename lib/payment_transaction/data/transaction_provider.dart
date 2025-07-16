import 'package:fintech_app/payment_transaction/data/mock_api.dart';
import 'package:fintech_app/payment_transaction/presentation/model/transaction_model.dart';
import 'package:flutter/material.dart';




class TransactionProvider extends ChangeNotifier {
final MockApi _api = MockApi();

List<Transaction> _transctionList = [];
List<Transaction> _filteredTransaction = [];
List<Transaction> get transaction => _filteredTransaction;
String? _status;
DateTimeRange? dateTimeRange;

Future<void> loadTransaction() async {
  print("Loading transactions from mock API...");
  final data = await MockApi().mockApiService();
  _transctionList = data;
  _filteredTransaction = data;
  notifyListeners();
  print("Loaded ${_transctionList.length} transactions");
}

void applyFilters (){
  _filteredTransaction = _transctionList.where((element) {
    bool matchStatus =  _status == null || element.status == _status;
    bool matchesDate = dateTimeRange == null || (element.date.isAfter(dateTimeRange!.start.subtract(Duration(days: 1))) && element.date.isBefore(dateTimeRange!.end.add(Duration(days: 1))));
    return matchesDate && matchStatus;
  }).toList();

  notifyListeners();
}

void setStatusFilter(String? status){
  _status = status;
  applyFilters();
}

void setDateRange(DateTimeRange? range){
  dateTimeRange = range;
  applyFilters();
}
}