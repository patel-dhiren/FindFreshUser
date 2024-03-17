import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fresh_find_user/models/category.dart';
import 'package:fresh_find_user/models/vendor_item.dart';
import 'package:fresh_find_user/views/vendor_detail/vendor_detail_view.dart';
import 'package:fresh_find_user/views/vendorlist/vendor_list_view.dart';


import '../constants/constants.dart';
import '../models/item.dart';
import '../models/order_data.dart';
import '../models/user_data.dart';

import '../views/address/address_view.dart';
import '../views/address_list/address_list_view.dart';
import '../views/checkout/checkout_view.dart';
import '../views/home/home_view.dart';

import '../views/item_detail/item_detail_view.dart';
import '../views/login/login_view.dart';
import '../views/my_cart/my_cart_view.dart';
import '../views/orderlist/orderlist_view.dart';
import '../views/profile_update/profile_update_view.dart';
import '../views/search/search_view.dart';
import '../views/splash/splash_view.dart';
import '../views/user_detail/user_detail_view.dart';
import '../views/verification/verification_view.dart';

class AppRoute {

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstant.splashView:
        return MaterialPageRoute(
          builder: (context) => SplashView(),
        );
      case AppConstant.loginView:
        return MaterialPageRoute(
          builder: (context) => LoginView(),
        );
      case AppConstant.verificationView:

        String mobileNumber = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => VerificationView(mobileNumber: mobileNumber,),
        );

      case AppConstant.userDetailView:

        UserCredential user = settings.arguments as UserCredential;
        return MaterialPageRoute(
          builder: (context) => UserDetailView(credential: user,),
        );

      case AppConstant.homeView:
        return MaterialPageRoute(
          builder: (context) => DashboardView(),
        );

      case AppConstant.profileUpdateView:

        UserData user = settings.arguments as UserData;

        return MaterialPageRoute(
          builder: (context) => ProfileUpdateView(user),
        );

        case AppConstant.vendorDetailView:

        VendorItem item = settings.arguments as VendorItem;

        return MaterialPageRoute(
          builder: (context) => VendorDetailView(item),
        );

      case AppConstant.itemView:

        Item item = settings.arguments as Item;

        return MaterialPageRoute(
          builder: (context) => ItemDetailView(item: item,),
        );

      case AppConstant.searchView:

        return MaterialPageRoute(
          builder: (context) => SearchView(),
        );

      case AppConstant.vendorListView:

        Category item = settings.arguments as Category;

        return MaterialPageRoute(
          builder: (context) => VendorListView(item),
        );

      case AppConstant.checkoutView:

        return MaterialPageRoute(
          builder: (context) => CheckOutView(),
        );

      case AppConstant.myCartView:

        return MaterialPageRoute(
          builder: (context) => MyCartView(),
        );

      case AppConstant.addressListView:

        OrderData data = settings.arguments as OrderData;

        return MaterialPageRoute(
          builder: (context) => ListAddressesPage(data: data),
        );

      case AppConstant.addressView:

        return MaterialPageRoute(
          builder: (context) => AddAddressPage(),
        );

      case AppConstant.orderListView:

        return MaterialPageRoute(
          builder: (context) => OrderListView(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => SplashView(),
        );
    }
  }
}
