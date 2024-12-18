import 'package:flutter/material.dart';
import '/main.dart';
import '../../models/products/cart_item.dart';
import '../../models/products/shop_item.dart';
import 'package:http/http.dart' as http;

class ItemView extends StatefulWidget {
  final ShopItem shopItem;

  const ItemView({super.key, required this.shopItem});

  @override
  createState() => ItemViewState();
}

class ItemViewState extends State<ItemView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.shopItem.Name)),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, top: 16.6, right: 16.0, bottom: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(widget.shopItem.ImageHref,
                          width: double.infinity,
                          height: MediaQuery.of(context).size.width / 2,
                          fit: BoxFit.cover)),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Описание",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(widget.shopItem.Description,
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(
                    height: 220,
                  )
                ],
              ),
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 60,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          appData.indexOfFavouriteItem(widget.shopItem) == -1
                              ? const Color.fromARGB(255, 83, 10, 69)
                              : const Color.fromARGB(255, 43, 4, 35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      padding: const EdgeInsets.all(10.0)),
                  child: Text(
                      appData.indexOfFavouriteItem(widget.shopItem) == -1
                          ? "Добавить в Избранное"
                          : "В Избранном",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  onPressed: () async {
                    int indexInFavourites =
                        appData.indexOfFavouriteItem(widget.shopItem);
                    if (indexInFavourites == -1) {
                      final response = await http.post(Uri(
                          scheme: "http",
                          host: appData.serverHost,
                          port: appData.serverPort,
                          path: "/favourite",
                          queryParameters: {
                            "product_id": widget.shopItem.ID.toString(),
                            "uid": appData.account!.uid
                          }));
                      if (response.statusCode == 200) {
                        setState(() {
                          appData.favouriteItems.add(widget.shopItem);
                        });
                      } else {
                        print(
                            'Failed to add to favourites: ${response.body}');
                      }
                    } else {
                      final response = await http.delete(Uri(
                          scheme: "http",
                          host: appData.serverHost,
                          port: appData.serverPort,
                          path: "/favourite",
                          queryParameters: {
                            "product_id": widget.shopItem.ID.toString(),
                            "uid": appData.account!.uid
                          }));
                      if (response.statusCode == 200) {
                        setState(() {
                          appData.favouriteItems.removeAt(indexInFavourites);
                        });
                        appData.favouriteState?.forceUpdateState();
                      } else {
                        print(
                            'Failed to remove from favourites: ${response.body}');
                      }
                    }
                  },
                ),
              )),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          (appData.indexOfCartItem(widget.shopItem) != -1)
                              ? const Color.fromARGB(255, 0, 64, 3)
                              : const Color.fromARGB(255, 0, 25, 64),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      padding: const EdgeInsets.all(10.0)),
                  child: Text(
                      (appData.indexOfCartItem(widget.shopItem) != -1)
                          ? "Добавлено - ${widget.shopItem.PriceRubles} ₽"
                          : "Добавить? - ${widget.shopItem.PriceRubles} ₽",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  onPressed: () async {
                    final response = await http.post(Uri(
                        scheme: "http",
                        host: appData.serverHost,
                        port: appData.serverPort,
                        path: "/cart",
                        queryParameters: {
                          "product_id": widget.shopItem.ID.toString(),
                          "uid": appData.account!.uid
                        }));
                    if (response.statusCode == 200) {
                      int indexInCart =
                          appData.indexOfCartItem(widget.shopItem);
                      if (indexInCart == -1) {
                        CartItem cartItem = CartItem(-1, widget.shopItem, 1);
                        setState(() {
                          appData.cartItems.add(cartItem);
                        });
                      } else {
                        final deleteResponse = await http.delete(Uri(
                            scheme: "http",
                            host: appData.serverHost,
                            port: appData.serverPort,
                            path: "/cart",
                            queryParameters: {
                              "product_id": widget.shopItem.ID.toString(),
                              "uid": appData.account!.uid
                            }));
                        if (deleteResponse.statusCode == 200) {
                          setState(() {
                            appData.cartItems.removeAt(indexInCart);
                          });
                          appData.cartState?.forceUpdateState();
                        } else {
                          print(
                              'Failed to remove from cart: ${deleteResponse.statusCode}');
                        }
                      }
                    } else {
                      print('Failed to add to cart: ${response.statusCode}');
                    }
                  },
                ),
              ))
        ]));
  }
}
