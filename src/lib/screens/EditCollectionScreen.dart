import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:src/models/collection.dart';
import 'package:src/models/flashcard.dart';
import 'package:src/controllers/collection_controller.dart';
import 'package:src/main.dart';
import 'package:src/constants/breakpoints.dart';
import 'package:src/constants/theme.dart';

class EditCollectionScreen extends StatelessWidget {
  final collectionController = Get.find<CollectionController>();
  
  void _deleteFlashcard(BuildContext context, Collection collection, QuestionAndAnswer flashcard) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Flashcard'),
        content: Text('Are you sure you want to delete this flashcard?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              collection.flashcards.remove(flashcard);
              Get.back();
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),          
        ],
      ),
    );
  }

  void _editFlashcard(Collection collection, QuestionAndAnswer flashcard) {
    final int colIndex = collectionController.collections.indexOf(collection);
    final int qaIndex = collection.flashcards.indexOf(flashcard);
    Get.toNamed("/editcollection/qa/$colIndex/$qaIndex");
  }

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
          title: Text("Error")
        ),
        backgroundColor: const Color.fromARGB(255, 110, 153, 222),
        body: Center(child: Text("Invalid index")),
      );
    }
  
    return Obx(() {
      final Collection currentCollection = collectionController.collections[index];

      return Scaffold(
        appBar: DefaultAppBar(text: "Collection: ${currentCollection.name}"),
        backgroundColor: Constants.canvasBackgroundColor,
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Constants.maxScreenWidth),
            child: Padding(
              padding: EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: currentCollection.flashcards.length == 0 ?
                        Center(child: Text('The Collection is Empty.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: setFontSize(context)))) :
                        Column(
                          children: currentCollection.flashcards.map( (fc) => Card(
                            child: ListTile(
                              title: Text("${fc.question}"),
                              subtitle: Text("${fc.answer}"),
                              trailing: Wrap(
                                spacing: 8,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () => _editFlashcard(currentCollection, fc),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteFlashcard(context, currentCollection, fc),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ).toList(),
                      ),
                  )
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
                onPressed: () => Get.toNamed("/editcollection/qa/${index}"),
                child: Text("New Flashcard"),
              ),
            ),
          ],
        ),
      );
    });
  }
}