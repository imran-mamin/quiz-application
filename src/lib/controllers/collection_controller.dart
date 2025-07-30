import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'package:src/models/collection.dart';

class CollectionController {
  final storage = Hive.box("storage");

  RxList collections;

  CollectionController() : collections = [].obs {
    if (storage.get('collections') == null) {
      storage.put('collections', []);
    }

    collections.value = storage.get('collections').map( (collection) => Collection.fromJson(collection) ).toList();
  }

  Future<void> _save() async {
    await storage.put(
      'collections',
      collections.map( (collection) => collection.toJson() ).toList(),
    );
  }

  Future<void> persist() async {
    await _save();
  }

  /**
   * Return true if a new collection is added and false if there already exists a collection
   * with the same name.
   */
  Future<bool> add(Collection collection) async {
    final bool alreadyExists = collections.any( (c) => c.name == collection.name );

    if (alreadyExists) {
      return false;
    }

    collections.add(collection);
    await _save();
    
    return true;
  }

  Future<void> remove(String collectionName) async {
    collections.removeWhere((c) => c.name == collectionName);
    collections.refresh();
    await _save();
  }

  Future<void> updateCollection(int index, Collection updatedCollection) async {
    collections[index] = updatedCollection;
    collections.refresh();
    await _save();
  }

  void updateTimeStampsInFlashcards() async {
    for (final c in collections) {
      c.updateRevisionTimes();
    }
    
    await _save();
  }

  int get size => collections.length;
}