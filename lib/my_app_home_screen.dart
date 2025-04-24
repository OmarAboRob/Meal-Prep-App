import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:meal_prepare_app/Widget/banner.dart';
import 'package:meal_prepare_app/Widget/food_items_display.dart';
import 'package:meal_prepare_app/Widget/my_icon_button.dart';
import 'package:meal_prepare_app/view_all_items.dart';

class MyAppHomeScreen extends StatefulWidget {
  const MyAppHomeScreen({super.key});

  @override
  State<MyAppHomeScreen> createState() => _MyAppHomeScreenState();
}

class _MyAppHomeScreenState extends State<MyAppHomeScreen> {
  String category = "All";
  final CollectionReference categoriesItems =
  FirebaseFirestore.instance.collection("App-Category");

  Query get fileteredRecipes =>
      FirebaseFirestore.instance.collection("favorites").where(
        'category',
        isEqualTo: category,
      );

  Query get allRecipes => FirebaseFirestore.instance.collection("favorites");

  Query get selectedRecipes =>
      category == "All" ? allRecipes : fileteredRecipes;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xffeff1f7),
        body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "What are you\ncooking today?",
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  height: 1),
                            ),
                            Spacer(),
                            MyIconButton(
                                icon: Iconsax.notification,
                                pressed: () {
                                  setState(() {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Notifications"),
                                            content: Text("NO notifications yet"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("OK"))
                                            ],
                                          );
                                        });
                                  });
                                })
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 22),
                          child: TextField(
                            decoration: InputDecoration(
                              filled: true,
                              prefixIcon: Icon(Iconsax.search_normal),
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              hintText: "Search any recipes",
                              hintStyle: TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const BannerToExplore(),
                  const Padding(
                    padding: EdgeInsets.only(top: 20, left: 16),
                    child: Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: StreamBuilder(
                      stream: categoriesItems.snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                  streamSnapshot.data!.docs.length,
                                      (index) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        category = streamSnapshot
                                            .data!.docs[index]["name"];
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: category ==
                                            streamSnapshot.data!.docs[index]["name"]
                                            ? const Color(0xff568A9F)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      margin: EdgeInsets.only(right: 20),
                                      child: Text(
                                        streamSnapshot.data!.docs[index]["name"],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: category ==
                                              streamSnapshot
                                                  .data!.docs[index]["name"]
                                              ? Colors.white
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                          );
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 10,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          "Quick & Easy",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.1),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => ViewAllItems()));
                          },
                          child: Text(
                            "View all",
                            style: TextStyle(
                              color: Color(0xff579f8c),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  StreamBuilder(
                    stream: selectedRecipes.snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        final List<DocumentSnapshot> recipes =
                            snapshot.data?.docs ?? [];
                        return Padding(
                          padding: EdgeInsets.only(top: 5, left: 15),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: recipes
                                  .map((e) => FoodItemsDisplay(documentSnapshot: e))
                                  .toList(),
                            ),
                          ),
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ],
              ),
            )),
      ),
    );
  }
}



