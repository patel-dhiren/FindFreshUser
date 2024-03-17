import 'package:flutter/material.dart';
import 'package:fresh_find_user/views/home/account/account_view.dart';
import 'package:fresh_find_user/views/home/cart/cart_view.dart';
import 'package:fresh_find_user/views/home/search/search_view.dart';
import 'package:fresh_find_user/views/home/shop/shop_view.dart';

import '../../location/location_service.dart';


class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0;

  var _widgetOptions = [ShopView(),SearchCategoryView(), CartView(), AccountView()];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        indicatorColor: Colors.green.shade300,
        onDestinationSelected: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Shop',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_sharp),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Account',
          )
        ],
      ),
    );
  }
}
