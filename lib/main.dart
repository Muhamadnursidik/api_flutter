import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:api_flutter/pages/auth/login_screen.dart';
import 'package:api_flutter/pages/menu_screen.dart';
import 'package:api_flutter/services/auth_service.dart';
import 'package:intl/intl.dart';

// ✅ Fungsi main di luar class
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null); // load locale Indonesia
  runApp(const MyApp());
}

// ✅ Fungsi formatDate di luar class supaya bisa dipanggil dimana saja
String formatDate(String dateStr) {
  if (dateStr.isEmpty) return '-';
  final date = DateTime.tryParse(dateStr);
  if (date == null) return '-';
  return DateFormat('dd MMMM yyyy HH:mm', 'id').format(date);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Belajar Flutter',
      home: const AuthCheck(),
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  final AuthService _authService = AuthService();
  late Future<bool> _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = _authService.isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isLoggedIn,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData && snapshot.data == true) {
          return const MenuScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
