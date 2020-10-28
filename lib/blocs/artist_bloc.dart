import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ArtistsDataBloc extends ChangeNotifier {
  List _artistsData = [], _searchData = [];

  List get artistsData => _artistsData;

  List get searchData => _searchData;

  ArtistsDataBloc() {
    getData();
  }

  Future getData() async {
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('artists').get();
    var x = snap.docs;
    _artistsData.clear();
    x.forEach((f) {
      _artistsData.add(f);
    });

    _artistsData.sort((a,b) =>  a['position'].compareTo(b['position']));
    notifyListeners();
  }

  void filterData(String parameter) {
    _searchData.clear();
    if (parameter.trim() != '' &&_artistsData.length != 0) {
      for (int i = 0; i < _artistsData.length; i++) {
        if (_artistsData[i]['name'].toString().toLowerCase().indexOf(parameter) >= 0) {
          _searchData.add(_artistsData[i]);
        }
      }
      print(_searchData.length);
      notifyListeners();
    }
  }
}
