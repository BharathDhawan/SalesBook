import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/TemplateResponseModel.dart';
import 'package:flutter_application_1/Provider/DataSource_Provider.dart';
import 'package:provider/provider.dart';

class SaveTemplate extends StatefulWidget {
  const SaveTemplate({super.key});

  @override
  State<SaveTemplate> createState() => _SaveTemplateState();
}

class _SaveTemplateState extends State<SaveTemplate> {
  List<TemplateResponseModel> templates = [];
  bool _isLoading = true; // Tracks initial data loading
  String? _responseMessage; // Tracks API response message

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('Fields');

  Future<void> initializeData() async {
    setState(() {
      _isLoading = true; // Start loading
      _responseMessage = null; // Reset response message
    });
    try {
      QuerySnapshot snapshot = await collectionReference.get();
      templates = snapshot.docs.map((doc) {
        return TemplateResponseModel.fromJson(
            doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      setState(() {
        _responseMessage = 'Failed to load templates: $e'; // Error message
        print('Error fetching templates: $e');
      });
      // print('Error fetching templates: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    if (_responseMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showResponseMessage(_responseMessage!);
      });
    }
  }

  void _showResponseMessage(String message) {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text(message)),

    // );
    // Alternatively, you can use a Dialog:
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('API Response'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Templates'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: templates.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(templates[index].label ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => EditTemplatePage(
                            //       template: templates[index],
                            //     ),
                            //   ),
                            // );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deleteTemplate(templates[index].id);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteTemplate(String? id) async {
    if (id != null) {
      await FirebaseFirestore.instance.collection('Fields').doc(id).delete();
    }
  }
}
