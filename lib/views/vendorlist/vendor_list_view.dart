import 'package:flutter/material.dart';
import 'package:fresh_find_user/firebase/firebase_service.dart';
import 'package:fresh_find_user/models/vendor.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants/constants.dart';
import '../../location/location_service.dart';
import '../../models/category.dart';
import '../../models/vendor_item.dart';

class VendorListView extends StatefulWidget {
  Category category;

  VendorListView(this.category);

  @override
  State<VendorListView> createState() => _VendorListViewState();
}

class _VendorListViewState extends State<VendorListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
      ),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: FutureBuilder(
          future: FirebaseService().getVendorsByCategoryId(widget.category.id!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildVendorsShimmer();
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              List<Vendor> vendorList = snapshot.data ?? [];

              if (vendorList.isNotEmpty) {
                return _buildVendorView(vendorList);
              } else {
                return Center(
                  child: Text('No Vendor Found'),
                );
              }
            } else {
              return Container();
            }
          },
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

  Widget _buildVendorView(List<Vendor> vendors) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: vendors.length,
      itemBuilder: (context, index) {
        var vendor = vendors[index];

        if (vendor.city.toLowerCase().trim() !=
            LocationService.cityName?.toLowerCase().trim()){
          return Container();
        }

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppConstant.vendorDetailView,
                arguments: VendorItem(
                    category: widget.category, vendor: vendor));
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
