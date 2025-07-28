import 'package:flash_card/flash_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:src/controllers/collection_controller.dart';
import 'package:src/models/collection.dart';
import 'package:src/models/flashcard.dart';
import 'package:src/main.dart';
import 'package:src/constants/theme.dart';

class QuizScreen extends StatelessWidget {
  QuizScreen({super.key});

  final collectionController = Get.find<CollectionController>();
  
  void _correct(int colIndex, List<QuestionAndAnswer> flashcardsToRevise) {
    final Collection currentCollection = collectionController.collections[colIndex];

    if (flashcardsToRevise.length > 1) {
      final QuestionAndAnswer qa = flashcardsToRevise.first;
      // Update revisionInterval and date.
      currentCollection.updateRevisionInterval(qa, true);
      Get.toNamed("/quiz/$colIndex");
    } else {
      final QuestionAndAnswer qa = flashcardsToRevise.first;
      // Update revisionInterval and date.
      currentCollection.updateRevisionInterval(qa, true);
      Get.toNamed('/quiz/results');
    }
  }

  void _incorrect(int colIndex, List<QuestionAndAnswer> flashcardsToRevise) {
    final Collection currentCollection = collectionController.collections[colIndex];

    if (flashcardsToRevise.length > 1) {
      final QuestionAndAnswer qa = flashcardsToRevise.first;
    
      // Update revisionInterval and date.
      currentCollection.updateRevisionInterval(qa, false);
      Get.toNamed("/quiz/$colIndex");
    } else {
      final QuestionAndAnswer qa = flashcardsToRevise.first;

      // Update revisionInterval and date.
      currentCollection.updateRevisionInterval(qa, false);
      Get.toNamed('/quiz/results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
      final List<QuestionAndAnswer> flashcardsToRevise = currentCollection.shuffledFlashcardsToRevise();
      final QuestionAndAnswer qa = flashcardsToRevise.first;

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
                        onPressed: () => _incorrect(colIndex, flashcardsToRevise),
                        label: const Text("Bad"),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        ),
                        icon: const Icon(Icons.thumb_up, color: Colors.amber),
                        label: const Text("Good"),
                        onPressed: () => _correct(colIndex, flashcardsToRevise),
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
                child: const Icon(Icons.home),
              ),
            ),
          ],
        ),
      );
    });
  }
}