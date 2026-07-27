import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _rememberMe = false;

  final String _danantaraLogoUrl = 'https://i.postimg.cc/3x7HCSMZ/Danantara-Indonesia.png';
  final String _plnLogoUrl = 'https://i.postimg.cc/yNdtv2L4/PLN-Logo.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CachedNetworkImage(
                          imageUrl: _danantaraLogoUrl,
                          height: 32,
                          width: 140,
                          fit: BoxFit.contain,
                          alignment: Alignment.centerLeft,
                          placeholder: (context, url) => const SizedBox(height: 32, width: 100),
                          errorWidget: (context, url, error) => const Icon(Icons.business, size: 32),
                        ),
                        CachedNetworkImage(
                          imageUrl: _plnLogoUrl,
                          height: 28,
                          width: 80,
                          fit: BoxFit.contain,
                          alignment: Alignment.centerRight,
                          placeholder: (context, url) => const SizedBox(height: 28, width: 60),
                          errorWidget: (context, url, error) => const Icon(Icons.bolt, size: 28, color: Colors.yellow),
                        ),
                      ],
                    ),
                  ),

                  const Text(
                    'Monitoring Koper CCTV',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Divider(height: 1, color: Colors.grey.shade200),

                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Email/Username', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF444444))),
                        const SizedBox(height: 8),
                        const TextField(
                          enabled: true,
                          decoration: InputDecoration(
                            hintText: 'Masukkan email atau username',
                            hintStyle: TextStyle(fontSize: 13),
                            prefixIcon: Icon(Icons.person, size: 20),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text('Kata Sandi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF444444))),
                        const SizedBox(height: 8),
                        TextField(
                          enabled: true,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Masukkan kata sandi',
                            hintStyle: const TextStyle(fontSize: 13),
                            prefixIcon: const Icon(Icons.lock, size: 20),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _rememberMe = value ?? false;
                                    });
                                  },
                                ),
                                const SizedBox(width: 8),
                                const Text('Ingat saya', style: TextStyle(fontSize: 13, color: Color(0xFF666666))),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ForgotPasswordRequestScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Lupa Kata Sandi?',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF003D7A),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: widget.onLoginSuccess,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF003D7A),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('Masuk', style: TextStyle(fontWeight: FontWeight.w600)),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F7F5),
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                      border: Border(top: BorderSide(color: Colors.grey.shade200)),
                    ),
                    child: Center(
                      child: RichText(
                        text: const TextSpan(
                          text: 'Butuh bantuan akses? ',
                          style: TextStyle(color: Color(0xFF666666), fontSize: 12),
                          children: [
                            TextSpan(
                              text: 'Klik Disini',
                              style: TextStyle(
                                color: Color(0xFF003D7A),
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
          ),
        ),
      ),
    );
  }
}