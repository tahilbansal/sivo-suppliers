import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sivo_suppliers/common/routes/pages.dart';
import 'package:sivo_suppliers/constants/constants.dart';
import 'package:sivo_suppliers/entrypoint.dart';
import 'package:sivo_suppliers/firebase_options.dart';
import 'package:sivo_suppliers/models/environment.dart';
import 'package:sivo_suppliers/services/notification_service.dart';
import 'package:sivo_suppliers/views/auth/login_page.dart';
import 'package:sivo_suppliers/views/auth/verification_page.dart';
import 'package:sivo_suppliers/views/auth/waiting_page.dart';
import 'package:sivo_suppliers/views/order/notifications_active_order.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  print("onBackground: ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Widget defaultHome = const Login();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  await dotenv.load(fileName: Environment.fileName);
  // Check if the platform is NOT a web browser
  if (!kIsWeb) {
    await NotificationService().initialize(flutterLocalNotificationsPlugin);
  }

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    String? token = box.read('token');
    String? supplierId = box.read('supplierId');
    String? verification = box.read("verification");
    bool? emailVerification = box.read("e-verification");

    if (token == null) {
      defaultHome = const Login();
    } else if (token != null && supplierId == null) {
      defaultHome = const Login();
    } else if (token != null && emailVerification == false ||
        emailVerification == null) {
      defaultHome = const VerificationPage();
    } else if (supplierId != null && verification == "Verified") {
      defaultHome = MainScreen();
    } else if (supplierId != null && verification != "Verified") {
      defaultHome = const WaitingPage();
    }

    return ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize: const Size(428, 926),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Sivo Suppliers',
            theme: ThemeData(
              scaffoldBackgroundColor: kOffWhite,
              iconTheme: const IconThemeData(color: kDark),
              primarySwatch: Colors.grey,
            ),
            home: defaultHome,
            navigatorKey: navigatorKey,
            getPages: AppPages.routes,
            routes: {
              '/order_details_page': (context) => const NotificationOrderPage(),
            },
          );
        }
        );
  }
}
