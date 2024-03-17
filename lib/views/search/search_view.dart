import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/constants.dart';
import '../../../firebase/firebase_service.dart';
import '../../location/location_service.dart';
import '../../models/item.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {

  final TextEditingController _searchController = TextEditingController();
  List<Item> _searchResults = [];

  void _searchProducts(String query) async {
    if (query.isNotEmpty) {
      final results = await FirebaseService().searchItemByName(query);
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
                      mainAxisExtent: 210,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1 / 1.5),
                  itemBuilder: (context, index) {

                    if (_searchResults[index].city.toLowerCase().trim() !=
                        LocationService.cityName?.toLowerCase().trim()){
                      return Container();
                    }

                    return Card(
                      elevation: 1,
                      color: Colors.white,
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        child: GridTile(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, AppConstant.itemView, arguments: _searchResults[index]);
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
                                        height: 100,
                                        width: 100,
                                      ),
                                    ),
                                    Text(
                                      _searchResults[index].vendorBusinessName,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      _searchResults[index].name,
                                      style:
                                      TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Rs. ${_searchResults[index].price}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    )
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
            hintText: "Type here..",
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
      ),
    );
  }



}
