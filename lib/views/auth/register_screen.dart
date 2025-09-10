import 'package:cinemax/api/register_user.dart';
import 'package:cinemax/models/register_user_model.dart';
import 'package:cinemax/shared_preferenced/preference.dart';
import 'package:cinemax/views/auth/login_screen.dart';
import 'package:cinemax/views/forgot_password_screen.dart';
import 'package:flutter/material.dart';

class PostApiScreen extends StatefulWidget {
  const PostApiScreen({super.key});
  static const id = '/post_api_screen';

  @override
  State<PostApiScreen> createState() => _PostApiScreenState();
}

class _PostApiScreenState extends State<PostApiScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RegisterUserModel? user;
  String? errorMessage;
  bool isVisibility = false;
  bool isLoading = false;

  void registerUser() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email, Password, dan Nama tidak boleh kosong"),
        ),
      );
      setState(() => isLoading = false);
      return;
    }

    try {
      final result = await AuthenticationAPI.registerUser(
        email: email,
        password: password,
        name: name,
      );
      setState(() => user = result);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pendaftaran berhasil")));
      PreferenceHandler.saveToken(user?.data?.token.toString() ?? "");
      print(user?.toJson());
    } catch (e) {
      print(e);
      setState(() => errorMessage = e.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage.toString())));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Stack(
        children: [
          buildBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  // Logo
                  Image.asset(
                    "assets/images/logo.png",
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Register API",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Email
                  buildTitle("Email Address"),
                  const SizedBox(height: 8),
                  buildTextField(
                    hintText: "Enter your email",
                    controller: emailController,
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 16),

                  // Name
                  buildTitle("Name"),
                  const SizedBox(height: 8),
                  buildTextField(
                    hintText: "Enter your name",
                    controller: nameController,
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),

                  // Password
                  buildTitle("Password"),
                  const SizedBox(height: 8),
                  buildTextField(
                    hintText: "Enter your password",
                    controller: passwordController,
                    icon: Icons.lock,
                    isPassword: true,
                  ),
                  const SizedBox(height: 24),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Daftar",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // // Divider
                  // Row(
                  //   children: const [
                  //     Expanded(child: Divider(color: Colors.grey)),
                  //     Padding(
                  //       padding: EdgeInsets.symmetric(horizontal: 8.0),
                  //       child: Text("Or Sign In With"),
                  //     ),
                  //     Expanded(child: Divider(color: Colors.grey)),
                  //   ],
                  // ),
                  // const SizedBox(height: 16),

                  // // Google Button
                  // SizedBox(
                  //   width: double.infinity,
                  //   height: 50,
                  //   child: ElevatedButton(
                  //     onPressed: () {},
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.white,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Image.asset(
                  //           "assets/images/icon_google.png",
                  //           height: 20,
                  //           width: 20,
                  //         ),
                  //         const SizedBox(width: 8),
                  //         const Text(
                  //           "Google",
                  //           style: TextStyle(
                  //             color: Colors.black,
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 24),

                  // Already have account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("You have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreenAniFlix(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.pinkAccent,
                          ),
                        ),
                      ),
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

  // Background
  Widget buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Text Field
  Widget buildTextField({
    String? hintText,
    bool isPassword = false,
    TextEditingController? controller,
    IconData? icon,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? !isVisibility : false,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon) : null,
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isVisibility = !isVisibility;
                  });
                },
                icon: Icon(
                  isVisibility ? Icons.visibility_off : Icons.visibility,
                ),
              )
            : null,
      ),
    );
  }

  // Title
  Widget buildTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }
}
