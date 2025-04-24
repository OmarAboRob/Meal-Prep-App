import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:meal_prepare_app/Widget/food_items_display.dart';
import 'package:meal_prepare_app/Widget/my_icon_button.dart';

class ViewAllItems extends StatefulWidget {
  const ViewAllItems({super.key});

  @override
  State<ViewAllItems> createState() => _ViewAllItemsState();
}

class _ViewAllItemsState extends State<ViewAllItems> {
  final CollectionReference completeApp =
  FirebaseFirestore.instance.collection("favorites");
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xffeff1f7),
        appBar: AppBar(backgroundColor: Color(0xffeff1f7),
          automaticallyImplyLeading: false,// to remove the appbar back button
          elevation: 0,
          actions: [
            SizedBox(width: 15,),
            MyIconButton(
                icon: Icons.arrow_back_ios_new,
                pressed: (){
                  Navigator.pop(context);
                }
            ),
            Spacer(),
            Text("Quick & Easy",style:
            TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
            ),
            Spacer(),
            MyIconButton(
              icon: Iconsax.notification,
              pressed: (){},
            ),
            SizedBox(width: 15,),

          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(left: 15,right: 5),
          child: Column(
            children: [
              SizedBox(height: 10,),
              StreamBuilder(stream: completeApp.snapshots(),
                builder:
                    (context,
                    AsyncSnapshot<QuerySnapshot> streamSnapshot){
                  if(streamSnapshot.hasData){
                    return GridView.builder(


                      itemCount: streamSnapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.78,

                      ),
                      itemBuilder: (context,index){
                        final documentSnapshot = streamSnapshot.data!.docs[index];
                        return Column(
                          children: [
                            FoodItemsDisplay(documentSnapshot: documentSnapshot),
                            Row(children: [
                              Icon(Iconsax.star1,color: Colors.amberAccent,),
                              SizedBox(width: 5,),
                              Text(documentSnapshot['rating'],
                                style:TextStyle(
                                  fontWeight: FontWeight.bold,
                                ) ,
                              ),
                              Text("/5"),
                              SizedBox(width: 5,),
                              Text("${documentSnapshot['reviews'.toString()]} Reviews",
                                style:TextStyle(color: Colors.grey) ,
                              ),

                            ],),
                          ],
                        ) ;
                      },
                    );
                  }
                  return Center(
                      child: CircularProgressIndicator()
                  );
                },
              ),

            ],
          ),
        ),

      ),
    );
  }
}
