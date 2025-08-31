import 'package:commerce/admin/add_product_page.dart';
import 'package:commerce/admin/admin_home_page.dart';
import 'package:commerce/admin/admin_login.dart';
import 'package:commerce/admin/all_orders.dart';
import 'package:commerce/pages/bottom_bar.dart';
import 'package:commerce/pages/login_page.dart';
import 'package:commerce/pages/on_boarding.dart';
import 'package:commerce/pages/orders_page.dart';
import 'package:commerce/pages/product_details.dart';
import 'package:commerce/pages/profile_page.dart';
import 'package:commerce/pages/same_categories_page.dart';
import 'package:commerce/pages/sign_up_page.dart';
import 'package:commerce/services/shared_preferences_helper.dart';
import 'package:commerce/utils/go_router_refresh_stream.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
  static final kSignUpPage = '/signUpPage';
  static final kLoginpage = '/loginpage';
  static final kAdminLogin = '/adminLogin';
  static final kAdminHomePage = '/adminHomePage';
  static final kAddProductPage = '/addProductPage';
  static final kBottombar = '/bottombarScreen';
  static final kProductDetails = '/productDetails';
  static final kSameCategories = '/sameCategoriesPage';
  static final kOrdersPage = '/ordersPage';
  static final kProfilePage = '/profilePage';
  static final kAllOrders = '/allOrders';
  static final kOnBoarding = '/';

  static final router = GoRouter(
    initialLocation: kOnBoarding,
    refreshListenable: GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),
    redirect: (context, state)async {

 final prefs = SharedPreferencesHelper();
  final isAdmin = await prefs.getIsAdminLoggedIn() ?? false;

      final user = FirebaseAuth.instance.currentUser;
      final loggingIn = state.uri.toString() == kLoginpage ||
          state.uri.toString() == kSignUpPage;
      final onBoarding = state.uri.toString() == kOnBoarding;
      final adminLogin = state.uri.toString() == kAdminLogin;

   if (isAdmin) {
  // لو أدمن → يقدر يدخل أي صفحة تخص الأدمن
  final allowedAdminRoutes = [
    kAdminHomePage,
    kAddProductPage,
    kAllOrders,
  ];

  if (!allowedAdminRoutes.contains(state.uri.toString())) {
    return kAdminHomePage;
  }
  return null;
}


      if (user == null) {
        // أول مرة يفتح → Splash
        if (onBoarding) return null;
        if (adminLogin) return null;
        if (!loggingIn) return kOnBoarding;
        return null;
      }

      // لو مسجّل دخول بالفعل → يروح على BottomBar مباشرة
      if (onBoarding || loggingIn||adminLogin) return kBottombar;

      return null;
    },
    routes: [
      GoRoute(
        path: kOnBoarding,
        builder: (context, state) => OnBoarding(),
      ),
      GoRoute(
        path: kSignUpPage,
        builder: (context, state) => SignUpPage(),
      ),
      GoRoute(
        path: kLoginpage,
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: kAdminLogin,
        builder: (context, state) => AdminLogin(),
      ),
      GoRoute(
        path: kAdminHomePage,
        builder: (context, state) => AdminHomePage(),
      ),
      GoRoute(
        path: kAddProductPage,
        builder: (context, state) => AddProductPage(),
      ),
      GoRoute(
        path: kBottombar,
        builder: (context, state) => BottomBar(),
      ),
      GoRoute(
        path: kProductDetails,
        builder: (context, state) {
          final product = state.extra as Map<String, dynamic>;
          return ProductDetails(
            image: product['image'],
            name: product['name'],
            price: product['price'],
            details: product['details'],
          );
        },
      ),
      GoRoute(
        path: '$kSameCategories/:category',
        builder: (context, state) {
          final categoryName = state.pathParameters['category']!;
          return SameCategoriesPage(categoryName: categoryName);
        },
      ),
      GoRoute(
        path: kOrdersPage,
        builder: (context, state) => OrdersPage(),
      ),
      GoRoute(
        path: kProfilePage,
        builder: (context, state) => ProfilePage(),
      ),
      GoRoute(
        path: kAllOrders,
        builder: (context, state) => AllOrders(),
      ),
    ],
  );
}







