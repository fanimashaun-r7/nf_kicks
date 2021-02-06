import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:nf_kicks/models/product.dart';

import 'package:nf_kicks/pages/cart/cart_page.dart';
import 'package:nf_kicks/pages/landing/landing_map.dart';
import 'package:nf_kicks/pages/orders/orders_page.dart';
import 'package:nf_kicks/pages/profile/profile_page.dart';
import 'package:nf_kicks/pages/something_went_wrong_page.dart';
import 'package:nf_kicks/pages/store/product_page.dart';
import 'package:nf_kicks/services/authentication/authentication_api.dart';
import 'package:nf_kicks/services/database/database_api.dart';
import 'package:nf_kicks/utils/common_functions.dart';
import 'package:nf_kicks/widgets/product_card.dart';
import 'package:nf_kicks/widgets/show_alert_dialog.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  static const String id = 'landing_screen';

  final String uid;
  final AuthenticationApi authenticationApi;
  final bool connectionStatus;
  final bool jailbreakOrRootStatus;

  const LandingPage(
      {Key key,
      this.authenticationApi,
      this.uid,
      @required this.connectionStatus,
      @required this.jailbreakOrRootStatus})
      : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedItemPosition = 2;

  Future<void> _showLogoutDialog(BuildContext context) async {
    final logoutDialog = await showAlertDialog(context,
        title: 'Logout',
        description: 'Are you sure you want to logout?',
        cancelBtn: 'Cancel',
        actionBtn: 'Logout');
    if (logoutDialog == true) {
      CommonFunctions.logOut(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void readNFCProductTag(DatabaseApi databaseApi) {
    FlutterNfcReader.onTagDiscovered().listen((onData) async {
      String productCode = onData.content;
      Product productStream =
          await databaseApi.nfcProductStream(nfcCode: productCode).first;
      String storeName =
          await databaseApi.storeName(storeId: productStream.storeId).first;
      changePageForNFC(ProductPage(
        dataStore: databaseApi,
        productId: productStream.id,
        storeName: storeName,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DatabaseApi>(context, listen: false);
    final auth = Provider.of<AuthenticationApi>(context, listen: false);

    readNFCProductTag(database);

    if (_selectedItemPosition == 4) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showLogoutDialog(context);
      });
    }
    if (_selectedItemPosition == 3) {
      changePage(ProfilePage(
        dataStore: database,
        authenticationApi: auth,
      ));
    }
    if (_selectedItemPosition == 1) {
      changePage(OrdersPage(
        dataStore: database,
      ));
    }
    if (_selectedItemPosition == 0) {
      changePage(CartPage(
        dataStore: database,
      ));
    }
    return widget.connectionStatus && !widget.jailbreakOrRootStatus
        ? Scaffold(
            body: Stack(
              children: [
                LandingMap(),
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/logo.png",
                              scale: 7,
                            ),
                          ],
                        ),
                      ),
                      landingBottomAppBar(),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : SomethingWentWrong();
  }

  Expanded landingBottomAppBar() {
    return Expanded(
      flex: 10,
      child: SnakeNavigationBar.color(
        snakeViewColor: Colors.deepOrangeAccent,
        unselectedItemColor: Colors.deepOrangeAccent,
        selectedItemColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20),
        elevation: 2.0,
        behaviour: SnakeBarBehaviour.floating,
        snakeShape: SnakeShape.circle,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        currentIndex: _selectedItemPosition,
        onTap: (index) => setState(() => _selectedItemPosition = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
          )
        ],
      ),
    );
  }

  void changePage(Widget pageToNavigateTo) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => pageToNavigateTo,
        ),
      );
    });
  }

  void changePageForNFC(Widget pageToNavigateTo) {
    if (this.mounted)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => pageToNavigateTo,
        ),
      );
  }
}
