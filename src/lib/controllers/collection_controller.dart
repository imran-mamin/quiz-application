import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

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

  void _save() {
    storage.put(
      'collections',
      collections.map( (collection) => collection.toJson() ).toList(),
    );
  }

  void add(Collection collection) {
    collections.add(collection);
    _save();
  }

  void remove(String collectionName) {
    collections.removeWhere((c) => c.name == collectionName);
    collections.refresh();
    _save();
  }

  void updateCollection(int index, Collection updatedCollection) {
    collections[index] = updatedCollection;
    collections.refresh();
    _save();
  }

  int get size => collections.length;
}