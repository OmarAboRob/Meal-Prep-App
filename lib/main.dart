import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:meal_prepare_app/Provider/favorite_provider.dart';
import 'package:meal_prepare_app/Provider/quantity.dart';
import 'package:meal_prepare_app/favorite_screen.dart';
import 'package:meal_prepare_app/firebase_options.dart';
import 'package:meal_prepare_app/my_app_home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex = 0;
  late final List<Widget> page;
  @override
  void initState() {
    page = [
      MyAppHomeScreen(),
      FavoriteScreen(),


    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      MultiProvider(
        providers: [
          //for fav provider
          ChangeNotifierProvider(create: (_)=>FavoriteProvider()),
          // for quantity provider
          ChangeNotifierProvider(create: (_)=>QuantityProvider()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home:
            Scaffold(
              backgroundColor: Colors.white,
              bottomNavigationBar: BottomNavigationBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  iconSize: 28,
                  selectedItemColor: Color(0xff568A9F),
                  unselectedItemColor: Color(0xff568A9F),
                  type: BottomNavigationBarType.fixed,
                  selectedLabelStyle: TextStyle(color:Color(0xff568A9F),fontWeight: FontWeight.w600 ),
                  unselectedLabelStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.w500 ),
                  onTap: (value){
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                  items: [
                    BottomNavigationBarItem(icon: Icon(
                        selectedIndex == 0 ? Iconsax.home5 : Iconsax.home_1),
                        label: "Home"
                    ),
                    BottomNavigationBarItem(icon: Icon(
                        selectedIndex == 1 ? Iconsax.heart5 : Iconsax.heart),
                        label: "Favorite"
                    ),



                  ]
              ),
              body: page[selectedIndex],
            )
        ),
      );
  }

}

