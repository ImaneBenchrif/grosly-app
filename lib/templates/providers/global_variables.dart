import 'package:flutter/material.dart';
import 'package:grosly/client.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? promoPrice;
  final int stock;
  final String? categoryId;
  final String weight;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.promoPrice,
    required this.stock,
    this.categoryId,
    required this.weight,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    try {
      return Product(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? 'Unknown',
        description: json['description']?.toString() ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        promoPrice: json['promo_price'] != null
            ? (json['promo_price'] as num).toDouble()
            : null,
        stock: json['stock'] as int? ?? 0,
        categoryId: json['category_id']?.toString(),
        weight: json['weight']?.toString() ?? '1kg',
        image: json['image']?.toString() ?? "https://via.placeholder.com/150",
      );
    } catch (e) {
      debugPrint("Error parsing product: $e");
      debugPrint("Problematic JSON: $json");
      rethrow;
    }
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });
}

class GlobalVariables extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  void setIsLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  bool _viewOnboarding = false;
  bool get viewOnboarding => _viewOnboarding;

  void setViewOnboarding(bool value) {
    _viewOnboarding = value;
    notifyListeners();
  }

  bool _isLogviewed = true;
  bool get isLogviewed => _isLogviewed;

  void setIsLogviewed(bool value) {
    _isLogviewed = value;
    notifyListeners();
  }

  bool login(String email, String password) {
    _isLoggedIn = true;
    notifyListeners();
    return true;
  }

  String? _userId;
  String _fullName = "Guest User";
  String _email = "guest@grosly.com";
  String _phoneNumber = "+212 600 000 000";
  String _address = "Route Meknès, Fes, Morocco";

  String? get userId => _userId;
  String get fullName => _fullName;
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  String get address => _address;

  void setUserInfo({
    String? userId,
    required String fullName,
    required String email,
    required String phoneNumber,
    String? address,
  }) {
    _userId = userId;
    _fullName = fullName;
    _email = email;
    _phoneNumber = phoneNumber;
    if (address != null) _address = address;
    notifyListeners();
  }

  void setAddress(String address) {
    _address = address;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _userId = null;
    _fullName = "Guest User";
    _email = "guest@grosly.com";
    _phoneNumber = "+212 600 000 000";
    _address = "Route Meknès, Fes, Morocco";

    await clearCart();
    ApiClient.clearAuthToken();

    notifyListeners();
  }

  String _transactionId = "";
  String _orderDate = "";
  String _paymentMethod = "Cash on Delivery";

  String get transactionId => _transactionId;
  String get orderDate => _orderDate;
  String get paymentMethod => _paymentMethod;

  void generateOrder() {
    _transactionId = DateTime.now().millisecondsSinceEpoch.toString().substring(3);

    final now = DateTime.now();
    final months = ['January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'];
    _orderDate = "${months[now.month - 1]} ${now.day}${_getDaySuffix(now.day)}, ${now.year}";

    notifyListeners();
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

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  List<CartItem> _cartItems = [];
  bool _loadingCart = false;
  String? _cartId;

  List<CartItem> get cartItems => _cartItems;
  bool get isLoadingCart => _loadingCart;
  String? get cartId => _cartId;

  int get cartItemCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  double get cartTotal {
    return _cartItems.fold(
      0.0,
          (sum, item) => sum + ((item.product.promoPrice ?? item.product.price) * item.quantity),
    );
  }

  Future<void> loadCartFromApi() async {
    if (_userId == null) {
      debugPrint("No user logged in, cannot load cart");
      return;
    }

    _loadingCart = true;
    notifyListeners();

    try {
      final result = await fetchCart(_userId!);

      if (result['success']) {
        final cartData = result['data'];

        if (cartData['id'] != null) {
          _cartId = cartData['id'].toString();
        }

        _cartItems.clear();

        if (cartData['items'] != null && cartData['items'] is List) {
          for (var item in cartData['items']) {
            try {
              final product = Product.fromJson(item['product']);
              _cartItems.add(CartItem(
                product: product,
                quantity: item['quantity'] ?? 1,
              ));
            } catch (e) {
              debugPrint("Error parsing cart item: $e");
            }
          }
        }

        if (_cartItems.isEmpty) {
          debugPrint("Empty cart for this user");
        } else {
          debugPrint("Cart loaded: ${_cartItems.length} items");
        }
      } else {
        debugPrint("Failed to load cart: ${result['message']}");
      }
    } catch (e) {
      debugPrint("Error loading cart: $e");
    }

    _loadingCart = false;
    notifyListeners();
  }

  Future<void> addToCart(Product product, int quantity) async {
    if (_userId == null) {
      debugPrint("No user logged in");
      return;
    }

    final existingIndex = _cartItems.indexWhere(
            (item) => item.product.id == product.id
    );

    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity += quantity;
    } else {
      _cartItems.add(CartItem(product: product, quantity: quantity));
    }

    notifyListeners();

    try {
      final productId = int.tryParse(product.id);
      if (productId != null) {
        final result = await addToCartApi(
          userId: _userId!,
          productId: productId,
          quantity: quantity,
        );

        if (result['success']) {
          debugPrint("Product added to cart on server");
          await loadCartFromApi();
        } else {
          debugPrint("Error adding to cart API: ${result['message']}");
        }
      }
    } catch (e) {
      debugPrint("Error syncing cart: $e");
    }
  }

  void removeFromCart(Product product) {
    _cartItems.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void updateCartItemQuantity(Product product, int newQuantity) {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (newQuantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    _cartItems.clear();
    notifyListeners();

    if (_cartId != null) {
      try {
        final result = await clearCartApi(_cartId!);
        if (result['success']) {
          debugPrint("Cart cleared on server");
          _cartId = null;
        }
      } catch (e) {
        debugPrint("Error clearing cart API: $e");
      }
    }
  }

  List<Product> _products = [];
  List<Product> _todaysChoiceProducts = [];
  List<Product> _limitedDiscountProducts = [];
  List<Product> _cheapestProducts = [];
  List<Map<String, dynamic>> _categories = [];
  bool _loadingProducts = false;
  bool _loadingFilteredProducts = false;

  List<Product> get products => _products;
  List<Product> get todaysChoiceProducts => _todaysChoiceProducts;
  List<Product> get limitedDiscountProducts => _limitedDiscountProducts;
  List<Product> get cheapestProducts => _cheapestProducts;
  List<Map<String, dynamic>> get categories => _categories;
  bool get loadingProducts => _loadingProducts;
  bool get loadingFilteredProducts => _loadingFilteredProducts;

  Future<void> loadProductsFromApi() async {
    _loadingProducts = true;
    notifyListeners();

    try {
      final data = await fetchProducts();
      _products = data.map((json) => Product.fromJson(json)).toList();
      debugPrint("${_products.length} products loaded in GlobalVariables");
    } catch (e) {
      debugPrint("Error loading products: $e");
    }

    _loadingProducts = false;
    notifyListeners();
  }

  Future<void> loadCategoriesFromApi() async {
    try {
      final data = await fetchCategories();
      _categories = List<Map<String, dynamic>>.from(data);
      debugPrint("${_categories.length} categories loaded");
    } catch (e) {
      debugPrint("Error loading categories: $e");
    }
    notifyListeners();
  }

  Future<void> loadFilteredProducts() async {
    _loadingFilteredProducts = true;
    notifyListeners();

    try {
      final todaysData = await fetchTodaysChoice();
      _todaysChoiceProducts = todaysData.map((json) => Product.fromJson(json)).toList();

      final limitedData = await fetchLimitedDiscount();
      _limitedDiscountProducts = limitedData.map((json) => Product.fromJson(json)).toList();

      final cheapestData = await fetchCheapest();
      _cheapestProducts = cheapestData.map((json) => Product.fromJson(json)).toList();

      debugPrint("Filtered products loaded");
    } catch (e) {
      debugPrint("Error loading filtered products: $e");
    }

    _loadingFilteredProducts = false;
    notifyListeners();
  }

  Widget productFromApi(Product product) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 12),
      height: 230,
      width: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 1, color: const Color(0xFFE8E9EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: 116,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  debugPrint("Error loading image: ${product.image}");
                  return const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: Color(0xFFB9BABD),
                      size: 40,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF61AD4E),
                      strokeWidth: 2,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 6),
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
          const SizedBox(height: 2),
          Text(
            product.weight,
            style: const TextStyle(
              fontSize: 9,
              color: Color(0xFF97999D),
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "${product.promoPrice ?? product.price} MAD",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF61AD4E),
                    ),
                  ),
                  if (product.promoPrice != null) ...[
                    const SizedBox(width: 5),
                    Text(
                      "${product.price}",
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFB9BABD),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ],
              ),
              if (product.promoPrice != null) ...[
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "-${_calculateDiscount(product.price, product.promoPrice!)}%",
                    style: const TextStyle(
                      fontSize: 9,
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
    );
  }

  int _calculateDiscount(double originalPrice, double promoPrice) {
    if (originalPrice <= 0) return 0;
    return ((originalPrice - promoPrice) / originalPrice * 100).round();
  }
}