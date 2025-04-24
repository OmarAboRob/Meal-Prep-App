import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:meal_prepare_app/Provider/favorite_provider.dart';
import 'package:meal_prepare_app/Provider/quantity.dart';
import 'package:meal_prepare_app/Widget/my_icon_button.dart';
import 'package:meal_prepare_app/Widget/quantity_increment_decrement.dart';
import 'package:provider/provider.dart';

class RecipeDetailScreen extends StatefulWidget {
  final DocumentSnapshot<Object?> documentSnapshot;
  const RecipeDetailScreen({super.key, required this.documentSnapshot});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  void initState() {
    // TODO: implement initState
    List<double> base =widget.documentSnapshot['ingrediantamount'].
    map<double>((amount)=>double.parse(amount.toString())).toList();
    Provider.of<QuantityProvider>(context,listen: false).setBase(base);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    final quantityProvider = Provider.of<QuantityProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton.extended(
          onPressed:(){},
          backgroundColor: Colors.transparent,
          elevation: 0,
          label:Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff568A9F),
                  padding: EdgeInsets.symmetric(horizontal: 100,vertical: 13),
                  foregroundColor: Colors.white,

                ),
                onPressed: (){}, child: Text("Start Cooking",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),
              ),
              ),
              SizedBox(width: 10,),
              IconButton(
                style: IconButton.styleFrom(
                  shape: CircleBorder(
                    side: BorderSide(
                      color: Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                ),
                onPressed: (){
                  setState(() {
                    provider.toggleFavorite(widget.documentSnapshot);
                  });
                },
                icon: Icon(
                  provider.isExist(widget.documentSnapshot)?
                  Iconsax.heart5:
                  Iconsax.heart,
                  color:provider.isExist(widget.documentSnapshot)?
                  Colors.red:
                  Colors.black,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child:Column(
            children: [
              Stack(
                children: [
                  Hero(
                    tag: widget.documentSnapshot['image'],
                    child: Container(
                      height: MediaQuery.of(context).size.height/2.1,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.documentSnapshot['image'],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 10,
                    right: 10,
                    child: Row(
                      children: [
                        MyIconButton(icon: Icons.arrow_back_ios_new, pressed:(){
                          setState(() {
                            Navigator.pop(context);
                          });
                        } ),
                        Spacer(),
                        MyIconButton(icon: Iconsax.notification,
                            pressed:(){}
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: MediaQuery.of(context).size.width,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.white,
                        borderRadius: BorderRadius.circular(20),

                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                  width: 40,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.documentSnapshot['name'],
                      style: TextStyle(fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Icon(Iconsax.flash_1,size: 20,color:Colors.grey ,),
                        Text("${widget.documentSnapshot['cal']} Calories  ",
                          style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.grey),),
                        SizedBox(width: 5,),
                        Icon(Iconsax.clock,size: 20,color: Colors.grey,),
                        SizedBox(width: 5,),
                        Text("${widget.documentSnapshot['time']} Min",
                          style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.grey),),


                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(children: [
                      Icon(Iconsax.star1,color: Colors.amberAccent,),
                      SizedBox(width: 5,),
                      Text(widget.documentSnapshot['rating'],
                        style:TextStyle(
                          fontWeight: FontWeight.bold,
                        ) ,
                      ),
                      Text("/5"),
                      SizedBox(width: 5,),
                      Text("${widget.documentSnapshot['reviews'.toString()]} Reviews",
                        style:TextStyle(color: Colors.grey) ,
                      ),

                    ],),
                    SizedBox(height: 20,),
                    Row(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Ingrediants",
                              style: TextStyle(fontSize: 20,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                          SizedBox(height: 10,),
                          Text("How many servings?",
                            style: TextStyle(fontSize: 14,
                                color: Colors.grey
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      QuantityIncrementDecrement(curr: quantityProvider.cur,
                          onAdd:()=> quantityProvider.increaseServing(),
                          onRemove:()=> quantityProvider.decreaseServing()),

                    ],
                    ),
                    SizedBox(height: 10,),
                    Column(
                      children: [
                        Row(children: [
                          Column(children: widget.documentSnapshot['ingrediantsImage'].map<Widget>((imageUrl)=>Container(
                            height:60 , width: 60,
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(imageUrl),
                              ),
                            ),
                          ),
                          ).toList(),
                          ),
                          SizedBox(width: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.documentSnapshot["ingrediantName"].map<Widget>
                              ((name)=>
                                SizedBox(height: 60,
                                  child: Center(child: Text(name,
                                    style: TextStyle(fontSize: 16,
                                        color: Colors.grey.shade400),
                                  ),

                                  ),
                                ),
                            ).toList(),
                          ),
                          Spacer(),

                          Column(
                            children: quantityProvider.updateIngrediantAmounts.map<Widget>
                              ((amount)=>
                                SizedBox(height: 60,
                                  child: Center(child: Text(amount,
                                    style: TextStyle(fontSize: 16,
                                        color: Colors.grey.shade400),
                                  ),

                                  ),
                                ),
                            ).toList(),
                          ),





                        ],)
                      ],
                    ),

                  ],

                ),
              ),
              SizedBox(height: 40,)

            ],
          ) ,
        ),


      ),
    );
  }
}
