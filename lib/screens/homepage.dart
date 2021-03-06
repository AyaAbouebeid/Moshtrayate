import 'package:flutter/material.dart';
import 'package:moshtryate_new/data/category.dart';
import 'package:moshtryate_new/data/itemscat.dart';
import 'package:moshtryate_new/models/cart.dart';
import 'package:moshtryate_new/models/category.dart';
import 'package:moshtryate_new/models/item.dart';
import 'package:provider/provider.dart';

import 'NewItem.dart';
import 'checkout.dart';
import 'drawer.dart';

class HomePage extends StatefulWidget {
  static String id = 'HomePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Item> itemsCats = items;

  final List<Item> itemsothers = [];

  int amount = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(builder: (context, cart, child) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "مشترياتي",
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  "مشترياتي",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Vibes',
                    fontSize: 25,
                  ),
                ),
                actions: [
                  Row(children: [
                    IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NewItem()));
                        }),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Image(
                                image: AssetImage('images/icons/basket1.png')),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CheckoutPage()));
                            },
                          ),
                          Text(
                            cart.count.toString(),
                          ),
                        ],
                      ),
                    ),
                  ])
                ],
                bottom: PreferredSize(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      autofocus: false,
                      decoration: InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(),
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        hintText: 'بحث',
                        fillColor: Colors.white,
                        focusColor: Colors.white,
                      ),
                      onTap: () {
                        showSearch(
                          context: context,
                          delegate: Searchbar(),
                          query: '',
                        );
                      },
                    ),
                  ),
                  preferredSize: Size(0.0, 90.0),
                ),
              ),
              drawer: MyDrawer(),
              body: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  String cat = categories[index].category;
                  List<Item> selectedItems =
                      itemsCats.where((p) => p.category.contains(cat)).toList();
                  return ExpansionTile(title: Text(cat),
                      //    trailing: Icon(Icons.keyboard_arrow_left),
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: selectedItems.length,
                          itemBuilder: (context, index) {
                            return Card(
                                child: ListTile(
                              title: Text(selectedItems[index].title),
                              leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: AssetImage(
                                      selectedItems[index].itemIcon)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.add_box),
                                      iconSize: 32,
                                      color: Colors.blue,
                                      onPressed: () {
                                        selectedItems[index].incrementCounter();

                                        return cart.add(selectedItems[index]);
                                      }),
                                  Text('${selectedItems[index].amount}'),
                                  IconButton(
                                      icon: Image(
                                          image: AssetImage(
                                              'images/icons/minus.png')),
                                      onPressed: () {
                                        selectedItems[index].decrementCounter();

                                        return cart
                                            .remove(selectedItems[index]);
                                      }),
                                  Text('${selectedItems[index].quantity}'),
                                ],
                              ),
                              onTap: () {},
                            ));
                          },
                        ),
                      ]);
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}

class Searchbar extends SearchDelegate<Item> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
            showSuggestions(context);
          }
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Item> mylist = items;
    final Item result = mylist.where((p) => p.title.contains(query)).first;
    final _formKey = GlobalKey<FormState>();
    return Consumer<Cart>(builder: (context, cart, child) {
      return Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Card(
                  child: ListTile(
                title: Text(result.title),
                leading:
                    CircleAvatar(backgroundImage: AssetImage(result.itemIcon)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: Icon(Icons.add),
                        color: Colors.blue,
                        onPressed: () {
                          result.incrementCounter();

                          return cart.add(result);
                        }),
                    Text('${result.amount}'),
                    IconButton(
                        icon: Icon(Icons.remove),
                        color: Colors.blue,
                        onPressed: () {
                          result.decrementCounter();

                          return cart.remove(result);
                        }),
                  ],
                ),
                onTap: () {
                  print('clicked');
                },
              )),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => NewItem()));
                },
                child: const Text('اضف جديد'),
              ),
            ],
          ));
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Item> mylist = items;

    mylist = query.isEmpty
        ? mylist
        : mylist.where((p) => p.title.startsWith(query)).toList();

    return mylist.isEmpty
        ? Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "...لا يوجد المنتج ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => NewItem()));
                },
                child: const Text('اضف جديد'),
              ),
            ],
          ))
        : ListView.builder(
            itemCount: mylist.length,
            itemBuilder: (context, index) {
              return ListTile(
                  onTap: () {
                    query = mylist[index].title;
                    return showResults(context);
                  },
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(mylist[index].itemIcon),
                  ),
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(mylist[index].title),
                        Text(mylist[index].category,
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ]));
            },
          );
  }
}
