import 'package:flash_card/flash_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:first_project/controllers/collection_controller.dart';
import 'package:first_project/models/flashcard.dart';
import 'package:first_project/models/collection.dart';
import 'package:first_project/main.dart';
import 'package:first_project/constants/theme.dart';

class LearnScreen extends StatelessWidget {
  final collectionController = Get.find<CollectionController>();
  
  @override
  Widget build(BuildContext context) {
    final indexStr = Get.parameters['index'];
    final index = int.tryParse(indexStr ?? '');
    
    if (index == null || index < 0 || index >= collectionController.size) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 27, 39, 93),
          title: Text("Error"),
          automaticallyImplyLeading: false,
        ),
        backgroundColor: const Color.fromARGB(255, 110, 153, 222),
        body: Center(child: Text("Invalid index")),
      );
    }

   
    final Collection currentCollection = collectionController.collections[index];
    final List<QuestionAndAnswer> clonedFlashcards = currentCollection.shuffledFlashcards;

    return Scaffold(
      appBar: DefaultAppBar(text: "Collection: ${currentCollection.name}"),
      backgroundColor: const Color.fromARGB(255, 110, 153, 222),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Constants.maxScreenWidth),
          child: PageView.builder(
            itemCount: clonedFlashcards.length,
            itemBuilder: (context, index) {
              final QuestionAndAnswer qa = clonedFlashcards[index];

              return Padding(padding: const EdgeInsets.all(16), child: Column(
                children: [
                  LinearProgressIndicator(
                    value: (index + 1) / currentCollection.shuffledFlashcards.length,
                    backgroundColor: Colors.white24,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Flashcard ${index + 1} of ${currentCollection.shuffledFlashcards.length}",
                    style: TextStyle(fontSize: setFontSize(context), color: Colors.white),
                  ),
                  FlashCard(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.height * 0.45,
                    frontWidget: Card(
                      color: Colors.white,
                      child: Center(
                        child: SingleChildScrollView(
                          child: Text(
                            qa.answer,
                            style: TextStyle(fontSize: setFontSize(context)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    backWidget: Card(
                      color: Colors.white,
                      child: Center(
                        child: SingleChildScrollView(
                          child: Text(
                            qa.question,
                            style: TextStyle(fontSize: setFontSize(context)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
            },
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
              child: Icon(Icons.home),
            ),
          ),
        ],
      ),
    );
  }
}