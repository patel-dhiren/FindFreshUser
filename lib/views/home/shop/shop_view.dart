import 'package:flutter/material.dart';
import 'package:fresh_find_user/constants/constants.dart';
import 'package:fresh_find_user/models/vendor_item.dart';
import 'package:shimmer/shimmer.dart';

import '../../../firebase/firebase_service.dart';
import '../../../location/location_service.dart';
import '../../../models/category.dart';
import '../../../models/vendor.dart';
// Update with actual path

class ShopView extends StatefulWidget {
  const ShopView({Key? key}) : super(key: key);

  @override
  _ShopViewState createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {
  String? selectedCategoryId;
  List<Category> categories = [];
  List<Vendor> vendors = [];
  bool isLoadingCategories = true;
  bool isLoadingVendors = false;
  Category? selectedCategory;
  String? _error; // For storing error messages
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  _initialize() async {
    try {
      await LocationService.getCurrentLocation();
      // Only proceed if the city name is available
      if (LocationService.cityName != null) {
        print('CITY : ${LocationService.cityName}');
        fetchCategories();
      } else {
        setState(() {
          _error =
              "City not found. Please ensure location services are enabled.";
          isLoadingCategories = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        isLoadingCategories = false;
      });
    }
  }

  fetchCategories() async {
    categories = await FirebaseService().getCategoriesOnce();
    if (mounted) {
      setState(() {
        isLoadingCategories = false;
        // Check if categories list is not empty before selecting the first category
        if (categories.isNotEmpty) {
          selectedCategoryId =
              categories[0].id; // Select the first category by default
          fetchVendors(selectedCategoryId!);
          selectedCategory =
              categories[0]; // Fetch vendors for the selected category
        }
      });
    }
  }

  fetchVendors(String categoryId) async {
    setState(() {
      isLoadingVendors = true;
    });
    vendors = await FirebaseService().getVendorsByCategoryId(categoryId);
    if (mounted) {
      setState(() {
        isLoadingVendors = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                const SizedBox(height: 12),
                if (_error != null)
                  _buildErrorView(_error!), // Display error with a retry option
                if (_error == null) ...[
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  isLoadingCategories
                      ? _buildCategoriesShimmer()
                      : _buildHorizontalListView(),
                  const SizedBox(height: 12),
                  Text(
                    'Top Vendors For You (${LocationService.cityName ?? ''})',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  selectedCategoryId != null
                      ? (isLoadingVendors
                          ? _buildVendorsShimmer()
                          : _buildVendorView())
                      : Container(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVendorsShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(
          5,
          (index) => // Arbitrary number of shimmer items
              Container(
            height: 120, // Arbitrary height for vendor item
            margin: EdgeInsets.only(bottom: 8),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesShimmer() {
    return Container(
      height: 80,
      alignment: Alignment.centerLeft,
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5, // Arbitrary number of shimmer items
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 120,
                height: 20,
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppConstant.searchView);
      },
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.circular(5.0),
        child: const TextField(
          showCursor: false,
          enabled: false,
          decoration: InputDecoration(
            hintText: "Search for products",
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 13),
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalListView() {
    return Container(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ChoiceChip(
            label: Text(category.name),
            selected: category.id == selectedCategoryId,
            onSelected: (bool selected) {
              setState(() {
                selectedCategory = category;
                selectedCategoryId = category.id;
              });
              fetchVendors(selectedCategoryId!);
            },
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 8,
          );
        },
      ),
    );
  }

  Widget _buildErrorView(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(errorMessage),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isLoadingCategories = true;
                _error = null;
              });
              _initialize(); // Retry initializing
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildVendorView() {
    return isLoadingVendors
        ? CircularProgressIndicator()
        : ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: vendors.length,
            itemBuilder: (context, index) {
              var vendor = vendors[index];

              if (vendor.city.toLowerCase().trim() !=
                  LocationService.cityName?.toLowerCase().trim()) {
                return Container();
              }

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppConstant.vendorDetailView,
                      arguments: VendorItem(
                          category: selectedCategory!, vendor: vendor));
                },
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3)),
                  color: Colors.grey.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              vendor.profileImage!,
                              height: 100,
                              width: 100,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    vendor.businessName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  Text(
                                    vendor.vendorName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  Text(
                                    "location : ${vendor.city}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
