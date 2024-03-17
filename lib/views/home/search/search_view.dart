import 'package:flutter/material.dart';
import 'package:fresh_find_user/models/category.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/constants.dart';
import '../../../firebase/firebase_service.dart';


class SearchCategoryView extends StatefulWidget {
  const SearchCategoryView({super.key});

  @override
  State<SearchCategoryView> createState() => _SearchCategoryViewState();
}

class _SearchCategoryViewState extends State<SearchCategoryView> {

  final TextEditingController _searchController = TextEditingController();
  List<Category> _searchResults = [];

  void _searchProducts(String query) async {
    if (query.isNotEmpty) {
      final results = await FirebaseService().searchCategoryByName(query);
      setState(() {
        _searchResults = results;
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  itemCount: _searchResults.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,

                      crossAxisSpacing: 8,
                      childAspectRatio: 1 / 1),
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 1,
                      color: Colors.green.shade50,
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        child: GridTile(
                          child: GestureDetector(
                            onTap: () {
                              print('item tapped');
                              Navigator.pushNamed(context, AppConstant.vendorListView, arguments: _searchResults[index]);
                            },
                            child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Image.network(
                                        _searchResults[index].imageUrl,
                                        height: 70,
                                        width: 70,
                                        color: Colors.green,
                                      ),
                                    ),
                                    SizedBox(height: 16,),
                                    Text(
                                      _searchResults[index].name,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(5.0),
      child: TextField(
        controller: _searchController,
        onChanged: _searchProducts,
        decoration: InputDecoration(
            hintText: "Search by Category",
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
      ),
    );
  }

}
