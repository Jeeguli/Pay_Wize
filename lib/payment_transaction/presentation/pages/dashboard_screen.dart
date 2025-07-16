import 'package:fintech_app/payment_transaction/data/transaction_provider.dart';
import 'package:fintech_app/payment_transaction/domain/transaction_card.dart';
import 'package:fintech_app/payment_transaction/presentation/widgets/transaction_details.dart';
import 'package:google_fonts/google_fonts.dart';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<TransactionProvider>(context, listen: false).loadTransaction();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    return Scaffold(
      
      backgroundColor: Colors.white,
      
      appBar: AppBar(
        title: Text(
          "Transaction dashboard",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          
        ),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(onPressed:() => _openFilterDialog(context), icon:  Icon(Icons.filter_alt_outlined)),
         
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child:
              provider.transaction.isEmpty
                  ? Center(child: CircularProgressIndicator(color: Colors.blue))
                  : ListView.separated(
                    itemBuilder: (context, index) {
                      final paymentTransaction = provider.transaction[index];
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (e) => TransactionDetails(transaction: paymentTransaction)));
                        },
                        child: TransactionCard(transaction: paymentTransaction),
                      );
                    },
                    separatorBuilder: (_,i) {
                      return SizedBox(height: 15);
                    },
                    itemCount: provider.transaction.length,
                  ),
        ),
      ),
    );
  }

Future<void> _openFilterDialog(context) async {
  final provider = Provider.of<TransactionProvider>(context, listen: false);

  String? selectedStatus;
  if (provider.transaction.isNotEmpty) {
    selectedStatus = provider.transaction.first.status;
  }

  DateTimeRange? selectedDateRange = provider.dateTimeRange;

  await showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text("Filters"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              hint: Text("Select status"),
              value: selectedStatus,
              onChanged: (value) {
                selectedStatus = value;
              },
              items: ['Payment Success', 'Payment Pending', 'Payment Failed']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
            ),
            ElevatedButton(
              child: Text("Select Date Range"),
              onPressed: () async {
                DateTimeRange? picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) selectedDateRange = picked;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Apply"),
            onPressed: () {
              provider.setStatusFilter(selectedStatus);
              provider.setDateRange(selectedDateRange);
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}
}