import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/Model/Template_Data.dart';

class DatasourceProvider extends ChangeNotifier {
  List<TemplateData> _templateDatas = [];
  List<TemplateData> get templateDatas => _templateDatas;

  void updateTemplateData(List<TemplateData> newValue) {
    _templateDatas = newValue;
    notifyListeners();
  }

  Future<void> addDataToFirestore(String headers, String jsonBody) async {
    DocumentReference docRef =
        await FirebaseFirestore.instance.collection('Fields').add({
      'templateData': jsonBody,
    });

    // Update the document with the generated ID
    await docRef.update({
      'id': docRef.id,
      'Label': headers,
    });
  }

  Future<void> fetchDataFromFirestore() async {
    final CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('Fields');

    try {
      QuerySnapshot snapshot = await collectionReference.get();
      List<TemplateData> templates = snapshot.docs.map((doc) {
        return TemplateData.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      updateTemplateData(templates);
    } catch (e) {
      print("Error fetching templates: $e");
    }
  }

  // Future getDatafromFirestore() async{
  //   try{
  //      final CollectionReference collectionReference= FirebaseFirestore.instance.collection('Fields');
  //      await collectionReference.get().then((querysnapshot){

  //      }

  //      )
  //   }
  // }
}
