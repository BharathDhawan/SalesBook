import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/Template_Data.dart';

class DatasourceProvider extends ChangeNotifier {
  List<TemplateData> _templateDatas = [];
  List<TemplateData> get templateDatas => _templateDatas;

  void updateTemplateData(List<TemplateData> newValue) {
    _templateDatas = newValue;
  }
}
