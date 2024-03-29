// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';

// Project imports:
import 'package:nf_kicks/models/cart_item.dart';
import 'package:nf_kicks/models/store.dart';
import 'package:nf_kicks/pages/payment/payment_button.dart';
import 'package:nf_kicks/services/database/database_api.dart';
import 'package:nf_kicks/widgets/product_card.dart';
import '../../widgets/constants.dart';

class CartPage extends StatelessWidget {
  final DatabaseApi dataStore;

  const CartPage({Key key, this.dataStore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Store>>(
      stream: dataStore.storesStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return kLoadingLogo;
        }

        if (!snapshot.hasData) {
          return kLoadingLogo;
        }

        return DefaultTabController(
          length: snapshot.data.length,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Cart",
                style: GoogleFonts.permanentMarker(),
              ),
              bottom: TabBar(
                indicatorColor: Colors.white,
                isScrollable: true,
                tabs: [
                  for (final tab in snapshot.data)
                    Tab(
                      child: Text(tab.name),
                    ),
                ],
              ),
              backgroundColor: Colors.deepOrangeAccent,
            ),
            body: TabBarView(
              children: [
                for (final tab in snapshot.data)
                  StreamBuilder<List<CartItem>>(
                    stream: dataStore.storeCartStream(storeCartName: tab.name),
                    builder:
                        (context, AsyncSnapshot<List<CartItem>> snapshotData) {
                      double _totalPrice = 0;
                      List<Map<String, dynamic>> _productListMap =
                          <Map<String, dynamic>>[];

                      if (snapshotData.hasError) {
                        return kLoadingNoLogo;
                      }
                      if (!snapshotData.hasData) {
                        return kLoadingNoLogo;
                      }

                      snapshotData.data.forEach((CartItem cartItem) {
                        _totalPrice += cartItem.price;
                        _productListMap.add(cartItem.toMap());
                      });

                      return ListView.builder(
                        itemCount: snapshotData.data.length,
                        itemBuilder: (context, index) {
                          if (snapshotData.data.isNotEmpty) {
                            if (index == 0) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  PaymentsButton(
                                      totalPrice: _totalPrice,
                                      dataStore: dataStore,
                                      productListMap: _productListMap,
                                      currentTabName: tab.name),
                                  dismissibleProductCard(
                                    context,
                                    snapshotData.data[index].id,
                                    dataStore,
                                    tab.name,
                                    snapshotData.data[index].productId,
                                    snapshotData.data[index].name,
                                    snapshotData.data[index].price,
                                    snapshotData.data[index].quantity,
                                    snapshotData.data[index].image,
                                  ),
                                ],
                              );
                            }
                            return dismissibleProductCard(
                              context,
                              snapshotData.data[index].id,
                              dataStore,
                              tab.name,
                              snapshotData.data[index].productId,
                              snapshotData.data[index].name,
                              snapshotData.data[index].price,
                              snapshotData.data[index].quantity,
                              snapshotData.data[index].image,
                            );
                          } else {
                            return kLoadingNoLogo;
                          }
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
