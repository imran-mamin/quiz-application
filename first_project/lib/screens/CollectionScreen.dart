import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:first_project/controllers/collection_controller.dart';
import 'package:first_project/models/collection.dart';
import 'package:first_project/main.dart';
import 'package:first_project/constants/breakpoints.dart';
import 'package:first_project/constants/theme.dart';

class CollectionScreen extends StatelessWidget {
  static final _formKey = GlobalKey<FormBuilderState>();
  final collectionController = Get.find<CollectionController>();

  void _submit(BuildContext context) {
    if (_formKey.currentState!.saveAndValidate()) {
      final name = _formKey.currentState!.value['name'];
      final bool existsAlready = collectionController.collections.any((c) => c.name == name);
      
      if (existsAlready) {
        const snackBar = SnackBar(
          content: Center(
            child: const Text("There is already a collection with the specified name"),
          ),
        );
        
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      
      final collection = Collection(name, []);
      collectionController.add(collection);
      
      _formKey.currentState?.reset();
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(text: "Create A New Collection"),
      backgroundColor: Constants.canvasBackgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Constants.maxScreenWidth),
          child: FormBuilder(
            key: _formKey,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // center vertically
                  crossAxisAlignment: CrossAxisAlignment.center, // center horizontally
                  children: [
                    Text("Collection Name:", style: TextStyle(fontSize: setFontSize(context))),
                    FormBuilderTextField(
                      name: 'name',
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Name for a collection',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: FormBuilderValidators.required()
                    ), 
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: DefaultBottomNavigationBar(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: () => Get.back(),
              child: Icon(Icons.arrow_back_rounded),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: () => _submit(context),
              child: Text("Save"),
            ),
          ),
        ],
      ),
    );
  }
}