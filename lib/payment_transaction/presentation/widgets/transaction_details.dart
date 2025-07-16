import 'dart:convert';

import 'package:fintech_app/payment_transaction/presentation/model/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionDetails extends StatelessWidget {
  final Transaction transaction;
  const TransactionDetails({super.key, required this.transaction});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transaction Details",style: GoogleFonts.poppins(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.black,),)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            const JsonEncoder.withIndent('  ').convert(transaction.fullData),
            style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w400,color: Color(0xFF595959),),
          ),
        ),
      ),
    );
  }
}