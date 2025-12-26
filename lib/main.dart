// ignore_for_file: unused_import, avoid_print, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

// 🔥 استيراد Firebase و Messaging
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

// استيراد ملفات المشروع
import 'splash_screen.dart';
import 'auth_screen.dart';
import 'theme_provider.dart';
import 'l10n/language_provider.dart';
import 'favorites_provider.dart';
import 'order_provider.dart';
import 'home_screen.dart';

// ✅ مفتاح عالمي للتحكم في التنقل (ضروري لعرض التنبيهات في أي مكان)
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// ✅ دالة التعامل مع الإشعارات في الخلفية (Background)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("🔔 إشعار في الخلفية: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // إعدادات النظام
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // تهيئة Firebase
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    // ✅ إعداد الإشعارات
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // طلب الصلاحيات
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // تفعيل استقبال الإشعارات في الخلفية
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    print('⚠️ فشل تهيئة Firebase: $e');
  }

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('ℹ️ ملاحظة: ملف .env غير موجود');
  }

  runApp(const TheVisionApp());
}

class TheVisionApp extends StatefulWidget {
  const TheVisionApp({super.key});

  @override
  State<TheVisionApp> createState() => _TheVisionAppState();
}

class _TheVisionAppState extends State<TheVisionApp> {
  @override
  void initState() {
    super.initState();
    _setupFCM();
  }

  // ✅ إعداد استماع الإشعارات
  void _setupFCM() {
    // 1. التطبيق مفتوح (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showForegroundNotification(message);
    });

    // 2. التطبيق في الخلفية وتم الضغط على الإشعار
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📩 تم فتح التطبيق من الإشعار: ${message.notification?.title}");
      // هنا يمكنك توجيه المستخدم لصفحة الطلبات مثلاً
    });
  }

  // ✅ عرض تنبيه جذاب داخل التطبيق عند وصول إشعار وهو مفتوح
  void _showForegroundNotification(RemoteMessage message) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.notifications_active, color: Colors.blueAccent),
            const SizedBox(width: 10),
            Text(message.notification?.title ?? "تنبيه جديد",
                style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(message.notification?.body ?? "",
            style: GoogleFonts.tajawal()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("حسناً",
                style: GoogleFonts.tajawal(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, child) {
          return MaterialApp(
            navigatorKey: navigatorKey, // ✅ ربط مفتاح التنقل
            title: 'مكتب الرؤية',
            theme: themeProvider.currentThemeData.copyWith(
              textTheme: GoogleFonts.tajawalTextTheme(
                themeProvider.currentThemeData.textTheme,
              ),
            ),
            debugShowCheckedModeBanner: false,
            locale: languageProvider.currentLocale,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ar', 'AE'),
              Locale('en', 'US'),
            ],
            home:
                const AuthGuard(), // ✅ استخدام الحارس للتحقق من التوكن تلقائياً
          );
        },
      ),
    );
  }
}

// ✅ حارس الحماية لتحديث التوكن تلقائياً عند الدخول
class AuthGuard extends StatelessWidget {
  const AuthGuard({super.key});

  Future<void> _updateFCMToken(String uid) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'fcmToken': token,
          'lastActive': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        print("✅ تم تحديث الـ Token بنجاح");
      }
    } catch (e) {
      print("❌ خطأ في تحديث التوكن: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData && snapshot.data != null) {
          _updateFCMToken(snapshot.data!.uid); // تحديث التوكن في الخلفية
          return const HomeScreen();
        }
        return const AuthScreen();
      },
    );
  }
}
