import 'package:flutter/material.dart';
class BannerToExplore extends StatelessWidget {
  const BannerToExplore({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: 170,
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(15),
        color: Color(0xff579f8c),
      ) ,
      child: Stack(
        children: [
          Positioned(
            top: 32,
            left: 20,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Cook the best\nrecipes at home",
                  style:TextStyle(
                    height: 1.1,fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white,


                  ),),
                SizedBox(height: 10,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal:33, ),
                    backgroundColor: Colors.white,
                    elevation: 0,

                  ),
                  onPressed: (){},
                  child: Text("Explore",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 50,


            child:
            Image.network("https://pngimg.com/uploads/chef/chef_PNG16.png"),
          ),

        ],
      ),
    );
  }
}


