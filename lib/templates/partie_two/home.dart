import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grosly/templates/providers/global_variables.dart';
import 'package:provider/provider.dart';
import 'category_products_page.dart';

class Home extends StatefulWidget {
  final VoidCallback? onNavigateToCategories;

  const Home({
    super.key,
    this.onNavigateToCategories,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentindex_ = 0;
  String homeSearchQuery = "";
  String selectedFilter = "todays_choice";

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider = context.read<GlobalVariables>();

      await provider.loadProductsFromApi();
      await provider.loadCategoriesFromApi();
      await provider.loadFilteredProducts();

      if (provider.isLoggedIn && provider.userId != null) {
        await provider.loadCartFromApi();
      }
    });
  }

  Widget changedView(BuildContext context, int value) {
    Widget view;
    if (value == 0) {
      view = home(
        context,
        widget.onNavigateToCategories ?? () {
          setState(() {
            currentindex_ = 1;
          });
        },
            (query) {
          setState(() {
            homeSearchQuery = query;
          });
        },
        homeSearchQuery,
        selectedFilter,
            (filter) {
          setState(() {
            selectedFilter = filter;
          });
        },
      );
    } else if (value == 1) {
      view = ViewCategorie(
        onBackPressed: () {
          setState(() {
            currentindex_ = 0;
          });
        },
      );
    } else {
      view = const Scaffold();
    }
    return view;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: changedView(context, currentindex_),
    );
  }
}

class ViewCategorie extends StatefulWidget {
  final VoidCallback onBackPressed;

  const ViewCategorie({
    super.key,
    required this.onBackPressed,
  });

  @override
  State<ViewCategorie> createState() => _ViewCategorieState();
}

class _ViewCategorieState extends State<ViewCategorie> {
  String searchQuery = "";

  final List<Map<String, dynamic>> allCategories = [
    {
      "title": "Vegetables",
      "productCount": "10 products",
      "icon": "assets/icons/vege.png",
      "backgroundColor": const Color(0xFFCEE6C8)
    },
    {
      "title": "Fruits",
      "productCount": "10 products",
      "icon": "assets/icons/fruits.png",
      "backgroundColor": const Color(0xFFEDD251)
    },
    {
      "title": "Chicken",
      "productCount": "5 products",
      "icon": "assets/icons/chicken.png",
      "backgroundColor": const Color(0xFFFCE6E6)
    },
    {
      "title": "Beef",
      "productCount": "5 products",
      "icon": "assets/icons/meat1.png",
      "backgroundColor": const Color(0xFFE9B7B7)
    },
    {
      "title": "Seafood",
      "productCount": "5 products",
      "icon": "assets/icons/seafood1.png",
      "backgroundColor": const Color(0xFFE6D0C7)
    },
    {
      "title": "Protein",
      "productCount": "5 products",
      "icon": "assets/icons/protein1.png",
      "backgroundColor": const Color(0xFFEBE3DC)
    },
  ];

  List<Map<String, dynamic>> get filteredCategories {
    if (searchQuery.isEmpty) {
      return allCategories;
    }
    return allCategories.where((category) {
      return category["title"]
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "All Categories",
          style: TextStyle(
            color: Color(0xFF1C2229),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1C2229)),
          onPressed: widget.onBackPressed,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
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
                  hintText: "Search category",
                  border: InputBorder.none,
                ),
              ),
            ),
            const Divider(color: Color(0xFFE8E9EA)),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                searchQuery.isEmpty
                    ? "All categories"
                    : "Results for \"$searchQuery\"",
                style: const TextStyle(
                  letterSpacing: -0.18,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            filteredCategories.isEmpty
                ? const Padding(
              padding: EdgeInsets.all(50),
              child: Center(
                child: Text(
                  "No categories found",
                  style: TextStyle(
                    color: Color(0xFF97999D),
                    fontSize: 14,
                  ),
                ),
              ),
            )
                : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.3,
              ),
              padding: const EdgeInsets.all(12),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final category = filteredCategories[index];
                return catego(
                  title: category["title"],
                  productCount: category["productCount"],
                  icon: category["icon"],
                  backgroundColor: category["backgroundColor"],
                  context: context,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget catego({
  required String title,
  required String productCount,
  required String icon,
  required Color backgroundColor,
  required BuildContext context,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CategoryProductsPage(
            categoryTitle: title,
          ),
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: const Color(0xFFE8E9EA)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF1C2229),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    productCount,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF97999D),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: double.infinity,
            width: 70,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                topLeft: Radius.circular(35),
                bottomLeft: Radius.circular(35),
              ),
              color: backgroundColor,
            ),
            child: Image.asset(icon, scale: 2),
          ),
        ],
      ),
    ),
  );
}

Widget _categorie({required String title, required String path}) {
  return Column(
    children: [
      Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFFEFF7ED),
        ),
        child: Image.asset(path, scale: 2),
      ),
      const SizedBox(height: 10),
      Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1C2229),
        ),
      ),
    ],
  );
}

