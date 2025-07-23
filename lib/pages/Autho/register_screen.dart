// import 'package:flutter/material.dart';
// import 'package:offlinebingo/pages/login_page.dart';
// import 'package:offlinebingo/providers/autho_provider.dart';
// import 'package:provider/provider.dart';
// import 'login_screen.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   String? error;

//   void register() {
//     final auth = Provider.of<AuthProvider>(context, listen: false);
//     final success =
//         auth.register(emailController.text, passwordController.text);
//     if (!success) {
//       setState(() {
//         error = 'Email already exists';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Register")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             if (error != null) ...[
//               Text(error!, style: const TextStyle(color: Colors.red)),
//               const SizedBox(height: 10),
//             ],
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(labelText: "Email"),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: passwordController,
//               decoration: const InputDecoration(labelText: "Password"),
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: register,
//               child: const Text("Register"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (_) => const LoginScreen()),
//                 );
//               },
//               child: const Text("Already have an account? Login"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
