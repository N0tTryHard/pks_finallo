import 'dart:convert';
import '../main.dart';
import 'user/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import '../pages/user/account.dart';
import '../pages/cart.dart';
import 'products/shop_item.dart';
import '../pages/favourite.dart';
import 'products/cart_item.dart';
import 'products/order.dart';

class GlobalData {
  List<ShopItem> shopItems = [];
  List<ShopItem> favouriteItems = [];
  List<CartItem> cartItems = [];
  List<Order> orders = [];
  User? account;
  AccountPageState? accountPageState;
  FavouriteState? favouriteState;
  MyAppState? appState;
  CartState? cartState;
  final String serverHost = "10.0.2.2";
  final int serverPort = 8080;
  Future<FirebaseApp>? firebaseInitialization;

  Future<void> fetchAllData() async {
    final servicesResponse =
        await http.get(Uri.parse("http://$serverHost:$serverPort/products"));
    List<dynamic> servicesListRaw = jsonDecode(servicesResponse.body);
    shopItems = servicesListRaw
        .map((rawObject) => ShopItem.fromJson(rawObject))
        .toList();

    if (!AuthService.isLoggedIn()) return;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final favouriteItemsResponse = await http
        .get(Uri.parse("http://$serverHost:$serverPort/favourite?uid=$uid"));
    List<dynamic> favouriteItemsRaw = jsonDecode(favouriteItemsResponse.body);
    favouriteItems = favouriteItemsRaw
        .map((rawObject) => ShopItem.fromJson(rawObject))
        .toList();

    final cartItemsResponse = await http
        .get(Uri.parse("http://$serverHost:$serverPort/cart?uid=$uid"));
    List<dynamic> cartItemsRaw = jsonDecode(cartItemsResponse.body);
    cartItems =
        cartItemsRaw.map((rawObject) => CartItem.fromJson(rawObject)).toList();

    account = FirebaseAuth.instance.currentUser;

    final ordersResponse = await http
        .get(Uri.parse("http://$serverHost:$serverPort/orders?uid=$uid"));
    List<dynamic> ordersRaw = jsonDecode(ordersResponse.body);
    orders = ordersRaw.map((rawObject) => Order.fromJson(rawObject)).toList();
    return;
  }

  int indexOfFavouriteItem(ShopItem itemToCheck) {
    for (int i = 0; i < favouriteItems.length; i++) {
      if (favouriteItems[i].ID == itemToCheck.ID) {
        return i;
      }
    }
    return -1;
  }

  int indexOfCartItem(ShopItem itemToCheck) {
    for (int i = 0; i < cartItems.length; i++) {
      if (cartItems[i].item.ID == itemToCheck.ID) {
        return i;
      }
    }
    return -1;
  }

  int indexOfShopItem(int id) {
    for (int i = 0; i < shopItems.length; i++) {
      if (shopItems[i].ID == id) {
        return i;
      }
    }
    return -1;
  }
}
