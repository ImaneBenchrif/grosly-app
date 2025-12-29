import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grosly/templates/providers/global_variables.dart';
import 'dart:math';

class FinalPage extends StatefulWidget {
  const FinalPage({super.key});

  @override
  State<FinalPage> createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> {
  String? _generatedOrderId;
  String? _generatedOrderDate;

  @override
  void initState() {
    super.initState();
    _generateOrderInfo();
  }

  void _generateOrderInfo() {
    final random = Random();
    _generatedOrderId = (100000000 + random.nextInt(900000000)).toString();

    final now = DateTime.now();
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    _generatedOrderDate = "${months[now.month - 1]} ${now.day}${_getDaySuffix(now.day)}, ${now.year}";
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GlobalVariables>();
    final bool isPaid = provider.paymentMethod != "Cash on Delivery";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: 151,
              child: Image.asset("assets/icons/livreur.png"),
            ),
            Container(
              alignment: Alignment.center,
              width: 274,
              child: Column(
                children: [
                  Text(
                    "Your order is made!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1C2229),
                      letterSpacing: -0.3,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    style: TextStyle(
                      color: Color(0xFF97999D),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                    "Congratulations, your order has been successfully proceed, we will deliver your order as soon as possible!",
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(width: 1, color: Color(0xFFE8E9EA)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Transaction ID",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF97999D),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _generatedOrderId ?? "N/A",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1C2229),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Recipient name",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF97999D),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        provider.fullName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1C2229),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Address",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF97999D),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        provider.address,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1C2229),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF97999D),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _generatedOrderDate ?? "N/A",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1C2229),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Payment method",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF97999D),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        provider.paymentMethod,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1C2229),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total amount",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF97999D),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${provider.cartTotal.toStringAsFixed(2)} MAD",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF61AD4E),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Divider(color: Color(0xFFE8E9EA)),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Status",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF97999D),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: isPaid
                              ? Color(0xFFEFF7ED)
                              : Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isPaid ? "Paid" : "Unpaid",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isPaid
                                ? Color(0xFF61AD4E)
                                : Color(0xFFFF9800),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        margin: EdgeInsets.only(bottom: 40),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: Color(0xFFE8E9EA)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xFFEFF7ED),
              ),
              child: TextButton(
                onPressed: () async {
                  await provider.clearCart();

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    "/home",
                        (route) => false,
                  );
                },
                child: Text(
                  "Back to Home",
                  style: TextStyle(
                    color: Color(0xFF61AD4E),
                    letterSpacing: -0.18,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xFF61AD4E),
              ),
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Order tracking coming soon!"),
                      backgroundColor: Color(0xFF61AD4E),
                    ),
                  );
                },
                child: Text(
                  "Track Order",
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: -0.18,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}