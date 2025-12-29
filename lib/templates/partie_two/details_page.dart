import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grosly/templates/providers/global_variables.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              viewproduct(context, product),
              viewelementadd(product, quantity, () {
                setState(() {
                  if (quantity > 1) quantity--;
                });
              }, () {
                setState(() {
                  quantity++;
                });
              }),
              viewdescribe(product),
              const SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Divider(
                  color: Color(0xFFE8E9EA),
                ),
              ),
              const SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "Related product",
                  style: TextStyle(
                    color: Color(0xFF1C2229),
                    letterSpacing: -0.18,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: context.watch<GlobalVariables>().products.take(3).map((p) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            "/details",
                            arguments: p,
                          );
                        },
                        child: context.watch<GlobalVariables>().productFromApi(p),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.only(bottom: 40),
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(width: 1, color: Color(0xFFE8E9EA)),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFF61AD4E),
          ),
          child: TextButton(
            onPressed: () {
              context.read<GlobalVariables>().addToCart(product, quantity);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.name} added to cart (x$quantity)'),
                  duration: const Duration(seconds: 2),
                  backgroundColor: const Color(0xFF61AD4E),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  FontAwesomeIcons.basketShopping,
                  color: Colors.white,
                  size: 16,
                ),
                SizedBox(width: 10),
                Text(
                  "Add to Cart",
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: -0.18,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget viewdescribe(Product product) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Description",
          style: TextStyle(
            color: Color(0xFF1C2229),
            letterSpacing: -0.18,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          product.description.isNotEmpty
              ? product.description
              : "No description available for this product.",
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFF97999D),
          ),
        ),
      ],
    ),
  );
}

Widget viewproduct(BuildContext context, Product product) {
  return Container(
    height: 300,
    padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 12),
    width: double.infinity,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(product.image),
        fit: BoxFit.cover,
      ),
    ),
    child: Align(
      alignment: Alignment.topCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE8E9EA), width: 1),
              borderRadius: BorderRadius.circular(36),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back,
                  size: 16, color: Color(0xFF1C2229)),
            ),
          ),
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE8E9EA), width: 1),
              borderRadius: BorderRadius.circular(36),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/basket");
              },
              child: const Icon(
                FontAwesomeIcons.basketShopping,
                size: 16,
                color: Color(0xFF61AD4E),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget viewelementadd(Product product, int quantity, VoidCallback onDecrease, VoidCallback onIncrease) {
  String discountPercent = "0%";
  if (product.promoPrice != null && product.promoPrice! < product.price) {
    double discount = ((product.price - product.promoPrice!) / product.price) * 100;
    discountPercent = "${discount.toStringAsFixed(0)}%";
  }

  return Container(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: const TextStyle(
            color: Color(0xFF1C2229),
            letterSpacing: -0.3,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          product.weight,
          style: const TextStyle(
            color: Color(0xFF97999D),
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (product.promoPrice != null) ...[
                  Container(
                    alignment: Alignment.center,
                    height: 25,
                    width: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4250),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      discountPercent,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Text(
                  "${product.promoPrice ?? product.price} MAD",
                  style: const TextStyle(
                    color: Color(0xFF61AD4E),
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    letterSpacing: -0.3,
                  ),
                ),
                if (product.promoPrice != null) ...[
                  const SizedBox(width: 10),
                  Text(
                    "${product.price} MAD",
                    style: const TextStyle(
                      color: Color(0xFFEF4250),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ],
            ),
            Row(
              children: [
                Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: const Color(0xFFE8E9EA)),
                  ),
                  child: GestureDetector(
                    onTap: onDecrease,
                    child: const Icon(
                      FontAwesomeIcons.minus,
                      size: 12,
                      color: Color(0xFF61AD4E),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "$quantity",
                  style: const TextStyle(
                    color: Color(0xFF0C0E11),
                    letterSpacing: -0.18,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCEE6C8),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: const Color(0xFFE8E9EA)),
                  ),
                  child: GestureDetector(
                    onTap: onIncrease,
                    child: const Icon(
                      FontAwesomeIcons.plus,
                      size: 12,
                      color: Color(0xFF61AD4E),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(width: 1, color: const Color(0xFFE8E9EA)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "Stock",
                    style: TextStyle(
                      color: Color(0xFF97999D),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "Available",
                    style: TextStyle(
                      color: Color(0xFF1C2229),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Weight",
                    style: TextStyle(
                      color: Color(0xFF97999D),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    product.weight,
                    style: const TextStyle(
                      color: Color(0xFF1C2229),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Price/unit",
                    style: TextStyle(
                      color: Color(0xFF97999D),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "${product.promoPrice ?? product.price} MAD",
                    style: const TextStyle(
                      color: Color(0xFF1C2229),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}