Widget home(
    BuildContext context,
    VoidCallback onSeeAllCategories,
    Function(String) onSearchChanged,
    String searchQuery,
    String selectedFilter,
    Function(String) onFilterChanged,
    ) {
  final provider = context.watch<GlobalVariables>();

  List products = [];
  if (selectedFilter == "todays_choice") {
    products = provider.todaysChoiceProducts;
  } else if (selectedFilter == "limited_discount") {
    products = provider.limitedDiscountProducts;
  } else if (selectedFilter == "cheapest") {
    products = provider.cheapestProducts;
  }

  List filteredProducts = searchQuery.isEmpty
      ? products
      : provider.products.where((product) {
    return product.name.toLowerCase().contains(searchQuery.toLowerCase());
  }).toList();

  return SingleChildScrollView(
    child: Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 210, 210, 210),
                Colors.white,
                Colors.white,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 30,
                      width: 168,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          width: 1,
                          color: const Color(0xFFE8E9EA),
                        ),
                      ),
                      child: Row(
                        children: const [
                          SizedBox(width: 5),
                          Icon(Icons.my_location),
                          SizedBox(width: 10),
                          Text("Route Meknès"),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/bot");
                      },
                      child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Image.asset(
                          "assets/icons/bot.png",
                          width: 19,
                          height: 19,
                          scale: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "Pay Day\nShop Day",
                                style: TextStyle(
                                  color: Color(0xFF457B37),
                                  letterSpacing: -0.34,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        child: Row(
                          children: const [
                            Text(
                              "Voucher\nup to",
                              style: TextStyle(
                                color: Color(0xFF457B37),
                                letterSpacing: -0.18,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(width: 20),
                            Text(
                              "75",
                              style: TextStyle(
                                color: Color(0xFF457B37),
                                letterSpacing: -0.34,
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              "%",
                              style: TextStyle(
                                color: Color(0xFF457B37),
                                letterSpacing: -0.18,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 200,
                    width: 200,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/icons/femme.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  height: 54,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      width: 1,
                      color: const Color(0xFFE8E9EA),
                    ),
                  ),
                  child: TextField(
                    onChanged: onSearchChanged,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: const InputDecoration(
                      isDense: true,
                      hintText: "What's your daily needs?",
                      hintStyle: TextStyle(color: Color(0xFFB9BABD)),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      border: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.search,
                        color: Color(0xFF61AD4E),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Categories",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.18,
                  color: Color(0xFF1C2229),
                ),
              ),
              TextButton(
                onPressed: onSeeAllCategories,
                child: Row(
                  children: const [
                    Text(
                      "See all",
                      style: TextStyle(
                        color: Color(0xFF61AD4E),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Icon(
                      FontAwesomeIcons.angleRight,
                      color: Color(0xFF61AD4E),
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _categorie(title: "Vegetables", path: "assets/icons/vegetable.png"),
              const SizedBox(width: 12),
              _categorie(title: "Fruits", path: "assets/icons/fruits_c.png"),
              const SizedBox(width: 12),
              _categorie(title: "Chicken", path: "assets/icons/pouletery.png"),
              const SizedBox(width: 12),
              _categorie(title: "Beef", path: "assets/icons/meat.png"),
              const SizedBox(width: 12),
              _categorie(title: "Seafood", path: "assets/icons/seafood.png"),
              const SizedBox(width: 12),
              _categorie(title: "Protein", path: "assets/icons/protein.png"),
            ],
          ),
        ),

        if (searchQuery.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Search results for "$searchQuery"',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1C2229),
              ),
            ),
          ),

        Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: const BoxDecoration(color: Color(0xFFCEE6C8)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Flash sale"),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      children: const [
                        Text(
                          "See all",
                          style: TextStyle(
                            color: Color(0xFF61AD4E),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Icon(
                          FontAwesomeIcons.angleRight,
                          color: Color(0xFF61AD4E),
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              provider.loadingProducts
                  ? const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              )
                  : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: provider.products.map((product) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/details",
                            arguments: product,
                          );
                        },
                        child: provider.productFromApi(product),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () => onFilterChanged("todays_choice"),
              child: Text(
                "Today's choices",
                style: TextStyle(
                  color: selectedFilter == "todays_choice"
                      ? const Color(0xFF61AD4E)
                      : const Color(0xFF97999D),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton(
              onPressed: () => onFilterChanged("limited_discount"),
              child: Text(
                "Limited discount!",
                style: TextStyle(
                  color: selectedFilter == "limited_discount"
                      ? const Color(0xFF61AD4E)
                      : const Color(0xFF97999D),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton(
              onPressed: () => onFilterChanged("cheapest"),
              child: Text(
                "Cheapest!",
                style: TextStyle(
                  color: selectedFilter == "cheapest"
                      ? const Color(0xFF61AD4E)
                      : const Color(0xFF97999D),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const Divider(),

        provider.loadingFilteredProducts
            ? const Padding(
          padding: EdgeInsets.all(50),
          child: Center(child: CircularProgressIndicator()),
        )
            : filteredProducts.isEmpty
            ? const Padding(
          padding: EdgeInsets.all(50),
          child: Center(
            child: Text(
              "No products available",
              style: TextStyle(
                color: Color(0xFF97999D),
                fontSize: 14,
              ),
            ),
          ),
        )
            : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: filteredProducts.map((product) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/details",
                      arguments: product,
                    );
                  },
                  child: provider.productFromApi(product),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 80),
      ],
    ),
  );
}