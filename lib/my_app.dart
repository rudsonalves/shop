import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/pages/auth_or_home_page.dart';

import './models/auth.dart';
import './pages/product_form_page.dart';
import './pages/product_managment_page.dart';
import './pages/cart_page.dart';
import './pages/orders_page.dart';
import '../utils/app_routes.dart';
import './models/cart.dart';
import './models/order_list.dart';
import './models/product_list.dart';
import './pages/product_detail_page.dart';
import './themes/color_schemes.g.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Authentication(),
        ),
        ChangeNotifierProxyProvider<Authentication, ProductList>(
          create: (_) => ProductList(),
          update: (ctx, auth, previus) {
            return ProductList(
              auth.token ?? '',
              auth.userId ?? '',
              previus?.items ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Authentication, OrderList>(
          create: (_) => OrderList(),
          update: (context, auth, previous) {
            return OrderList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'Shop',
        theme: ThemeData(
          // useMaterial3: true,
          colorScheme: lightColorScheme,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
          ),
          fontFamily: 'Lato',
        ),
        // darkTheme: ThemeData(
        //   // useMaterial3: true,
        //   colorScheme: darkColorScheme,
        //   appBarTheme: const AppBarTheme(
        //     centerTitle: true,
        //   ),
        //   fontFamily: 'Lato',
        // ),

        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.authOrHome: (context) => const AuthOrHomePage(),
          AppRoutes.productDetail: (context) => const ProductDetailPage(),
          AppRoutes.cartRoute: (context) => const CartPage(),
          AppRoutes.orders: (context) => const OrdersPage(),
          AppRoutes.products: (context) => const ProductManagementPage(),
          AppRoutes.productForm: (context) => const ProductFormPage(),
        },
      ),
    );
  }
}
