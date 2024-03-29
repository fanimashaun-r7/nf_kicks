// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';

// Project imports:
import 'package:nf_kicks/models/product.dart';
import 'package:nf_kicks/services/database/database_api.dart';
import 'package:nf_kicks/widgets/floating_action_button.dart';
import 'package:nf_kicks/widgets/product_card.dart';
import '../../widgets/constants.dart';

class ProductPage extends StatefulWidget {
  final String productId;
  final DatabaseApi dataStore;
  final String storeName;

  const ProductPage({
    Key key,
    @required this.productId,
    @required this.dataStore,
    @required this.storeName,
  }) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Product>(
        stream: widget.dataStore.productStream(productId: widget.productId),
        builder: (context, AsyncSnapshot<Product> snapshotData) {
          if (!snapshotData.hasData) {
            return kLoadingNoLogo;
          }
          return Scaffold(
            floatingActionButton: Builder(
              builder: (context) => nfKicksFloatingActionButton(
                fabButtonOnPress: () {
                  if (!snapshotData.data.inStock ||
                      snapshotData.data.stock == 0) {
                    _displaySnackBar(context, 'This product is out of stock');
                  } else {
                    _displaySnackBar(
                        context, 'Product was added to your cart!');

                    widget.dataStore.addToCart(
                        product: snapshotData.data,
                        quantity: quantity,
                        storeName: widget.storeName);
                  }
                },
                fabIcon: const Icon(Icons.add_shopping_cart),
              ),
            ),
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                snapshotData.data.name,
                style: GoogleFonts.permanentMarker(),
              ),
              backgroundColor: Colors.deepOrangeAccent,
            ),
            body: Builder(
              builder: (context) => SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 360,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(snapshotData.data.image),
                        ),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.deepOrangeAccent,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    snapshotData.data.name.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    "€${snapshotData.data.price.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () => {
                                      if (snapshotData.data.inStock &&
                                          snapshotData.data.stock > 0)
                                        {
                                          if (quantity < 2)
                                            {
                                              print("You can't do that too..."),
                                            }
                                          else
                                            {
                                              setState(() {
                                                quantity--;
                                              }),
                                            }
                                        }
                                      else
                                        {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'This product is not in stock!',
                                              ),
                                              duration: Duration(seconds: 1),
                                            ),
                                          ),
                                        },
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.deepOrangeAccent,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: const Center(
                                        child: Text(
                                          "-",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    snapshotData.data.inStock
                                        ? quantity.toString()
                                        : 0.toString(),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () => {
                                      if (snapshotData.data.inStock &&
                                          snapshotData.data.stock > 0)
                                        {
                                          if (quantity ==
                                              snapshotData.data.stock.toInt())
                                            {print("You can't do that...")}
                                          else
                                            {
                                              setState(() {
                                                quantity++;
                                              })
                                            },
                                        }
                                      else
                                        {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'This product is not in stock!',
                                              ),
                                              duration: Duration(seconds: 1),
                                            ),
                                          ),
                                        },
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.deepOrangeAccent,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: const Center(
                                        child: Text(
                                          "+",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "in-Stock".toUpperCase(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: const EdgeInsets.all(8),
                                    child: Center(
                                      child: Text(
                                        snapshotData.data.stock
                                            .toStringAsFixed(0),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            snapshotData.data.description,
                            style: const TextStyle(height: 1.3),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 400,
                      child: StreamBuilder<List<Product>>(
                          stream: widget.dataStore.productsStream(
                              storeId: snapshotData.data.storeId),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return kLoadingNoLogo;
                            }
                            if (!snapshot.hasData) {
                              return kLoadingNoLogo;
                            }
                            return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                if (snapshot.data[index].id ==
                                    snapshotData.data.id) {
                                  return Container();
                                } else {
                                  return GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductPage(
                                          productId: snapshot.data[index].id,
                                          dataStore: widget.dataStore,
                                          storeName: widget.storeName,
                                        ),
                                      ),
                                    ),
                                    child: productCard(
                                        productName: snapshot.data[index].name,
                                        productPrice:
                                            snapshot.data[index].price,
                                        productImage:
                                            snapshot.data[index].image,
                                        productStock:
                                            snapshot.data[index].stock),
                                  );
                                }
                              },
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

void _displaySnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(content: Text(text));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
