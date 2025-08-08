import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:src/models/collection.dart';
import 'package:src/controllers/collection_controller.dart';
import 'package:src/constants/theme.dart';
import 'package:src/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RxString searchText = "".obs;

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
    final index = collectionController.collections.indexOf(collection);
    Get.toNamed("/learn/$index");
  }

  void _quiz(Collection collection) {
    final int colIndex = collectionController.collections.indexOf(collection);
    Get.toNamed("/quiz/$colIndex");
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
                  child: SearchBar(
                    leading: const Icon(Icons.search),
                    hintText: 'Search',
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 12.0),
                    ),
                    onChanged: (value) {
                      searchText.value = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Obx(
                    () {
                      /// If there are no collections, then show 'No collections' text.
                      if (collectionController.size == 0) {
                        return Center(
                          child: Text(
                            'No collections',
                            style: TextStyle(
                              color: Constants.textColorOnCanvas,
                              fontWeight: FontWeight.bold,
                              fontSize: setFontSize(context),
                            ),
                          ),
                        );
                      }
                      
                      /// Find collections that have a substring searchText.value.
                      final filteredCollections = collectionController.collections.where((c) =>
                        c.name.toLowerCase().contains(searchText.value)
                      ).toList();
                      
                      if (filteredCollections.isEmpty) {
                        return Center(
                          child: Text(
                            'No collections found with a specified name "${searchText.value}"',
                            style: TextStyle(
                              color: Constants.textColorOnCanvas,
                              fontWeight: FontWeight.bold,
                              fontSize: setFontSize(context),
                            ),
                          ),
                        );
                      } else {
                        return Column(
                          children: filteredCollections.map( (collection) => Card(
                            color: Colors.white,
                            child: ListTile(
                              title: Text(
                                "${collection.name}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Size: ${collection.flashcards.length}",
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                  Text(
                                    "Revise: ${collection.flashcards.where( (fc) => fc.revise == true ).length}",
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                              trailing: Wrap(
                                spacing: 0,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.school),
                                    // The IconButton is active only when there are some flashcards that should be revised.
                                    onPressed: collection.flashcards.where( (fc) => fc.revise == true ).length == 0 ?
                                      null :
                                      () => _quiz(collection),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.menu_book),
                                    // The IconButton is active only when there are some flashcards in the collection.
                                    onPressed: collection.flashcards.length == 0 ?
                                      null :
                                      () => _learn(collection),
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
                          )).toList(),
                        );
                      }
                    }
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
