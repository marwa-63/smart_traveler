import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'register_screen.dart';
// import 'home_screen.dart'; // ← هتعمله بعدين

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscurePassword = true;

  // ─── ألوان التطبيق ───────────────────────────────
  static const Color kBlue = Color(0xFF29B6F6);
  static const Color kDark = Color(0xFF111111);
  static const Color kGrey = Color(0xFF888888);
  static const Color kBorder = Color(0xFFE0E0E0);
  static const Color kBg = Color(0xFFF8FBFF);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ─── Login بالإيميل والباسورد ─────────────────────
  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        _showSuccessSnackBar('you loggid in succesfully✅');
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) _showErrorSnackBar(_getErrorMessage(e.code));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ─── Login بـ Google ──────────────────────────────
  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (mounted) {
        _showSuccessSnackBar( 'you logged in with google ✅');
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    } catch (e) {
      if (mounted) _showErrorSnackBar('log in with google failed');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ─── رسائل الخطأ ──────────────────────────────────
  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'user not found';
      case 'wrong-password':
        return 'wrong password';
      case 'invalid-email':
        return 'invalid email';
      case 'user-disabled':
        return 'user-disabled';
      case 'too-many-requests':
        return 'too many requests';
      default:
        return 'error happend,try again';
    }
  }

  void _showErrorSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccessSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // ── Logo ──────────────────────────────
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: kDark,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.bolt,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Title ─────────────────────────────
                const Center(
                  child: Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: kDark,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                const Center(
                  child: Text(
                    'Log in to continue planning your\nnext great adventure.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: kGrey,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                // ── Email Field ───────────────────────
                const Text(
                  'Email Address',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: kDark,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration(
                    hint: 'name@example.com',
                    icon: Icons.email_outlined,
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'ادخل الإيميل';
                    if (!v.contains('@')) return 'إيميل غير صحيح';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ── Password Field ────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: kDark,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {}, // TODO: Forgot Password screen
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontSize: 13,
                          color: kBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: _inputDecoration(
                    hint: 'Enter your password',
                    icon: Icons.lock_outline,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: kGrey,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter your password';
                    if (v.length < 6) return 'password length less than 6';
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // ── Login Button ──────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kBlue,
                      foregroundColor: kDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                        : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Divider ───────────────────────────
                Row(
                  children: [
                    const Expanded(child: Divider(color: kBorder)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'OR CONTINUE WITH',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade400,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: kBorder)),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Google Button ─────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _signInWithGoogle,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: kBorder, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google Icon (بالألوان)
                        _GoogleIcon(),
                        const SizedBox(width: 10),
                        const Text(
                          'Continue with Google',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: kDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // ── Register Link ─────────────────────
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(fontSize: 14, color: kGrey),
                        children: [
                          TextSpan(
                            text: 'Create account',
                            style: TextStyle(
                              color: kBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 15),
      prefixIcon: Icon(icon, color: const Color(0xFFAAAAAA), size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF29B6F6), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }
}

// ── Google Icon Widget ────────────────────────────────
class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    // Background circle
    final bgPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx, cy), r, bgPaint);

    // Draw G letter segments using arcs and rectangles
    final red = Paint()..color = const Color(0xFFEA4335);
    final blue = Paint()..color = const Color(0xFF4285F4);
    final yellow = Paint()..color = const Color(0xFFFBBC05);
    final green = Paint()..color = const Color(0xFF34A853);

    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.85);

    // Top red arc
    canvas.drawArc(rect, -2.3, 1.2, false, red..strokeWidth = r * 0.28 ..style = PaintingStyle.stroke);
    // Right blue arc
    canvas.drawArc(rect, -1.1, 1.57, false, blue..strokeWidth = r * 0.28 ..style = PaintingStyle.stroke);
    // Bottom green arc
    canvas.drawArc(rect, 0.47, 1.4, false, green..strokeWidth = r * 0.28 ..style = PaintingStyle.stroke);
    // Left yellow arc
    canvas.drawArc(rect, 1.87, 1.5, false, yellow..strokeWidth = r * 0.28 ..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(_) => false;
}