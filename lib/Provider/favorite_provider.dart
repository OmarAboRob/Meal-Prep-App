import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteProvider extends ChangeNotifier{
  List<String> _favoriteIds = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> get favorites => _favoriteIds;

  FavoriteProvider(){
    loadFavorites();
  }
  //toggle favorites state
  void toggleFavorite(DocumentSnapshot product) async {
    String productId = product.id;
    if(_favoriteIds.contains(productId)){
      _favoriteIds.remove(productId);
      await _removeFavorite(productId);
    }
    else{
      _favoriteIds.add(productId);
      await _addFavorite(productId);
    }
    notifyListeners();
  }
  bool isExist(DocumentSnapshot product) {
    return _favoriteIds.contains(product.id);
  }
  Future <void> _addFavorite(String productId) async {
    try{
      await _firestore.collection("userFav").doc(productId).set({
        'isFav':true, // create the userFav collection and add the item as fav

      });
    }catch(e){
      print(e.toString());
    }
  }
  Future <void> _removeFavorite(String productId) async {
    try{
      await _firestore.collection("userFav").doc(productId).delete();
    }catch(e){
      print(e.toString());
    }
  }
  Future <void> loadFavorites()async{
    try{
      QuerySnapshot snapshot = await _firestore.collection("userFav").get();
      _favoriteIds = snapshot.docs.map((doc)=> doc.id).toList();
    }catch(e){print(e.toString());}
    notifyListeners();
  }
  //static method to access provider from any context
  static FavoriteProvider of(BuildContext context,{bool listen = true}){
    return Provider.of<FavoriteProvider>(context,listen: listen,);
  }


}