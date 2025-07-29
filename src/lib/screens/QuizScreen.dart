import 'package:flash_card/flash_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:src/controllers/collection_controller.dart';
import 'package:src/models/collection.dart';
import 'package:src/models/flashcard.dart';
import 'package:src/main.dart';
import 'package:src/constants/theme.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final RxList<QuestionAndAnswer> flashcardsToRevise = <QuestionAndAnswer>[].obs;

  final collectionController = Get.find<CollectionController>();
  
  void _correct(int colIndex) {
    final Collection currentCollection = collectionController.collections[colIndex];

    final QuestionAndAnswer qa = flashcardsToRevise.last;
    // Update revisionInterval and date.
    currentCollection.updateRevisionInterval(qa, true);
    
    if (flashcardsToRevise.length == 1) {
      Get.offNamed('/results');
    } else {
      flashcardsToRevise.removeLast();
    }
  }

  void _incorrect(int colIndex) {
    final Collection currentCollection = collectionController.collections[colIndex];
    
    final QuestionAndAnswer qa = flashcardsToRevise.last;
    // Update revisionInterval and date.
    currentCollection.updateRevisionInterval(qa, false);
    flashcardsToRevise.shuffle();
  }

  @override
  void initState() {
    super.initState();
    final colIndexStr = Get.parameters['colIndex'];
    final colIndex = int.tryParse(colIndexStr ?? '');

    if (colIndex != null && colIndex >= 0 && colIndex < collectionController.size) {
      final currentCollection = collectionController.collections[colIndex];
      flashcardsToRevise.value = currentCollection.shuffledFlashcardsToRevise();
    }
  }

  @override
  Widget build(BuildContext context) {
    
    final colIndexStr = Get.parameters['colIndex'];
    final colIndex = int.tryParse(colIndexStr ?? '');

    final bool colIndexOutOfRange = colIndex == null || colIndex < 0 || colIndex >= collectionController.size;

    if (colIndexOutOfRange) {
      print("colIndex = ${colIndex}");
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
    
    return Obx(() {
      final QuestionAndAnswer qa = flashcardsToRevise.last;

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
                              qa.answer.value,
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
                              qa.question.value,
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
                        onPressed: () => _incorrect(colIndex),
                        label: const Text("Bad"),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        ),
                        icon: const Icon(Icons.thumb_up, color: Colors.amber),
                        label: const Text("Good"),
                        onPressed: () => _correct(colIndex),
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