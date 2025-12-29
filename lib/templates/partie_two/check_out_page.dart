import 'package:flutter/material.dart';
import 'package:grosly/templates/providers/global_variables.dart';
import 'package:provider/provider.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  String selectedShipping = "standard";
  final TextEditingController noteController = TextEditingController();

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Color(0xFF61AD4E),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GlobalVariables>();
    final subtotal = provider.cartTotal;
    final shippingCost = selectedShipping == "standard" ? 5.0 : 10.0;
    final tax = subtotal * 0.1;
    final total = subtotal + shippingCost + tax;
    final bool isCartEmpty = provider.cartItems.isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFE8E9EA), width: 1),
        ),
        title: const Text(
          "Checkout",
          style: TextStyle(
            color: Color(0xFF1C2229),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: isCartEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Color(0xFFE8E9EA),
            ),
            const SizedBox(height: 16),
            const Text(
              "Your cart is empty",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1C2229),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Add some products to your cart to proceed",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF97999D),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/home",
                      (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF61AD4E),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Start Shopping",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery Address
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE8E9EA)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Color(0xFF61AD4E)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Delivery Address",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF97999D),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Route Meknès, Fes, Morocco",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Color(0xFF97999D)),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Payment Method
              Container(
                padding: const EdgeInsets.all(12),
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE8E9EA)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.payment, color: Color(0xFF61AD4E)),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Cash on Delivery",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Color(0xFF97999D)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Shipping Duration
              const Text(
                "Shipping duration",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1C2229),
                ),
              ),
              const SizedBox(height: 10),

              // Standard Option
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedShipping = "standard";
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selectedShipping == "standard"
                          ? const Color(0xFF457B37)
                          : const Color(0xFFE8E9EA),
                      width: selectedShipping == "standard" ? 2 : 1,
                    ),
                    color: selectedShipping == "standard"
                        ? const Color(0xFFEFF7ED)
                        : Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Standard Delivery",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "3-5 business days",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF97999D),
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        "5.00 MAD",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF61AD4E),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Express Option
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedShipping = "express";
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selectedShipping == "express"
                          ? const Color(0xFF457B37)
                          : const Color(0xFFE8E9EA),
                      width: selectedShipping == "express" ? 2 : 1,
                    ),
                    color: selectedShipping == "express"
                        ? const Color(0xFFEFF7ED)
                        : Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Express Delivery",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "1-2 business days",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF97999D),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "10.00 MAD",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF61AD4E),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Order Summary
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE8E9EA),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Order Summary",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...provider.cartItems.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: const Color(0xFFF5F5F5),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.product.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    "x${item.quantity}",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF97999D),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "${(item.product.promoPrice ?? item.product.price) * item.quantity} MAD",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF61AD4E),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Special Notes
              Row(
                children: [
                  const Icon(Icons.edit, size: 16, color: Color(0xFF97999D)),
                  const SizedBox(width: 8),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: "Got a special request? ",
                          style: TextStyle(fontSize: 12),
                        ),
                        const TextSpan(
                          text: "Write a note",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF61AD4E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Price Summary
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFF9F9F9),
                  border: Border.all(color: const Color(0xFFE8E9EA), width: 1),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Subtotal",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "${subtotal.toStringAsFixed(2)} MAD",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Shipping",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "${shippingCost.toStringAsFixed(2)} MAD",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Tax (10%)",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "${tax.toStringAsFixed(2)} MAD",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          "${total.toStringAsFixed(2)} MAD",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF61AD4E),
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
      ),
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.only(bottom: 60),
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(width: 1, color: Color(0xFFE8E9EA))),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isCartEmpty ? Color(0xFFE8E9EA) : Color(0xFF61AD4E),
          ),
          child: TextButton(
            onPressed: isCartEmpty
                ? () {
              _showSnackBar(
                "Your cart is empty. Add products to proceed.",
                isError: true,
              );
            }
                : () {
              Navigator.pushNamed(context, "/final");
            },
            child: Text(
              "Proceed to Payment",
              style: TextStyle(
                color: isCartEmpty ? Color(0xFF97999D) : Colors.white,
                letterSpacing: -0.18,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }
}