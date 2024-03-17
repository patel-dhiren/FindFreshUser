import 'package:flutter/material.dart';

import '../../firebase/firebase_service.dart';
import '../../models/item.dart';

class ItemDetailView extends StatefulWidget {
  final Item item;

  ItemDetailView({required this.item});

  @override
  State<ItemDetailView> createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<ItemDetailView> {
  ValueNotifier<int> _quantity = ValueNotifier<int>(1); // Start with quantity 1

  @override
  void dispose() {
    _quantity.dispose();
    super.dispose();
  }

  void _addToCart() {
    // Assuming FirebaseService is initialized with a userId somewhere in your app
    FirebaseService firebaseService = FirebaseService();

    firebaseService.addToCart(widget.item, _quantity.value).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to cart successfully')),
      );
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding to cart'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Hero(
                    tag: 'imageHero${widget.item.id}',
                    child: Image.network(widget.item.imageUrl)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.item.name,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              '${widget.item.price} /${widget.item.unit}',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FloatingActionButton(
                        heroTag: 'decreaseButton${widget.item.id}',
                        onPressed: () {
                          if (_quantity.value > 1) {
                            _quantity.value--;
                          }
                        },
                        child: Icon(Icons.remove),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green,
                        mini: true,
                      ),
                      SizedBox(width: 16),
                      ValueListenableBuilder<int>(
                        valueListenable: _quantity,
                        builder: (context, value, child) => Text(
                          '$value',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 16),
                      FloatingActionButton(
                        heroTag: 'increaseButton${widget.item.id}',
                        onPressed: () {
                          _quantity.value++;
                        },
                        child: Icon(Icons.add),
                        mini: true,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green,
                      ),
                    ],
                  ),
                ),
                ValueListenableBuilder<int>(
                  valueListenable: _quantity,
                  builder: (context, value, child) => Text(
                    'Rs. ${(widget.item.price * value).toStringAsFixed(2)}',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Description',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              widget.item.description,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
          width: double.infinity,
          margin: EdgeInsets.all(16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, foregroundColor: Colors.white),
            onPressed: () {
              _addToCart();
            },
            child: Text('ADD TO CART'),
          )),
    );
  }
}
