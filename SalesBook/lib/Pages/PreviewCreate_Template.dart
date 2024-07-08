import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Model/TemplateResponseModel.dart';
import 'package:flutter_application_1/Model/Template_Data.dart';
import 'package:flutter_application_1/Provider/DataSource_Provider.dart';
import 'package:provider/provider.dart';

class PreviewcreateTemplate extends StatefulWidget {
  const PreviewcreateTemplate({super.key});

  @override
  State<PreviewcreateTemplate> createState() => _PreviewcreateTemplateState();
}

class _PreviewcreateTemplateState extends State<PreviewcreateTemplate> {
  final CollectionReference Field =
      FirebaseFirestore.instance.collection("Fields");

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

    for (var element in dataSourceProvider.templateDatas) {
      switch (element.componentName) {
        case 'TextField':
        case 'NumberField':
        case 'PhoneNumberField':
        case 'TextArea':
          formWidgets.add(
            buildTextField(element, labelWidth),
          );
          break;

        // case 'Dropdown':
        //   buildDropdown(element, dataSourceProvider);
        //   formWidgets.add(
        //     buildDropdownWidget(element, labelWidth),
        //   );
        //   break;
        // case 'CheckboxGroup':
        //   buildCheckboxGroup(element, dataSourceProvider);
        //   formWidgets.add(
        //     buildCheckboxGroupWidget(element),
        //   );
        //   break;

        default:
          formWidgets.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Unsupported widget type'),
            ),
          );
      }
    }
    formWidgets.add(ElevatedButton(
        onPressed: () {
          _showPopup(context, dataSourceProvider);
        },
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Give Your Template Name.'),
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
                  _saveTemplate(dataSourceProvider, brandName.text);
                  Navigator.pop(context);
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

  Future<void> _saveTemplate(
      DatasourceProvider dataSourceProvider, String text) async {
    String templateData = jsonEncode(
        dataSourceProvider.templateDatas.map((e) => e.toJson()).toList());

    TemplateRequestModel newTemplate =
        TemplateRequestModel(label: text, templateData: templateData);

    final String jsonBody = jsonEncode(newTemplate.toJson());

    await dataSourceProvider.addDataToFirestore(text, jsonBody);

    print('Template saved successfully to Firestore.');
  }

  Padding buildTextField(TemplateData element, double labelWidth) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                  label: Text(element.label ?? ''),
                  hintText: element.hint ?? '',
                  // Padding inside the text field
                  border: element.componentName == 'TextArea'
                      ? OutlineInputBorder()
                      : UnderlineInputBorder()),
              keyboardType: element.componentName == 'NumberField'
                  ? TextInputType.number
                  : element.componentName == 'PhoneNumberField'
                      ? TextInputType.phone
                      : TextInputType.text,
              inputFormatters: element.componentName == 'NumberField' ||
                      element.componentName == 'PhoneNumberField'
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : null,
              maxLines: element.componentName == 'TextArea' ? 3 : 1,
            ),
          ),
        ],
      ),
    );
  }

  Padding buildNumberField(TemplateData element, double labelWidth) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ConstrainedBox(
            constraints:
                BoxConstraints(minWidth: labelWidth, maxWidth: labelWidth),
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
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
        ],
      ),
    );
  }

  Padding buildPhoneNumberField(TemplateData element, double labelWidth) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ConstrainedBox(
            constraints:
                BoxConstraints(minWidth: labelWidth, maxWidth: labelWidth),
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
    );
  }

  Padding buildTextArea(TemplateData element, double labelWidth) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints:
                BoxConstraints(minWidth: labelWidth, maxWidth: labelWidth),
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
                contentPadding:
                    EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
