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
import 'package:first_project/models/collection.dart';
import 'package:first_project/main.dart';
import 'package:first_project/constants/theme.dart';


class EditQuestionAndAnswerScreen extends StatelessWidget {
  static final _formKey = GlobalKey<FormBuilderState>();
  final collectionController = Get.find<CollectionController>();
  
  void _submit(int colIndex, int qaIndex) {
    if (_formKey.currentState!.saveAndValidate()) {
      final data = _formKey.currentState!.value;

      final Collection collection = collectionController.collections[colIndex];
      final QuestionAndAnswer qa = collection.flashcards[qaIndex];
      qa.question = data['question'];
      qa.answer = data['answer'];

      collectionController.updateCollection(colIndex, collection);

      _formKey.currentState?.reset();
      Get.back();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final colIndexStr = Get.parameters['colIndex'];
    final colIndex = int.tryParse(colIndexStr ?? '');
    final qaIndexStr = Get.parameters['qaIndex'];
    final qaIndex = int.tryParse(qaIndexStr ?? '');
    
    final bool colIndexOutOfRange = colIndex == null || colIndex < 0 || colIndex >= collectionController.size;

    if (colIndexOutOfRange) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 110, 153, 222),
        appBar: AppBar(
          foregroundColor: Colors.white,
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 27, 39, 93),
          title: Text("Error"),
        ),
        body: Center(child: Text("Invalid collection index")),
      );
    }

    final Collection currentCollection = collectionController.collections[colIndex];
    final bool qaIndexOutOfRange = qaIndex == null || qaIndex < 0 || qaIndex >= currentCollection.flashcards.length;

    if (qaIndexOutOfRange) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 27, 39, 93),
          title: Text("Error"),
          automaticallyImplyLeading: false,
        ),
        backgroundColor: const Color.fromARGB(255, 110, 153, 222),
        body: Center(child: Text("Invalid flashcard index ${qaIndex}. length : ${currentCollection.flashcards.length}")),
      );
    }

    final QuestionAndAnswer qa = currentCollection.flashcards[qaIndex];

    return Scaffold(
      appBar: DefaultAppBar(text: "Edit Flashcard"),
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
                        initialValue: '${qa.question}',
                        decoration: const InputDecoration(
                          hintText: 'Question',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.required(),
                    ),
                    SizedBox(height: 16),
                    Text("Answer:", style: TextStyle(fontSize: setFontSize(context))),
                    FormBuilderTextField(
                      name: 'answer',
                      initialValue: '${qa.answer}',
                      decoration: const InputDecoration(
                        hintText: 'Answer',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                      validator: FormBuilderValidators.required(),
                    )
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
              onPressed: () => _submit(colIndex, qaIndex),
              child: Text("Save"),
            ),
          ),
        ],
      ),
    );
  }
}
