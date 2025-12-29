import 'package:flutter/material.dart';
import 'package:grosly/templates/partie_one/connexion.dart';
import 'package:grosly/templates/partie_one/onboarding.dart';
import 'package:grosly/templates/partie_two/basket_page.dart';
import 'package:grosly/templates/partie_two/bot_page.dart';
import 'package:grosly/templates/partie_two/check_out_page.dart';
import 'package:grosly/templates/partie_two/details_page.dart';
import 'package:grosly/templates/partie_two/final_page.dart';
import 'package:grosly/templates/partie_two/home.dart';
import 'package:grosly/templates/partie_two/main_layout.dart';
import 'package:grosly/templates/providers/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:grosly/templates/partie_two/profile_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalVariables()),
      ],
      child: const Grosly(),
    ),
  );
}

class Grosly extends StatefulWidget {
  const Grosly({super.key});

  @override
  State<Grosly> createState() => _GroslyState();
}

class _GroslyState extends State<Grosly> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/onbording",
      routes: {
        "/onbording": (context) => const Onbording(),
        "/connexion": (context) => const Connexion(),
        "/home": (context) => const MainLayout(),
        "/details": (context) => const DetailPage(),
        "/bot": (context) => const BotPage(),
        "/basket": (context) => const BasketPage(),
        "/checkout": (context) => const Checkout(),
        "/final": (context) => const FinalPage(),
        "/profile": (context) => ProfilePage(),
      },
    );
  }
}