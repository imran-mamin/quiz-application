import 'dart:async';
import 'dart:io';
import 'package:flash_card/flash_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:camera/camera.dart';

import 'package:first_project/controllers/collection_controller.dart';
import 'package:first_project/models/flashcard.dart';
import 'package:first_project/main.dart';
import 'package:first_project/constants/theme.dart';


class QuestionAndAnswerScreen extends StatelessWidget {
  static final _formKey = GlobalKey<FormBuilderState>();
  final collectionController = Get.find<CollectionController>();
  
  void _submit() {
    if (_formKey.currentState!.saveAndValidate()) {
      final indexStr = Get.parameters['index'];
      final index = int.tryParse(indexStr ?? '');
      
      if (index == null) {
        Get.snackbar('Error', 'Invalid collection index');
        return;
      }
      
      final data = _formKey.currentState!.value;

      final qa = QuestionAndAnswer(
        question: data['question'],
        answer: data['answer'],
      );

      final collection = collectionController.collections[index];
      collection.flashcards.add(qa);

      collectionController.updateCollection(index, collection);

      _formKey.currentState?.reset();
      Get.back();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(text: "New Flashcard"),
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
                    Text("Question:", style: TextStyle(fontSize: setFontSize(context))),
                    FormBuilderTextField(
                        name: 'question',
                        decoration: const InputDecoration(
                          hintText: 'Question',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: FormBuilderValidators.required(),
                      ),
                      SizedBox(height: 16),
                      Text("Answer:", style: TextStyle(fontSize: setFontSize(context))),
                      FormBuilderTextField(
                        name: 'answer',
                        decoration: const InputDecoration(
                          hintText: 'Answer',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: FormBuilderValidators.required(),
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
              onPressed: _submit,
              child: Text("Save"),
            ),
          ),
        ],
      ),
    );
  }
}