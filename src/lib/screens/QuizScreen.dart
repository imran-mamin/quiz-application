import 'package:flash_card/flash_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

import 'package:src/controllers/collection_controller.dart';
import 'package:src/models/collection.dart';
import 'package:src/models/flashcard.dart';
import 'package:src/main.dart';
import 'package:src/constants/theme.dart';

class QuizScreen extends StatelessWidget {
  RxList<QuestionAndAnswer> flashcardsToRevise = <QuestionAndAnswer>[].obs;

  QuizScreen({super.key});

  final collectionController = Get.find<CollectionController>();
  
  void _correct(int colIndex, int score) {
    final Collection currentCollection = collectionController.collections[colIndex];

    if (flashcardsToRevise.length > 1) {
      final QuestionAndAnswer qa = flashcardsToRevise.first;
      // Update revisionInterval and date.
      currentCollection.updateRevisionInterval(qa, true);
      Get.toNamed("/quiz/$colIndex/${score + 1}");
    } else {
      final QuestionAndAnswer qa = flashcardsToRevise.first;
      // Update revisionInterval and date.
      currentCollection.updateRevisionInterval(qa, true);
      Get.toNamed('/quiz/results/${score + 1}/total/${flashcardsToRevise.length}');
    }
  }

  void _incorrect(int colIndex, int score) {
    final Collection currentCollection = collectionController.collections[colIndex];

    if (flashcardsToRevise.length > 1) {
      final QuestionAndAnswer qa = flashcardsToRevise.first;
    
      // Update revisionInterval and date.
      currentCollection.updateRevisionInterval(qa, false);
      Get.toNamed("/quiz/$colIndex/$score");
    } else {
      final QuestionAndAnswer qa = flashcardsToRevise.first;

      // Update revisionInterval and date.
      currentCollection.updateRevisionInterval(qa, false);
      Get.toNamed('/quiz/results/$score/total/${flashcardsToRevise.length}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colIndexStr = Get.parameters['colIndex'];
    final colIndex = int.tryParse(colIndexStr ?? '');

    final bool colIndexOutOfRange = colIndex == null || colIndex < 0 || colIndex >= collectionController.size;

    if (colIndexOutOfRange) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 110, 153, 222),
        appBar: AppBar(
          foregroundColor: Colors.white,
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 27, 39, 93),
          title: const Text("Error")
        ),
        body: const Center(child: Text("Invalid collection index")),
      );
    }

    final Collection currentCollection = collectionController.collections[colIndex];
    
    // Define a list that should be revised and shuffle it.
    flashcardsToRevise.value = currentCollection.flashcards.where( (fc) => fc.revise == true ).toList();
    flashcardsToRevise.shuffle();

    final QuestionAndAnswer qa = flashcardsToRevise.first;

    final scoreStr = Get.parameters['score'];
    final score = int.tryParse(scoreStr ?? '');

    if (score == null) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 110, 153, 222),
        appBar: AppBar(
          foregroundColor: Colors.white,
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 27, 39, 93),
          title: Text("Error")
        ),
        body: Center(child: Text("Invalid quiz score")),
      );
    }

    return Scaffold(
      appBar: DefaultAppBar(text: "Quiz - ${currentCollection.name}"),
      backgroundColor: Constants.canvasBackgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Constants.maxScreenWidth),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: FlashCard(
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
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      ),
                      icon: const Icon(Icons.thumb_down, color: Colors.amber),
                      onPressed: () => _incorrect(colIndex, score),
                      label: const Text("Bad"),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      ),
                      icon: const Icon(Icons.thumb_up, color: Colors.amber),
                      label: const Text("Good"),
                      onPressed: () => _correct(colIndex, score),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
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
              onPressed: () => Get.offNamed("/"),
              child: Icon(Icons.home),
            ),
          ),
        ],
      ),
    );
  }
}