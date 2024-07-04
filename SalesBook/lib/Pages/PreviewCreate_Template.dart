import 'package:flutter/material.dart';

class TemplateData {
  final String componentName;
  final String label;

  TemplateData({required this.componentName, required this.label});
}

class PreviewCreateTemplateScreen extends StatelessWidget {
  final List<TemplateData> templateData = [
    TemplateData(componentName: 'TextField', label: 'Enter Text'),
    TemplateData(componentName: 'NumberField', label: 'Enter Number'),
    TemplateData(
        componentName: 'PhoneNumberField', label: 'Enter Phone Number'),
    TemplateData(componentName: 'TextArea', label: 'Enter Description'),
    // TemplateData(componentName: 'Year', label: 'Select Year'),
    TemplateData(componentName: 'Dropdown', label: 'Select Option'),
    TemplateData(componentName: 'CheckboxGroup', label: 'Select Options'),
    // TemplateData(componentName: 'Filepicker', label: 'Upload File'),
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> formWidgets = buildFormWidgets(context, templateData);

    return Scaffold(
      appBar: AppBar(
        title: Text('NotesPage'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: formWidgets,
      ),
    );
  }

  List<Widget> buildFormWidgets(
      BuildContext context, List<TemplateData> templateData) {
    List<Widget> formWidgets = [];

    for (var element in templateData) {
      switch (element.componentName) {
        case 'TextField':
        case 'NumberField':
        case 'PhoneNumberField':
        case 'TextArea':
          formWidgets.add(
            buildTextField(element),
          );
          break;
        case 'Year':
          formWidgets.add(
            buildYearDropdown(element),
          );
          break;
        case 'Dropdown':
          formWidgets.add(
            buildDropdownWidget(element),
          );
          break;
        case 'CheckboxGroup':
          formWidgets.add(
            buildCheckboxGroupWidget(element),
          );
          break;
        // case 'Filepicker':
        //   formWidgets.add(buildFilePicker(element));
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
      onPressed: () => _showPopup(context),
      child: Text("Save"),
    ));
    formWidgets.add(SizedBox(height: 20));
    formWidgets.add(ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text("Cancel"),
    ));

    return formWidgets;
  }

  Widget buildTextField(TemplateData element) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        keyboardType: element.componentName == 'NumberField'
            ? TextInputType.number
            : element.componentName == 'PhoneNumberField'
                ? TextInputType.phone
                : TextInputType.text,
        maxLines: element.componentName == 'TextArea' ? 4 : 1,
        decoration: InputDecoration(
          labelText: element.label,
        ),
      ),
    );
  }

  Widget buildYearDropdown(TemplateData element) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<int>(
        decoration: InputDecoration(
          labelText: element.label,
        ),
        items: List.generate(
          50,
          (index) => DropdownMenuItem(
            value: 1970 + index,
            child: Text((1970 + index).toString()),
          ),
        ),
        onChanged: (newValue) {},
      ),
    );
  }

  Widget buildDropdownWidget(TemplateData element) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: element.label,
        ),
        items: <String>['Option 1', 'Option 2', 'Option 3'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {},
      ),
    );
  }

  Widget buildCheckboxGroupWidget(TemplateData element) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(element.label),
          CheckboxListTile(
            title: Text('Option 1'),
            value: false,
            onChanged: (newValue) {},
          ),
          CheckboxListTile(
            title: Text('Option 2'),
            value: false,
            onChanged: (newValue) {},
          ),
          CheckboxListTile(
            title: Text('Option 3'),
            value: false,
            onChanged: (newValue) {},
          ),
        ],
      ),
    );
  }

  Widget buildFilePicker(TemplateData element) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          // Implement file picker logic here
        },
        child: Text(element.label),
      ),
    );
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Form Submitted"),
          content: Text("Your form has been saved."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PreviewCreateTemplateScreen(),
  ));
}
