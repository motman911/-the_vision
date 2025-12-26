// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme_provider.dart';
import 'l10n/language_provider.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>['email']);

  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  var _isLogin = true;
  var _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';

  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  // ignore: unused_field
  final bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  Future<void> _updateFCMToken(String uid) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'fcmToken': token,
          'lastActive': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint("FCM Token Error: $e");
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  Future<void> _submit(LanguageProvider lang) async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);
    try {
      UserCredential userCredential;
      if (_isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: _userEmail.trim(), password: _userPassword.trim());
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: _userEmail.trim(), password: _userPassword.trim());
        if (userCredential.user != null) {
          await userCredential.user!.updateDisplayName(_userName);
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'name': _userName,
            'email': _userEmail.trim(),
            'role': 'user',
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
      if (userCredential.user != null) {
        await _updateFCMToken(userCredential.user!.uid);
      }
      if (mounted) _navigateToHome();
    } on FirebaseAuthException catch (e) {
      _showErrorSnackBar(e.message ?? "Authentication Error");
    } catch (e) {
      _showErrorSnackBar(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ✅ التعديل هنا: حفظ بيانات المستخدم عند الدخول بجوجل
  Future<void> _googleSignInProcess(LanguageProvider lang) async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      // 🛑 هنا الإصلاح: التحقق من وجود الملف وإنشاؤه إذا لم يكن موجوداً
      if (user != null) {
        final userDocRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        final docSnapshot = await userDocRef.get();

        if (!docSnapshot.exists) {
          await userDocRef.set({
            'name': user.displayName ?? 'No Name',
            'email': user.email,
            'role': 'user', // رتبة افتراضية
            'createdAt': FieldValue.serverTimestamp(),
            'lastActive': FieldValue.serverTimestamp(),
          });
        }

        // تحديث التوكن
        await _updateFCMToken(user.uid);
      }

      if (mounted) _navigateToHome();
    } catch (e) {
      _showErrorSnackBar(lang.googleSignInError);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _loginAsGuest(LanguageProvider lang) async {
    setState(() => _isLoading = true);
    try {
      await _auth.signInAnonymously();
      if (mounted) _navigateToHome();
    } catch (e) {
      _showErrorSnackBar(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message, style: GoogleFonts.tajawal()),
        backgroundColor: Colors.red));
  }

  void _showForgotPasswordDialog(LanguageProvider lang) {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(lang.forgotPasswordTitle, style: GoogleFonts.tajawal()),
        content: TextField(controller: emailController),
        actions: [
          ElevatedButton(
              onPressed: () => _resetPassword(emailController.text, lang),
              child: Text(lang.send))
        ],
      ),
    );
  }

  Future<void> _resetPassword(String email, LanguageProvider lang) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(lang.resetLinkSent), backgroundColor: Colors.green));
    } catch (e) {
      _showErrorSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final lang = Provider.of<LanguageProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // الخلفية الثابتة
          Positioned.fill(
            child: Image.asset('assets/images/Nature_3.jpg', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),

          // CustomScrollView لإصلاح مشاكل التمرير والارتفاع
          CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 1. زر اللغة
                      SafeArea(
                        bottom: false,
                        child: Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: TextButton.icon(
                            onPressed: () => lang.changeLanguage(lang.isArabic
                                ? const Locale('en')
                                : const Locale('ar')),
                            icon: const Icon(Icons.language,
                                color: Colors.white, size: 18),
                            label: Text(lang.currentLanguageName,
                                style:
                                    GoogleFonts.tajawal(color: Colors.white)),
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap),
                          ),
                        ),
                      ),

                      // 2. الشعار والعنوان
                      Flexible(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedBuilder(
                              animation: _logoController,
                              builder: (context, child) {
                                return Container(
                                  height: size.height * 0.12,
                                  width: size.height * 0.12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.primaryColor.withOpacity(
                                            0.5 + (0.3 * _logoAnimation.value)),
                                        blurRadius:
                                            20 + (10 * _logoAnimation.value),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.asset('assets/images/icon.png',
                                        fit: BoxFit.contain),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 15),
                            Text(
                              lang.isArabic ? 'مكتب الرؤية' : 'The Vision',
                              style: GoogleFonts.tajawal(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  const Shadow(
                                      color: Colors.black45, blurRadius: 10)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 3. صندوق التسجيل
                      Flexible(
                        flex: 6,
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 25),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.2)),
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _isLogin
                                            ? lang.login
                                            : lang.createAccount,
                                        style: GoogleFonts.tajawal(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 20),
                                      if (!_isLogin) ...[
                                        _buildCompactField(
                                          key: 'username',
                                          hint: lang.fullName,
                                          icon: Icons.person_outline,
                                          onSaved: (v) => _userName = v!,
                                          validator: (v) =>
                                              (v == null || v.length < 3)
                                                  ? "!"
                                                  : null,
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                      _buildCompactField(
                                        key: 'email',
                                        hint: lang.email,
                                        icon: Icons.email_outlined,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        onSaved: (v) => _userEmail = v!,
                                        validator: (v) =>
                                            (v == null || !v.contains('@'))
                                                ? "!"
                                                : null,
                                      ),
                                      const SizedBox(height: 10),
                                      _buildCompactField(
                                        key: 'password',
                                        hint: lang.password,
                                        icon: Icons.lock_outline,
                                        obscure: _obscurePassword,
                                        controller: _passwordController,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                              _obscurePassword
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.white70,
                                              size: 20),
                                          onPressed: () => setState(() =>
                                              _obscurePassword =
                                                  !_obscurePassword),
                                        ),
                                        onSaved: (v) => _userPassword = v!,
                                        validator: (v) =>
                                            (v == null || v.length < 6)
                                                ? "!"
                                                : null,
                                      ),
                                      if (_isLogin)
                                        Align(
                                          alignment:
                                              AlignmentDirectional.centerEnd,
                                          child: TextButton(
                                            onPressed: () =>
                                                _showForgotPasswordDialog(lang),
                                            style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                minimumSize: const Size(0, 0),
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap),
                                            child: Text(
                                              lang.forgotPassword,
                                              style: GoogleFonts.tajawal(
                                                  color: Colors.white70,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      const SizedBox(height: 15),
                                      if (_isLoading)
                                        const CircularProgressIndicator(
                                            color: Colors.white)
                                      else
                                        SizedBox(
                                          width: double.infinity,
                                          height: 45,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  theme.primaryColor,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              elevation: 3,
                                            ),
                                            onPressed: () => _submit(lang),
                                            child: Text(
                                              _isLogin
                                                  ? lang.login
                                                  : lang.signUp,
                                              style: GoogleFonts.tajawal(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      const SizedBox(height: 10),
                                      GestureDetector(
                                        onTap: () => setState(
                                            () => _isLogin = !_isLogin),
                                        child: Text(
                                          _isLogin
                                              ? lang.dontHaveAccount
                                              : lang.alreadyHaveAccount,
                                          style: GoogleFonts.tajawal(
                                              color: Colors.white,
                                              fontSize: 13,
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 4. أزرار إضافية
                      Flexible(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 45,
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.white30),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  backgroundColor:
                                      Colors.white.withOpacity(0.08),
                                ),
                                icon: Image.network(
                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
                                    height: 20),
                                label: Text(lang.signInGoogle,
                                    style: GoogleFonts.tajawal(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                                onPressed: () => _googleSignInProcess(lang),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed:
                                  _isLoading ? null : () => _loginAsGuest(lang),
                              child: Text(lang.skipGuest,
                                  style: GoogleFonts.tajawal(
                                      color: Colors.white70, fontSize: 14)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactField({
    required String key,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextEditingController? controller,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      key: ValueKey(key),
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
      style: GoogleFonts.tajawal(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white60, fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.white70, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white70)),
        errorStyle: const TextStyle(height: 0, color: Colors.transparent),
      ),
    );
  }
}