// abstract class AppRouter {
//   static final kSignUpPage = '/signUpPage';
//   static final kLoginpage = '/loginpage';
//   static final kAdminLogin = '/adminLogin';
//   static final kAdminHomePage = '/adminHomePage';
//   static final kAddProductPage = '/addProductPage';
//   static final kBottombar = '/bottombarScreen';
//   static final kProductDetails = '/productDetails';
//   static final kSameCategories = '/sameCategoriesPage';
//   static final kOrdersPage = '/ordersPage';
//   static final kProfilePage = '/profilePage';
//   static final kAllOrders = '/allOrders';

//   static final router = GoRouter(
//     routes: [
//       GoRoute(
//         path: '/',
//         builder: (context, state) => OnBoarding(),
//       ),
//       GoRoute(
//         path: kSignUpPage,
//         builder: (context, state) => SignUpPage(),
//       ),
//       GoRoute(
//         path: kLoginpage,
//         builder: (context, state) => LoginPage(),
//       ),
//       GoRoute(
//         path: kAdminLogin,
//         builder: (context, state) => AdminLogin(),
//       ),
//       GoRoute(
//         path: kAdminHomePage,
//         builder: (context, state) => AdminHomePage(),
//       ),
//       GoRoute(
//         path: kAddProductPage,
//         builder: (context, state) => AddProductPage(),
//       ),
//       GoRoute(
//         path: kBottombar,
//         builder: (context, state) => BottomBar(),
//       ),
//       GoRoute(
//         path: kProductDetails,
//         builder: (context, state) {
//           final product = state.extra as Map<String, dynamic>;
//           return ProductDetails(
//             image: product['image'],
//             name: product['name'],
//             price: product['price'],
//             details: product['details'],
//           );
//         },
//       ),
//       GoRoute(
//         path: '$kSameCategories/:category',
//         builder: (context, state) {
//           final categoryName = state.pathParameters['category']!;
//           return SameCategoriesPage(categoryName: categoryName);
//         },
//       ),
//       GoRoute(
//         path: kOrdersPage,
//         builder: (context, state) => OrdersPage(),
//       ),
//       GoRoute(
//         path: kProfilePage,
//         builder: (context, state) => ProfilePage(),
//       ),
//        GoRoute(
//         path: kAllOrders,
//         builder: (context, state) => AllOrders(),
//       ),
//     ],
//   );
// }








// import 'package:e_commerce_app/screens/bottom_bar.dart';
// import 'package:e_commerce_app/screens/login_screen.dart';
// import 'package:e_commerce_app/screens/sign_up_screen.dart';
// import 'package:e_commerce_app/screens/splash_view.dart';
// import 'package:e_commerce_app/utils/go_router_refresh_stream.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:go_router/go_router.dart';

// abstract class AppRouter {
//   static const kSignUpScreen = '/signUpScreen';
//   static const kLoginScreen = '/loginScreen';
//   static const kBottombar = '/bottombarScreen';
//   static const kSplashScreen = '/';

//   static final router = GoRouter(
//     initialLocation: kSplashScreen,
//     refreshListenable: GoRouterRefreshStream(
//       FirebaseAuth.instance.authStateChanges(),
//     ),
//     redirect: (context, state) {
//       final user = FirebaseAuth.instance.currentUser;
//       final loggingIn = state.uri.toString() == kLoginScreen ||
//           state.uri.toString() == kSignUpScreen;
//       final onSplash = state.uri.toString() == kSplashScreen;

//       if (user == null) {
//         // أول مرة يفتح → Splash
//         if (onSplash) return null;
//         if (!loggingIn) return kSplashScreen;
//         return null;
//       }

//       // لو مسجّل دخول بالفعل → يروح على BottomBar مباشرة
//       if (onSplash || loggingIn) return kBottombar;

//       return null;
//     },
//     routes: [
//       GoRoute(
//         path: kSplashScreen,
//         builder: (context, state) => SplashView(),
//       ),
//       GoRoute(
//         path: kSignUpScreen,
//         builder: (context, state) => SignUpScreen(),
//       ),
//       GoRoute(
//         path: kLoginScreen,
//         builder: (context, state) => LoginScreen(),
//       ),
//       GoRoute(
//         path: kBottombar,
//         builder: (context, state) => BottomBar(),
//       ),
//     ],
//   );
// }


