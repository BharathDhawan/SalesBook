import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Model/Form_Element.dart';
import 'package:flutter_application_1/Model/TemplateResponseModel.dart';
import 'package:flutter_application_1/Model/Template_Data.dart';
import 'package:flutter_application_1/Provider/DataSource_Provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class PreviewEditTemplateScreen extends StatefulWidget {
  final TemplateResponseModel template;

  PreviewEditTemplateScreen({
    super.key,
    required this.template,
  });

  @override
  State<PreviewEditTemplateScreen> createState() =>
      _PreviewEditTemplateScreenState();
}

class _PreviewEditTemplateScreenState extends State<PreviewEditTemplateScreen> {
  List<FormElement> formElements = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveEditedTemplate(
      List<TemplateData> formElements, TemplateResponseModel template) async {
    String templateData =
        jsonEncode(formElements.map((e) => e.toJson()).toList());

    DocumentReference docRef =
        FirebaseFirestore.instance.collection('Fields').doc(template.id);

    // Update the document with the new values
    await docRef.update({
      'templateData': templateData,
      'Label': template.label,
    });

    print('Template edited and saved successfully to Firestore.');
  }

  Future<void> _saveTemplate(
      DatasourceProvider dataSourceProvider, String text) async {
    String templateData = jsonEncode(
        dataSourceProvider.templateData.map((e) => e.toJson()).toList());

    TemplateRequestModel newTemplate =
        TemplateRequestModel(label: text, templateData: templateData);

    final String jsonBody = jsonEncode(newTemplate.toJson());

    await dataSourceProvider.addDataToFirestore(jsonBody);

    print('Template saved successfully to Firestore.');
  }

  @override
  Widget build(BuildContext context) {
    final dataSourceProvider = Provider.of<DatasourceProvider>(context);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<Widget> formWidgets = generateFormWidgets(dataSourceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Preview Form'),
      ),
      body: Center(
        child: SizedBox(
          height: height,
          width: width * 0.5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Scrollbar(
                child: ListView(
                  children: formWidgets,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> generateFormWidgets(DatasourceProvider dataSourceProvider) {
    List<Widget> formWidgets = [];
    const double labelWidth = 150.0;
    for (var element in dataSourceProvider.templateData) {
      switch (element.componentName) {
        case 'TextField':
          formWidgets.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: labelWidth, maxWidth: labelWidth),
                    child: Text(
                      element.label ?? '',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: element.hint ?? '',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
          break;
        case 'NumberField':
          formWidgets.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: labelWidth, maxWidth: labelWidth),
                    child: Text(
                      element.label ?? '',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: element.hint ?? '',
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ],
              ),
            ),
          );
          break;
        case 'PhoneNumberField':
          formWidgets.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: labelWidth, maxWidth: labelWidth),
                    child: Text(
                      element.label ?? '',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: element.hint ?? '',
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ],
              ),
            ),
          );
          break;
        case 'TextArea':
          formWidgets.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: labelWidth, maxWidth: labelWidth),
                    child: Text(
                      element.label ?? '',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: element.hint ?? '',
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 10.0,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
          break;
      }
    }
    formWidgets.add(ElevatedButton(
        onPressed: () => _showPopup(context, dataSourceProvider),
        child: Text("Save")));
    formWidgets.add(SizedBox(height: 20));
    formWidgets.add(ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("Cancel")));

    return formWidgets;
  }

  void _showPopup(BuildContext context, DatasourceProvider dataSourceProvider) {
    TextEditingController brandName = TextEditingController();
    brandName.text = widget.template.label!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Popup Title'),
          content: Text('This is a simple popup.'),
          actions: <Widget>[
            TextFormField(
              controller: brandName,
              decoration: InputDecoration(
                labelText: 'Template Name',
                hintText: 'Enter template name',
              ),
            ),
            TextButton(
                child: Text('Save'),
                onPressed: () {
                  setState(() {
                    widget.template.label = brandName.text;
                  });
                  _saveEditedTemplate(
                      dataSourceProvider.templateData, widget.template);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/homepage',
                    (route) => false,
                  );
                }),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
