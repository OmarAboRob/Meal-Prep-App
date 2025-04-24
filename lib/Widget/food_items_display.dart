import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:meal_prepare_app/Provider/favorite_provider.dart';
import 'package:meal_prepare_app/recipe_detail_screen.dart';

class FoodItemsDisplay extends StatelessWidget {
  final DocumentSnapshot <Object?> documentSnapshot;
  const FoodItemsDisplay({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> RecipeDetailScreen(documentSnapshot: documentSnapshot,),
        ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 10,),
        width: 230,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: documentSnapshot['image'],
                  child: Container(
                    width: double.infinity,height: 160,
                    decoration:
                    BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          fit:BoxFit.cover,
                          image: NetworkImage(documentSnapshot['image']),)
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Text(documentSnapshot['name'],style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Icon(Iconsax.flash_1,size: 16,color:Colors.grey ,),
                    Text("${documentSnapshot['cal']} Calories",
                      style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.grey),),
                    SizedBox(width: 5,),
                    Icon(Iconsax.clock,size: 16,color: Colors.grey,),
                    SizedBox(width: 5,),
                    Text("${documentSnapshot['time']} Min",
                      style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.grey),),


                  ],
                ),

              ],),
            // Fav button
            Positioned(
              top: 5,
              right: 5,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: InkWell(onTap: (){
                  provider.toggleFavorite(documentSnapshot);
                },
                  child: Icon(
                    provider.isExist(documentSnapshot)?
                    Iconsax.heart5:Iconsax.heart,
                    color: provider.isExist(documentSnapshot)
                        ? Colors.red
                        : Colors.black,size: 20,),),
              ),),

          ],
        ),

      ),
    );
  }
}
