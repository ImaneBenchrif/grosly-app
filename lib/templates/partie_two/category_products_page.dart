import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grosly/templates/providers/global_variables.dart';
import 'package:provider/provider.dart';

class CategoryProductsPage extends StatefulWidget {
  final String categoryTitle;

  const CategoryProductsPage({
    super.key,
    required this.categoryTitle,
  });

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GlobalVariables>();

    String? categoryId = _getCategoryIdFromTitle(provider.categories, widget.categoryTitle);

    List filteredProducts = provider.products.where((product) {
      bool matchesCategory = product.categoryId == categoryId;

      if (searchQuery.isNotEmpty) {
        return matchesCategory && product.name.toLowerCase().contains(searchQuery.toLowerCase());
      }

      return matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1C2229)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryTitle,
          style: const TextStyle(
            color: Color(0xFF1C2229),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 46,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(width: 1, color: const Color(0xFFE8E9EA)),
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.search, size: 24, color: Color(0xFF61AD4E)),
                hintText: "Search products...",
                border: InputBorder.none,
              ),
            ),
          ),

          const Divider(color: Color(0xFFE8E9EA), height: 1),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  searchQuery.isEmpty
                      ? "${widget.categoryTitle} Products"
                      : 'Results for "$searchQuery"',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1C2229),
                  ),
                ),
                Text(
                  "${filteredProducts.length} products",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF97999D),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    FontAwesomeIcons.boxOpen,
                    size: 60,
                    color: Color(0xFFE8E9EA),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No products found",
                    style: TextStyle(
                      color: Color(0xFF97999D),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/details",
                      arguments: product,
                    );
                  },
                  child: _buildCompactProductCard(product, provider),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactProductCard(Product product, GlobalVariables provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1, color: const Color(0xFFE8E9EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  product.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: Color(0xFFB9BABD),
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: Color(0xFF1C2229),
                    ),
                  ),

                  Text(
                    product.weight,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF97999D),
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${product.promoPrice ?? product.price} MAD",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF61AD4E),
                            ),
                          ),
                          if (product.promoPrice != null) ...[
                            const SizedBox(width: 6),
                            Text(
                              "${product.price}",
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFFB9BABD),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (product.promoPrice != null) ...[
                        const SizedBox(height: 3),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "-${_calculateDiscount(product.price, product.promoPrice!)}%",
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateDiscount(double originalPrice, double promoPrice) {
    if (originalPrice <= 0) return 0;
    return ((originalPrice - promoPrice) / originalPrice * 100).round();
  }

  String? _getCategoryIdFromTitle(List<Map<String, dynamic>> categories, String title) {
    try {
      final category = categories.firstWhere(
            (cat) => cat['name']?.toString().toLowerCase() == title.toLowerCase(),
        orElse: () => {},
      );
      return category['id']?.toString();
    } catch (e) {
      debugPrint("Category not found: $title");
      return null;
    }
  }
}