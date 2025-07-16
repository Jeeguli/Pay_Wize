import 'dart:convert';

import 'package:fintech_app/user_account_details/presentation/widgets/payment_history.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAccountDetails extends StatefulWidget {
  const UserAccountDetails({super.key});

  @override
  State<UserAccountDetails> createState() => _UserAccountDetailsState();
}

class _UserAccountDetailsState extends State<UserAccountDetails> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newPayout = {
        "name": _nameController.text.trim(),
        "accountNumber": _accountNumberController.text.trim(),
        "ifsc": _ifscController.text.trim().toUpperCase(),
        "amount": _amountController.text.trim(),
      };

      final prefs = await SharedPreferences.getInstance();
      final existingList = prefs.getStringList('payouts') ?? [];

      existingList.add(jsonEncode(newPayout));
      await prefs.setStringList('payouts', existingList);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Payout saved!')));

      _formKey.currentState!.reset();
      _nameController.clear();
      _accountNumberController.clear();
      _ifscController.clear();
      _amountController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User Account details",
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
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (e) => PayoutHistoryScreen()),
              );
            },
            icon: Icon(Icons.history),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Enter Your details",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  // Trim leading and trailing spaces before validation
                  value = value?.trim();
                  if (value == null || value.isEmpty) {
                    return 'Name should not be empty';
                  }
                  if (value.length < 3) {
                    return 'Name must be at least 3 characters long';
                  }
                  final RegExp nameExp = RegExp(r'^[a-zA-Z\s]+$');
                  if (!nameExp.hasMatch(value)) {
                    return 'Name cannot contain numbers or special characters';
                  }
                  return null; // No error if validation passes
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                cursorColor: Colors.blue,
                controller: _nameController,
                onChanged: (value) {
                  final int cursorPosition =
                      _nameController.selection.baseOffset;
                  final String newValue = value.trimLeft();
                  _nameController.value = TextEditingValue(
                    text: newValue,
                    selection: TextSelection.collapsed(
                      offset: cursorPosition.clamp(0, newValue.length),
                    ),
                  );
                },
                decoration: customInputDecoration(
                  context: context,
                  hintText: "Enter your name",
                  prefixIcon: Icons.person_2_outlined,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  value = value?.trim();
                  if (value == null || value.isEmpty) {
                    return 'Account Number should not be empty';
                  }
                  final RegExp accountExp = RegExp(r'^[0-9]{9,18}$');
                  if (!accountExp.hasMatch(value)) {
                    return 'Account Number must be 9–18 digits';
                  }
                  return null;
                },
                cursorColor: Colors.blue,
                controller: _accountNumberController,
                autovalidateMode: AutovalidateMode.onUserInteraction,

                decoration: customInputDecoration(
                  context: context,
                  hintText: "Enter Account Number",
                  prefixIcon: Icons.account_balance_outlined,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  value = value?.trim().toUpperCase();
                  if (value == null || value.isEmpty) {
                    return 'IFSC code should not be empty';
                  }
                  final RegExp ifscExp = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
                  if (!ifscExp.hasMatch(value)) {
                    return 'Enter valid IFSC code (e.g. SBIN0001234)';
                  }
                  return null;
                },
                cursorColor: Colors.blue,
                controller: _ifscController,
                autovalidateMode: AutovalidateMode.onUserInteraction,

                decoration: customInputDecoration(
                  context: context,
                  hintText: "Enter Bank IFSC code",
                  prefixIcon: Icons.comment_bank,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  value = value?.trim();
                  if (value == null || value.isEmpty) {
                    return 'Amount should not be empty';
                  }
                  final double? amount = double.tryParse(value);
                  if (amount == null) {
                    return 'Enter a valid numeric amount';
                  }
                  if (amount < 10) {
                    return 'Amount must be at least Rs.10';
                  }
                  if (amount > 100000) {
                    return 'Amount must not exceed Rs.10,0000';
                  }
                  return null;
                },
                cursorColor: Colors.blue,
                controller: _amountController,
                autovalidateMode: AutovalidateMode.onUserInteraction,

                decoration: customInputDecoration(
                  context: context,
                  hintText: "Enter Amount",
                  prefixIcon: Icons.person_2_outlined,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration customInputDecoration({
  required BuildContext context,
  required String hintText,
  IconData? prefixIcon,
}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: GoogleFonts.roboto(
      fontSize: 15,
      fontWeight: FontWeight.w300,
      color: const Color(0xFF737373),
    ),
    filled: true,
    fillColor: const Color(0xFFF0F0F0),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFF0F0F0)),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFF0F0F0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.blue),
    ),
    prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
    contentPadding: EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width * 0.048,
      vertical: MediaQuery.of(context).size.height * 0.025,
    ),
  );
}
