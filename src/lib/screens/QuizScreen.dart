import 'package:flash_card/flash_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:src/controllers/collection_controller.dart';
import 'package:src/models/collection.dart';
import 'package:src/models/flashcard.dart';
import 'package:src/main.dart';
import 'package:src/constants/theme.dart';

class QuizScreen extends StatelessWidget {
  final collectionController = Get.find<CollectionController>();
  
  void _correct(int colIndex, int qaIndex, int score) {
    final Collection currentCollection = collectionController.collections[colIndex];

    if (qaIndex < (currentCollection.flashcards.length - 1)) {
      Get.toNamed("/quiz/$colIndex/${qaIndex + 1}/${score + 1}");
    } else {
      Get.toNamed('/quiz/results/${score + 1}/total/${currentCollection.flashcards.length}');
    }
  }

  void _incorrect(int colIndex, int qaIndex, int score) {
    final Collection currentCollection = collectionController.collections[colIndex];
    
    if (qaIndex < (currentCollection.flashcards.length - 1)) {
      Get.toNamed("/quiz/$colIndex/${qaIndex + 1}/$score");
    } else {
      Get.toNamed('/quiz/results/$score/total/${currentCollection.flashcards.length}');
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
          title: Text("Error")
        ),
        body: Center(child: Text("Invalid collection index")),
      );
    }

    final Collection currentCollection = collectionController.collections[colIndex];
    
    final qaIndexStr = Get.parameters['qaIndex'];
    final qaIndex = int.tryParse(qaIndexStr ?? '');
    final bool qaIndexOutOfRange = qaIndex == null || qaIndex < 0 || qaIndex >= currentCollection.flashcards.length;

    if (qaIndexOutOfRange) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 27, 39, 93),
          title: Text("Error"),
        ),
        backgroundColor: const Color.fromARGB(255, 110, 153, 222),
        body: Center(child: Text("Invalid flashcard index ${qaIndex}. length : ${currentCollection.flashcards.length}")),
      );
    }

    final QuestionAndAnswer qa = currentCollection.shuffledFlashcards[qaIndex];

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
          constraints: BoxConstraints(maxWidth: Constants.maxScreenWidth),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: (qaIndex + 1) / currentCollection.shuffledFlashcards.length,
                  backgroundColor: Colors.white24,
                  color: Colors.white,
                ),
                SizedBox(height: 16),
                Text(
                  "Flashcard ${qaIndex + 1} of ${currentCollection.shuffledFlashcards.length}",
                  style: TextStyle(fontSize: setFontSize(context), color: Colors.white),
                ),
                SizedBox(height: 24),
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
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      ),
                      icon: Icon(Icons.thumb_down, color: Colors.amber),
                      onPressed: () => _incorrect(colIndex, qaIndex, score),
                      label: Text("Incorrect"),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      ),
                      icon: Icon(Icons.thumb_up, color: Colors.amber),
                      label: Text("Correct"),
                      onPressed: () => _correct(colIndex, qaIndex, score),
                    ),
                  ],
                ),
                SizedBox(height: 40),
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