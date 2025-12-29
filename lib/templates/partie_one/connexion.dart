import 'package:flutter/material.dart';
import 'package:grosly/templates/providers/global_variables.dart';
import 'package:provider/provider.dart';
import 'package:grosly/client.dart';

class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Color(0xFF61AD4E),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _handleRegister() async {
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (fullName.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      _showSnackBar("Please fill in all fields", isError: true);
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar("Passwords do not match", isError: true);
      return;
    }

    if (password.length < 6) {
      _showSnackBar("Password must be at least 6 characters", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final result = await registerUser(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
    );

    setState(() => _isLoading = false);

    if (result['success']) {
      _showSnackBar("Registration successful! Please log in.", isError: false);
      context.read<GlobalVariables>().setIsLogviewed(true);
      phoneController.text = email;
      passwordController.clear();
    } else {
      _showSnackBar(result['message'], isError: true);
    }
  }

  Future<void> _handleLogin() async {
    final emailOrPhone = phoneController.text.trim();
    final password = passwordController.text.trim();

    print("=== LOGIN ATTEMPT ===");
    print("Email/Phone entered: '$emailOrPhone'");
    print("Password entered: '$password'");

    if (emailOrPhone.isEmpty || password.isEmpty) {
      _showSnackBar("Please fill in all fields", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      print("STEP 1/4: Calling Login API...");
      final result = await loginUser(
        emailOrPhone: emailOrPhone,
        password: password,
      );

      if (!result['success']) {
        setState(() => _isLoading = false);
        print("Login failed: ${result['message']}");
        _showSnackBar(result['message'], isError: true);
        return;
      }

      print("STEP 1/4: Login successful, token received");
      print("STEP 2/4: Attempting to retrieve user information...");

      final userResult = await getCurrentUser();

      print("getCurrentUser result: ${userResult['success']}");

      if (userResult['success'] && userResult['data'] != null) {
        print("STEP 2/4: User information retrieved from API");
        final userData = userResult['data'];

        print("User data received:");
        print("   - id: ${userData['id']}");
        print("   - userfirstname: ${userData['userfirstname']}");
        print("   - userlastname: ${userData['userlastname']}");
        print("   - email: ${userData['email']}");
        print("   - phone_number: ${userData['phone_number']}");

        context.read<GlobalVariables>().setUserInfo(
          userId: userData['id'],
          fullName: "${userData['userfirstname']} ${userData['userlastname']}",
          email: userData['email'] ?? emailOrPhone,
          phoneNumber: userData['phone_number'] ?? "",
        );
      } else {
        print("STEP 2/4: getCurrentUser failed, using default data");
        print("   Error message: ${userResult['message']}");

        context.read<GlobalVariables>().setUserInfo(
          userId: "1",
          fullName: "User",
          email: emailOrPhone,
          phoneNumber: "",
        );
      }

      print("STEP 2/4: User information saved in GlobalVariables");

      context.read<GlobalVariables>().setIsLoggedIn(true);
      print("STEP 2/4: User marked as logged in");

      print("STEP 3/4: Attempting to load cart...");
      try {
        await context.read<GlobalVariables>().loadCartFromApi();
        print("STEP 3/4: Cart loaded successfully");
      } catch (e) {
        print("STEP 3/4: Cart loading error (non-blocking): $e");
      }

      setState(() => _isLoading = false);
      print("STEP 3/4: Loading completed");

      print("=== LOGIN COMPLETE ===");
      _showSnackBar("Login successful!", isError: false);

      print("STEP 4/4: Navigating to /home");
      Navigator.pushReplacementNamed(context, "/home");
      print("STEP 4/4: Navigation initiated");

    } catch (e, stackTrace) {
      setState(() => _isLoading = false);
      print("UNEXPECTED ERROR DURING LOGIN");
      print("Error type: ${e.runtimeType}");
      print("Message: $e");
      print("Stack trace: $stackTrace");
      _showSnackBar("An error occurred", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(height: 352, width: double.infinity),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 352,
              width: 393,
              child: Image.asset(
                "assets/icons/auth_header.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: 60),
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0xFFEFF7ED),
                        ),
                        child: Image.asset(
                          "assets/icons/symbole.png",
                          width: 25.96,
                          height: 25.96,
                          scale: 2,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Welcome to Grosly",
                        style: TextStyle(
                          color: Color(0xFF97999D),
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.22,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        context.watch<GlobalVariables>().isLogviewed
                            ? "Login to your\nAccount"
                            : "Get started now",
                        style: TextStyle(
                          color: Color(0xFF1C2229),
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.34,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFFE8E9EA), width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 36,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: context.watch<GlobalVariables>().isLogviewed
                              ? Color(0xFFFFFFFF)
                              : Color(0xFFF9F9F9),
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            overlayColor: Colors.transparent,
                          ),
                          onPressed: () {
                            if (context.read<GlobalVariables>().isLogviewed ==
                                false) {
                              return context
                                  .read<GlobalVariables>()
                                  .setIsLogviewed(true);
                            }
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontWeight:
                              context.watch<GlobalVariables>().isLogviewed
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              fontSize: 16,
                              color:
                              context.watch<GlobalVariables>().isLogviewed
                                  ? Color(0xFF1C2229)
                                  : Color(0xFF97999D),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 36,
                        width: MediaQuery.of(context).size.width * 0.45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: context.watch<GlobalVariables>().isLogviewed
                              ? Color(0xFFF9F9F9)
                              : Color(0xFFFFFFFF),
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            overlayColor: Colors.transparent,
                          ),
                          onPressed: () {
                            if (context.read<GlobalVariables>().isLogviewed ==
                                true) {
                              return context
                                  .read<GlobalVariables>()
                                  .setIsLogviewed(false);
                            }
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color:
                              context.watch<GlobalVariables>().isLogviewed
                                  ? Color(0xFF97999D)
                                  : Color(0xFF1C2229),
                              fontSize: 16,
                              fontWeight:
                              context.watch<GlobalVariables>().isLogviewed
                                  ? FontWeight.w400
                                  : FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                if (!context.watch<GlobalVariables>().isLogviewed)
                  _inputField(
                    label: "Full name",
                    controller: fullNameController,
                    prefixe: true,
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Color(0xFF61AD4E),
                      size: 20,
                    ),
                  ),
                if (!context.watch<GlobalVariables>().isLogviewed)
                  _inputField(
                    label: "Email address",
                    controller: emailController,
                    prefixe: true,
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Color(0xFF61AD4E),
                      size: 20,
                    ),
                  ),
                _inputField(
                  label: context.watch<GlobalVariables>().isLogviewed
                      ? "Email address"
                      : "Phone number",
                  controller: phoneController,
                  prefixe: true,
                  prefixIcon: Icon(
                    context.watch<GlobalVariables>().isLogviewed
                        ? Icons.email
                        : Icons.phone_android_rounded,
                    color: Color(0xFF61AD4E),
                    size: 20,
                  ),
                ),
                _inputField(
                  label: context.watch<GlobalVariables>().isLogviewed
                      ? "Password"
                      : "Set password",
                  controller: passwordController,
                  prefixe: true,
                  suffixe: true,
                  obscureText: _obscurePassword,
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Color(0xFF61AD4E),
                    size: 20,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Color(0xFF61AD4E),
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                if (!context.watch<GlobalVariables>().isLogviewed)
                  _inputField(
                    label: "Confirm password",
                    controller: confirmPasswordController,
                    prefixe: true,
                    suffixe: true,
                    obscureText: _obscureConfirmPassword,
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Color(0xFF61AD4E),
                      size: 20,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        color: Color(0xFF61AD4E),
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                if (context.watch<GlobalVariables>().isLogviewed)
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Color(0xFFE8E9EA),
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Checkbox(
                                    visualDensity: VisualDensity(
                                      horizontal: -4,
                                    ),
                                    value: _rememberMe,
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value ?? false;
                                      });
                                    },
                                    activeColor: Color(0xFF61AD4E),
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Remember me",
                                style: TextStyle(
                                  color: Color(0xFF97999D),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            overlayColor: Colors.transparent,
                          ),
                          onPressed: () {
                            _showSnackBar("Forgot Password coming soon!", isError: false);
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Color(0xFF61AD4E),
                              fontSize: 12,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 46,
                  decoration: BoxDecoration(
                    color: Color(0xFF61AD4E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      overlayColor: Colors.transparent,
                    ),
                    onPressed: _isLoading
                        ? null
                        : () {
                      if (context.read<GlobalVariables>().isLogviewed) {
                        _handleLogin();
                      } else {
                        _handleRegister();
                      }
                    },
                    child: _isLoading
                        ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : Text(
                      context.watch<GlobalVariables>().isLogviewed
                          ? "Login"
                          : "Register",
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                if (context.watch<GlobalVariables>().isLogviewed)
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Expanded(child: Divider(color: Color(0xFFE8E9EA))),
                        SizedBox(width: 5),
                        Text(
                          "Or login with",
                          style: TextStyle(
                            color: Color(0xFFB9BABD),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(child: Divider(color: Color(0xFFE8E9EA))),
                      ],
                    ),
                  ),
                if (context.watch<GlobalVariables>().isLogviewed)
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 46,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFFE8E9EA), width: 1),
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        overlayColor: Colors.transparent,
                      ),
                      onPressed: () {
                        _showSnackBar("Google Sign-In coming soon!", isError: false);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/icons/google_icon.png"),
                          SizedBox(width: 10),
                          Text(
                            "Google",
                            style: TextStyle(
                              letterSpacing: -0.18,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1C2229),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Container(
                  margin: EdgeInsets.only(top: 15, bottom: 35),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "By signing up, you agree to the Terms  of Service and Data \nProcessing Agreement",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF97999D),
                          fontSize: 12,
                          letterSpacing: -1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _inputField({
  required String label,
  TextEditingController? controller,
  Widget? suffixIcon,
  Widget? prefixIcon,
  bool suffixe = false,
  bool prefixe = false,
  bool obscureText = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 10),
      Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
      ),
      const SizedBox(height: 5),
      Container(
        height: 46,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE8E9EA)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            prefixIcon: prefixe ? prefixIcon : null,
            suffixIcon: suffixe ? suffixIcon : null,
            border: InputBorder.none,
          ),
        ),
      ),
    ],
  );
}