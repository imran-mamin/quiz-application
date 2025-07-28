import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:src/models/collection.dart';
import 'package:src/controllers/collection_controller.dart';
import 'package:src/constants/theme.dart';
import 'package:src/main.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final collectionController = Get.find<CollectionController>();

  void _deleteCollection(BuildContext context, Collection collection) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Collection'),
        content: Text('Are you sure you want to delete "${collection.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              collectionController.remove(collection.name);
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),          
        ],
      ),
    );
  }
  
  void _edit(Collection collection) {
    final index = collectionController.collections.indexOf(collection);
    Get.toNamed("/editcollection/$index");
  }

  void _learn(Collection collection) {
    // Randomize the order of flashcards.
    collection.shuffleFlashcards();

    final index = collectionController.collections.indexOf(collection);
    Get.toNamed("/learn/$index");
  }

  void _quiz(Collection collection) {
    // Randomize the order of flashcards.
    collection.shuffleFlashcards();

    final int colIndex = collectionController.collections.indexOf(collection);
    // Check whether the collection has flashcards.
    final String qaIndex = collection.flashcards.isEmpty ? '' : '0';
    const int correctAnswers = 0; // Current score.
    Get.toNamed("/quiz/$colIndex/$qaIndex/$correctAnswers");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(text: "Quiz Application"),
      backgroundColor: Constants.canvasBackgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Constants.maxScreenWidth),
          child: Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Obx(
                    () => collectionController.size == 0 ?
                      Center(child: Text('No collections', style: TextStyle(color: Constants.textColorOnCanvas, fontWeight: FontWeight.bold, fontSize: setFontSize(context)))) :
                      Column(
                        children: collectionController.collections.map( (collection) => Card(
                          color: Colors.white,
                          child: ListTile(
                            title: Text("${collection.name}"),
                            subtitle: Row(
                              children: [
                                Text("Size: ${collection.flashcards.length} flashcard${collection.flashcards.length == 1 ? '' : 's'}, "),
                                Text("${collection.flashcards.where( (fc) => fc.revise == true).length}, "),
                                Text("${collection.flashcards.length - collection.flashcards.where( (fc) => fc.revise == true ).length}"),
                              ],
                            ),
                            trailing: Wrap(
                              spacing: 8,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.school),
                                  onPressed: collection.flashcards.length == 0 ? null : () => _quiz(collection),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.menu_book),
                                  onPressed: collection.flashcards.length == 0 ? null : () => _learn(collection),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _edit(collection),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteCollection(context, collection),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: DefaultBottomNavigationBar(
        children: [
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => Get.toNamed('/collection'),
          ),
        ],
      ),
    );
  }
}
