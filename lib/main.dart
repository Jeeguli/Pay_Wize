import 'package:fintech_app/payment_transaction/data/transaction_provider.dart';
import 'package:fintech_app/payment_transaction/presentation/pages/dashboard_screen.dart';
import 'package:fintech_app/user_account_details/presentation/pages/user_account_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(create: (_) => TransactionProvider(),child: MyApp(),));
    
    
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fintech Transaction Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: UserAccountDetails(),
    );
  }
}