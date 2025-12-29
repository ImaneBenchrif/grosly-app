import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grosly/templates/providers/global_variables.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GlobalVariables>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "My Profile",
          style: TextStyle(
            color: Color(0xFF1C2229),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFEFF7ED),
                      border: Border.all(
                        color: const Color(0xFF61AD4E),
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Color(0xFF61AD4E),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.fullName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1C2229),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    provider.email,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF97999D),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Edit profile coming soon!"),
                          backgroundColor: Color(0xFF61AD4E),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF7ED),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF61AD4E),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(
                          color: Color(0xFF61AD4E),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: Color(0xFFE8E9EA)),

            _buildSection(
              title: "Account Information",
              items: [
                _buildMenuItem(
                  icon: FontAwesomeIcons.user,
                  title: "Personal Information",
                  subtitle: provider.fullName,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Edit profile coming soon!"),
                        backgroundColor: Color(0xFF61AD4E),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: FontAwesomeIcons.locationDot,
                  title: "Delivery Address",
                  subtitle: provider.address,
                  onTap: () {
                    _showAddressDialog(context, provider);
                  },
                ),
                _buildMenuItem(
                  icon: FontAwesomeIcons.phone,
                  title: "Phone Number",
                  subtitle: provider.phoneNumber,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Edit profile coming soon!"),
                        backgroundColor: Color(0xFF61AD4E),
                      ),
                    );
                  },
                ),
              ],
            ),

            const Divider(height: 1, color: Color(0xFFE8E9EA)),

            _buildSection(
              title: "Orders",
              items: [
                _buildMenuItem(
                  icon: FontAwesomeIcons.clockRotateLeft,
                  title: "Order History",
                  subtitle: "View all your orders",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Order history coming soon!"),
                        backgroundColor: Color(0xFF61AD4E),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: FontAwesomeIcons.truck,
                  title: "Track Order",
                  subtitle: "Track your current orders",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Order tracking coming soon!"),
                        backgroundColor: Color(0xFF61AD4E),
                      ),
                    );
                  },
                ),
              ],
            ),

            const Divider(height: 1, color: Color(0xFFE8E9EA)),

            _buildSection(
              title: "Settings",
              items: [
                _buildMenuItem(
                  icon: FontAwesomeIcons.bell,
                  title: "Notifications",
                  subtitle: "Manage your notifications",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Notifications settings coming soon!"),
                        backgroundColor: Color(0xFF61AD4E),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: FontAwesomeIcons.language,
                  title: "Language",
                  subtitle: "English",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Language settings coming soon!"),
                        backgroundColor: Color(0xFF61AD4E),
                      ),
                    );
                  },
                ),
              ],
            ),

            const Divider(height: 1, color: Color(0xFFE8E9EA)),

            _buildSection(
              title: "Support",
              items: [
                _buildMenuItem(
                  icon: FontAwesomeIcons.circleQuestion,
                  title: "Help & Support",
                  subtitle: "Get help with your orders",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Help center coming soon!"),
                        backgroundColor: Color(0xFF61AD4E),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: FontAwesomeIcons.circleInfo,
                  title: "About Grosly",
                  subtitle: "Learn more about us",
                  onTap: () {
                    _showAboutDialog(context);
                  },
                ),
                _buildMenuItem(
                  icon: FontAwesomeIcons.fileLines,
                  title: "Terms & Conditions",
                  subtitle: "Read our terms",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Terms & Conditions coming soon!"),
                        backgroundColor: Color(0xFF61AD4E),
                      ),
                    );
                  },
                ),
              ],
            ),

            const Divider(height: 1, color: Color(0xFFE8E9EA)),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: GestureDetector(
                onTap: () {
                  _showLogoutDialog(context, provider);
                },
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.red.shade50,
                    border: Border.all(
                      color: Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        FontAwesomeIcons.rightFromBracket,
                        color: Colors.red,
                        size: 18,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF97999D),
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF7ED),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 18,
                color: const Color(0xFF61AD4E),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1C2229),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF97999D),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              FontAwesomeIcons.angleRight,
              size: 16,
              color: Color(0xFF97999D),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, GlobalVariables provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await provider.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                "/connexion",
                    (route) => false,
              );
            },
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddressDialog(BuildContext context, GlobalVariables provider) {
    final TextEditingController addressController = TextEditingController(
      text: provider.address,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Address"),
        content: TextField(
          controller: addressController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: "Enter your delivery address",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              provider.setAddress(addressController.text);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Address updated successfully!"),
                  backgroundColor: Color(0xFF61AD4E),
                ),
              );
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF7ED),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                "assets/icons/symbole.png",
                scale: 2,
              ),
            ),
            const SizedBox(width: 12),
            const Text("About Grosly"),
          ],
        ),
        content: const Text(
          "Grosly is your one-stop marketplace for fresh groceries, "
              "quality meats, seafood, and more. We deliver freshness to your doorstep!\n\n"
              "Version: 1.0.0\n"
              "© 2025 Grosly. All rights reserved.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}