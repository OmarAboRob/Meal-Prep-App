import 'package:flutter/material.dart';

class QuantityProvider extends ChangeNotifier{
  int _currentNumber = 1;
  List <double> _baseIng  = [] ;
  int get cur => _currentNumber;

  void setBase(List<double> amounts ){
    _baseIng = amounts;
    notifyListeners();
  }
  List<String> get updateIngrediantAmounts{
    return _baseIng.map<String>((amount)=>(amount*_currentNumber).toStringAsFixed(1)).toList();

  }
  void increaseServing(){
    _currentNumber++;
    notifyListeners();
  }
  void decreaseServing(){
    if(_currentNumber>1){
      _currentNumber--;
      notifyListeners();}
  }

}