import 'package:dio/dio.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:8000/grosly_api_office",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  static String? _authToken;

  static void setAuthToken(String token) {
    _authToken = token;
    dio.options.headers["Authorization"] = "Bearer $token";
    print("Token configured in headers");
  }

  static void clearAuthToken() {
    _authToken = null;
    dio.options.headers.remove("Authorization");
    print("Token removed");
  }
}

Future<Map<String, dynamic>> registerUser({
  required String fullName,
  required String email,
  required String phone,
  required String password,
}) async {
  try {
    List<String> nameParts = fullName.trim().split(' ');
    String firstName = nameParts.first;
    String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    final dataToSend = {
      "userfirstname": firstName,
      "userlastname": lastName,
      "email": email,
      "phone_number": phone,
      "password": password,
      "pays": "Morocco",
      "indicatif_pays": "+212",
      "adresse": "Fes, Morocco",
      "termes_active": true,
    };

    print("Data sent for registration: $dataToSend");

    final response = await ApiClient.dio.post("/users", data: dataToSend);

    print("Registration successful: ${response.data}");

    return {
      "success": true,
      "data": response.data,
      "message": "Registration successful"
    };
  } catch (e) {
    print("Error during registration: $e");

    if (e is DioException) {
      print("Status code: ${e.response?.statusCode}");
      print("Error details: ${e.response?.data}");

      return {
        "success": false,
        "message": e.response?.data?.toString() ?? "Registration error"
      };
    }

    return {
      "success": false,
      "message": "Registration error: ${e.toString()}"
    };
  }
}

