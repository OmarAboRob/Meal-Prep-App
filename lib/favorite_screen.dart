import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:meal_prepare_app/Provider/favorite_provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {



  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    final favItems = provider.favorites;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
      Scaffold(
        backgroundColor: Color(0xffeff1f7),
        appBar: AppBar(backgroundColor:Color(0xffeff1f7) ,
          title: Text("Favorites",style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: favItems.isEmpty ? Center(child: Text("No Favorite Items",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
        ),): ListView.builder(
          itemCount: favItems.length,
          itemBuilder: (context,index){
            String fav = favItems[index];
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection("favorites").doc(fav).get(),
              builder:(context,snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data == null ){
                  return Center(
                    child: Text("Error loading Favorites"),
                  ) ;
                }
                var favItem = snapshot.data!;
                return Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 100,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(favItem['image'])
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(favItem['name'],
                                  style:TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  children: [
                                    Icon(Iconsax.flash_1,size: 16,color:Colors.grey ,),
                                    Text("${favItem['cal']} Calories",
                                      style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.grey),),
                                    SizedBox(width: 5,),
                                    Icon(Iconsax.clock,size: 16,color: Colors.grey,),
                                    SizedBox(width: 5,),
                                    Text("${favItem['time']} Min",
                                      style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.grey),),
                                  ],
                                ),


                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 50,
                      right: 35,
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            provider.toggleFavorite(favItem);
                          });
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 25,
                        ),
                      ),
                    ),

                  ],
                );
              } ,
            );
          },
        ),
      ),
    );
  }
}
