import 'package:flutter/material.dart';
import 'package:fresh_find_user/constants/constants.dart';
import 'package:shimmer/shimmer.dart';

import '../../../firebase/firebase_service.dart';
import '../../../models/item.dart';


class FavouriteView extends StatefulWidget {
  const FavouriteView({super.key});

  @override
  State<FavouriteView> createState() => _FavouriteViewState();
}

class _FavouriteViewState extends State<FavouriteView> {
  late Future<List<Item>> futureFavoriteItems;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: StreamBuilder(
            stream: FirebaseService().fetchUserFavoriteItemsStream(),
            builder: (context, snapshot) {

              if (snapshot.connectionState == ConnectionState.waiting) {
                return GridView.builder(
                  itemCount: 8,
                  // Adjust based on your placeholder count
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      mainAxisExtent: 210,
                      // Adjust size accordingly
                      crossAxisSpacing: 8,
                      childAspectRatio: 1 / 1.5),
                  itemBuilder: (context, index) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5)),
                                color: Colors.grey[300],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 10,
                                  color: Colors.grey[300],
                                ),
                                SizedBox(height: 5),
                                Container(
                                  width: double.infinity,
                                  height: 10,
                                  color: Colors.grey[300],
                                ),
                                SizedBox(height: 5),
                                Container(
                                  width: 60,
                                  height: 10,
                                  color: Colors.grey[300],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Container();
              } else if (snapshot.hasData) {
                var itemList = snapshot.data ?? [];

                List<Map<dynamic, dynamic>> favoriteItems = snapshot.data!;

                return GridView.builder(
                  itemCount: itemList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      mainAxisExtent: 210,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1 / 1.5),
                  itemBuilder: (context, index) {

                    Item item = Item.fromJson(favoriteItems[index]);

                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, AppConstant.itemView, arguments: item);
                      },
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(
                                color: Colors.grey.shade300, width: 1)),
                        color: Colors.grey.shade100,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: GridTile(
                            child: Container(
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Image.network(
                                      item.imageUrl,
                                      height: 100,
                                      width: 100,
                                    ),
                                  ),
                                  Text(
                                    item.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${item.price} /${item.unit}',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Rs. ${item.price}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: FirebaseService().getFavoriteNotifier(item.id!),
                                        builder: (context, isFavorite, _) {

                                          return InkWell(
                                            onTap: () {
                                              FirebaseService().toggleFavorite(item.id!);

                                              //FirebaseService().removeFavorite(item.id!);
                                            },
                                            child: Icon(
                                              isFavorite
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: Colors.red,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