Future<Map<String, dynamic>> loginUser({
  required String emailOrPhone,
  required String password,
}) async {
  try {
    print("LOGIN START");
    print("Email/Phone: $emailOrPhone");
    print("Password: $password");

    final formData = FormData.fromMap({
      "username": emailOrPhone,
      "password": password,
    });

    print("FormData created: ${formData.fields}");

    final response = await ApiClient.dio.post(
      "/grosly_token_office",
      data: formData,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    print("Response received: ${response.statusCode}");
    print("Data: ${response.data}");

    if (response.data["access_token"] != null) {
      ApiClient.setAuthToken(response.data["access_token"]);
      print("Token saved: ${response.data["access_token"].substring(0, 20)}...");
    } else {
      print("No token in response!");
    }

    return {
      "success": true,
      "data": response.data,
      "token": response.data["access_token"],
      "message": "Login successful"
    };
  } catch (e) {
    print("LOGIN ERROR");
    print("Error type: ${e.runtimeType}");
    print("Error: $e");

    if (e is DioException) {
      print("Status code: ${e.response?.statusCode}");
      print("Response data: ${e.response?.data}");

      String errorMessage = "Incorrect email/phone or password";

      if (e.response?.statusCode == 401) {
        errorMessage = "Incorrect email or password";
      } else if (e.response?.statusCode == 422) {
        errorMessage = "Invalid data";
      } else if (e.response?.statusCode == 500) {
        errorMessage = "Server error";
      }

      return {
        "success": false,
        "message": errorMessage
      };
    }

    print("END ERROR");

    return {
      "success": false,
      "message": "A connection error occurred"
    };
  }
}

Future<Map<String, dynamic>> getCurrentUser() async {
  try {
    print("USER RETRIEVAL");
    print("Current token: ${ApiClient._authToken != null ? ApiClient._authToken!.substring(0, 20) + '...' : 'NO TOKEN'}");
    print("Complete headers: ${ApiClient.dio.options.headers}");

    final response = await ApiClient.dio.get("/current_user");

    print("User retrieved successfully");
    print("User data: ${response.data}");

    return {
      "success": true,
      "data": response.data,
    };
  } catch (e) {
    print("USER RETRIEVAL ERROR");
    print("Error type: ${e.runtimeType}");
    print("Error: $e");

    if (e is DioException) {
      print("Status code: ${e.response?.statusCode}");
      print("Error details: ${e.response?.data}");
      print("Request headers: ${e.requestOptions.headers}");
      print("Request path: ${e.requestOptions.path}");
    }

    return {
      "success": false,
      "message": "Unable to retrieve user"
    };
  }
}

Future<Map<String, dynamic>> fetchCart(String userId) async {
  try {
    print("Loading cart for user_id: $userId");

    final response = await ApiClient.dio.get("/cart/$userId");

    print("Cart loaded: ${response.data}");

    return {
      "success": true,
      "data": response.data,
    };
  } catch (e) {
    print("Error retrieving cart: $e");

    if (e is DioException) {
      print("Status code: ${e.response?.statusCode}");
      print("Error details: ${e.response?.data}");

      if (e.response?.statusCode == 404) {
        print("Cart not found, creating empty cart");
        return {
          "success": true,
          "data": {
            "id": null,
            "user_id": userId,
            "items": []
          },
        };
      }
    }

    return {
      "success": false,
      "data": {
        "id": null,
        "user_id": userId,
        "items": []
      },
      "message": "Error retrieving cart"
    };
  }
}

Future<Map<String, dynamic>> addToCartApi({
  required String userId,
  required int productId,
  required int quantity,
}) async {
  try {
    final productResponse = await ApiClient.dio.get("/products/$productId");
    final productData = productResponse.data;
    final price = productData['promo_price'] ?? productData['price'];

    print("Adding to cart: user=$userId, product=$productId, qty=$quantity, price=$price");

    final response = await ApiClient.dio.post("/cart/items", data: {
      "user_id": userId,
      "product_id": productId.toString(),
      "quantity": quantity,
      "price": price,
    });

    print("Product added to cart: ${response.data}");

    return {
      "success": true,
      "data": response.data,
      "message": "Product added to cart"
    };
  } catch (e) {
    print("Error adding to cart: $e");

    if (e is DioException) {
      print("Status code: ${e.response?.statusCode}");
      print("Error details: ${e.response?.data}");
    }

    return {
      "success": false,
      "message": "Error adding to cart"
    };
  }
}

Future<Map<String, dynamic>> clearCartApi(String cartId) async {
  try {
    print("Clearing cart: $cartId");

    final response = await ApiClient.dio.delete("/cart/$cartId");

    print("Cart cleared: ${response.data}");

    return {
      "success": true,
      "data": response.data,
      "message": "Cart cleared"
    };
  } catch (e) {
    print("Error clearing cart: $e");
    return {
      "success": false,
      "message": "Error clearing cart"
    };
  }
}

Future<Map<String, dynamic>> fetchProductById(String id) async {
  try {
    final response = await ApiClient.dio.get("/products/$id");
    return response.data;
  } catch (e) {
    print("Error retrieving product $id: $e");
    return {};
  }
}

Future<List<dynamic>> fetchProducts() async {
  try {
    final response = await ApiClient.dio.get("/products");
    print("${response.data.length} products loaded");
    return response.data;
  } catch (e) {
    print("Error retrieving products: $e");
    return [];
  }
}

Future<List<dynamic>> fetchCategories() async {
  try {
    final response = await ApiClient.dio.get("/categories");
    print("${response.data.length} categories loaded");
    return response.data;
  } catch (e) {
    print("Error retrieving categories: $e");
    return [];
  }
}

Future<List<dynamic>> fetchTodaysChoice() async {
  try {
    final response = await ApiClient.dio.get("/products/todays-choice");
    return response.data;
  } catch (e) {
    print("Error retrieving Today's choice: $e");
    return [];
  }
}

Future<List<dynamic>> fetchLimitedDiscount() async {
  try {
    final response = await ApiClient.dio.get("/products/limited-discount");
    return response.data;
  } catch (e) {
    print("Error retrieving Limited discount: $e");
    return [];
  }
}

Future<List<dynamic>> fetchCheapest() async {
  try {
    final response = await ApiClient.dio.get("/products/cheapest");
    return response.data;
  } catch (e) {
    print("Error retrieving Cheapest: $e");
    return [];
  }
}

Future<Map<String, dynamic>> createOrder({
  required String userId,
  required List<Map<String, dynamic>> items,
  required double total,
  String? paymentMethod,
}) async {
  try {
    print("Creating order for user $userId");

    final response = await ApiClient.dio.post("/orders", data: {
      "user_id": userId,
      "address_id": "1",
      "items": items,
    });

    print("Order created: ${response.data}");

    return {
      "success": true,
      "data": response.data,
      "message": "Order created successfully"
    };
  } catch (e) {
    print("Error creating order: $e");

    if (e is DioException) {
      print("Status code: ${e.response?.statusCode}");
      print("Error details: ${e.response?.data}");
    }

    return {
      "success": false,
      "message": "Error creating order"
    };
  }
}