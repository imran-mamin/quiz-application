import 'package:flash_card/flash_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'package:first_project/constants/breakpoints.dart';
import 'package:first_project/constants/theme.dart';
import 'package:first_project/models/flashcard.dart';
import 'package:first_project/models/collection.dart';
import 'package:first_project/controllers/collection_controller.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox("storage");
  Get.lazyPut<CollectionController>(() => CollectionController());
  runApp(
    GetMaterialApp(
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: () => HomeScreen()),
        GetPage(name: "/collection", page: () => CollectionScreen()),
        GetPage(name: "/editcollection/:index", page: () => EditCollectionScreen()),
        GetPage(name: "/editcollection/qa/:index", page: () => QuestionAndAnswerScreen()),
        GetPage(name: "/editcollection/qa/:colIndex/:qaIndex", page: () => EditQuestionAndAnswerScreen()),
        GetPage(name: "/quiz/:colIndex/:qaIndex/:score", page: () => QuizScreen()),
        GetPage(name: "/learn/:index", page: () => LearnScreen()),
        GetPage(name: "/quiz/results/:score/total/:total", page: () => ResultScreen()),
      ],
    ),
  );
}

bool isMobile(BuildContext context) {
  return MediaQuery.of(context).size.width < Breakpoints.sm;
}

bool isTablet(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final bool largerThanMobile = width >= Breakpoints.sm;
  final bool smallerThanLg = width < Breakpoints.lg;

  return largerThanMobile && smallerThanLg;
}

double setFontSize(BuildContext context) {
  if (isMobile(context)) {
    return 20.0;
  } else if (isTablet(context)) {
    return 40.0;
  } else {
    return 42.0;
  }
}

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  
  DefaultAppBar({required this.text});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Constants.appBarBackgroundColor,
      foregroundColor: Colors.white,
      title: Text(text),
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class DefaultBottomNavigationBar extends StatelessWidget {
  final List<Widget> children;
  
  DefaultBottomNavigationBar({required this.children});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Constants.appBarBackgroundColor,
      elevation: 8,
      child: SizedBox(
        height: kBottomNavigationBarHeight,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Constants.maxScreenWidth),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: this.children,
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final collectionController = Get.find<CollectionController>();

  void _deleteCollection(BuildContext context, Collection collection) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Collection'),
        content: Text('Are you sure you want to delete "${collection.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              collectionController.remove(collection);
              Get.back();
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),          
        ],
      ),
    );
  }
  
  void _edit(Collection collection) {
    final index = collectionController.collections.indexOf(collection);
    Get.toNamed("/editcollection/${index}");
  }

  void _learn(Collection collection) {
    // Randomize the order of flashcards.
    collection.shuffleFlashcards();

    final index = collectionController.collections.indexOf(collection);
    Get.toNamed("/learn/${index}");
  }

  void _quiz(Collection collection) {
    // Randomize the order of flashcards.
    collection.shuffleFlashcards();

    final int colIndex = collectionController.collections.indexOf(collection);
    // Check whether the collection has flashcards.
    final String qaIndex = collection.flashcards.length == 0 ? '' : '0';
    final int correctAnswers = 0; // Current score.
    Get.toNamed("/quiz/$colIndex/$qaIndex/$correctAnswers");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(text: "Quiz Application"),
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
                  child: Obx(
                    () => collectionController.size == 0 ?
                      Center(child: Text('No collections', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: setFontSize(context)))) :
                      Column(
                        children: collectionController.collections.map( (collection) => Card(
                          color: Colors.white,
                          child: ListTile(
                            title: Text("${collection.name}"),
                            subtitle: Text("Size: ${collection.flashcards.length} flashcards"),
                            trailing: Wrap(
                              spacing: 8,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.school),
                                  onPressed: collection.flashcards.length == 0 ? null : () => _quiz(collection),
                                ),
                                IconButton(
                                  icon: Icon(Icons.menu_book),
                                  onPressed: collection.flashcards.length == 0 ? null : () => _learn(collection),
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _edit(collection),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
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
          Expanded(child: 
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: () => Get.toNamed("/collection"),
              child: const Text("Add New Collection"),
            ),
          ),
        ],
      ),
    );
  }
}

class CollectionScreen extends StatelessWidget {
  static final _formKey = GlobalKey<FormBuilderState>();
  final collectionController = Get.find<CollectionController>();

  void _submit() {
    if (_formKey.currentState!.saveAndValidate()) {
      final name = _formKey.currentState!.value['name'];
      final collection = Collection(name, []);
      collectionController.add(collection);
      
      _formKey.currentState?.reset();
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(text: "Create A New Collection"),
      backgroundColor: Constants.canvasBackgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Constants.maxScreenWidth),
          child: FormBuilder(
            key: _formKey,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // center vertically
                  crossAxisAlignment: CrossAxisAlignment.center, // center horizontally
                  children: [
                    Text("Collection Name:", style: TextStyle(fontSize: setFontSize(context))),
                    FormBuilderTextField(
                      name: 'name',
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Name for a collection',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: FormBuilderValidators.required()
                    ), 
                  ],
                ),
              ),
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
              onPressed: _submit,
              child: Text("Save"),
            ),
          ),
        ],
      ),
    );
  }
}

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
                    child: Obx(
                      () => currentCollection.flashcards.length == 0 ?
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
                    ),
                  )
                ],              
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Camera',
          child: Icon(Icons.camera_alt),
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

class QuestionAndAnswerScreen extends StatelessWidget {
  static final _formKey = GlobalKey<FormBuilderState>();
  final collectionController = Get.find<CollectionController>();
  
  void _submit() {
    if (_formKey.currentState!.saveAndValidate()) {
      final indexStr = Get.parameters['index'];
      final index = int.tryParse(indexStr ?? '');
      
      if (index == null) {
        Get.snackbar('Error', 'Invalid collection index');
        return;
      }
      
      final data = _formKey.currentState!.value;

      final qa = QuestionAndAnswer(
        question: data['question'],
        answer: data['answer'],
      );

      final collection = collectionController.collections[index];
      collection.flashcards.add(qa);

      collectionController.updateCollection(index, collection);

      _formKey.currentState?.reset();
      Get.back();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(text: "New Flashcard"),
      backgroundColor: Constants.canvasBackgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Constants.maxScreenWidth),
          child: FormBuilder(
            key: _formKey,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // center vertically
                  crossAxisAlignment: CrossAxisAlignment.center, // center horizontally
                  children: [
                    Text("Question:", style: TextStyle(fontSize: setFontSize(context))),
                    FormBuilderTextField(
                        name: 'question',
                        decoration: const InputDecoration(
                          hintText: 'Question',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: FormBuilderValidators.required(),
                      ),
                      SizedBox(height: 16),
                      Text("Answer:", style: TextStyle(fontSize: setFontSize(context))),
                      FormBuilderTextField(
                        name: 'answer',
                        decoration: const InputDecoration(
                          hintText: 'Answer',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: FormBuilderValidators.required(),
                    ),
                  ],
                ),
              ),
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
              onPressed: _submit,
              child: Text("Save"),
            ),
          ),
        ],
      ),
    );
  }
}

class EditQuestionAndAnswerScreen extends StatelessWidget {
  static final _formKey = GlobalKey<FormBuilderState>();
  final collectionController = Get.find<CollectionController>();
  
  void _submit(int colIndex, int qaIndex) {
    if (_formKey.currentState!.saveAndValidate()) {
      final data = _formKey.currentState!.value;

      final Collection collection = collectionController.collections[colIndex];
      final QuestionAndAnswer qa = collection.flashcards[qaIndex];
      qa.question = data['question'];
      qa.answer = data['answer'];

      collectionController.updateCollection(colIndex, collection);

      _formKey.currentState?.reset();
      Get.back();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final colIndexStr = Get.parameters['colIndex'];
    final colIndex = int.tryParse(colIndexStr ?? '');
    final qaIndexStr = Get.parameters['qaIndex'];
    final qaIndex = int.tryParse(qaIndexStr ?? '');
    
    final bool colIndexOutOfRange = colIndex == null || colIndex < 0 || colIndex >= collectionController.size;

    if (colIndexOutOfRange) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 110, 153, 222),
        appBar: AppBar(
          foregroundColor: Colors.white,
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 27, 39, 93),
          title: Text("Error"),
        ),
        body: Center(child: Text("Invalid collection index")),
      );
    }

    final Collection currentCollection = collectionController.collections[colIndex];
    final bool qaIndexOutOfRange = qaIndex == null || qaIndex < 0 || qaIndex >= currentCollection.flashcards.length;

    if (qaIndexOutOfRange) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 27, 39, 93),
          title: Text("Error"),
          automaticallyImplyLeading: false,
        ),
        backgroundColor: const Color.fromARGB(255, 110, 153, 222),
        body: Center(child: Text("Invalid flashcard index ${qaIndex}. length : ${currentCollection.flashcards.length}")),
      );
    }

    final QuestionAndAnswer qa = currentCollection.flashcards[qaIndex];

    return Scaffold(
      appBar: DefaultAppBar(text: "Edit Flashcard"),
      backgroundColor: Constants.canvasBackgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Constants.maxScreenWidth),
          child: FormBuilder(
            key: _formKey,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // center vertically
                  crossAxisAlignment: CrossAxisAlignment.center, // center horizontally
                  children: [
                    Text("Question:", style: TextStyle(fontSize: setFontSize(context))),
                    FormBuilderTextField(
                        name: 'question',
                        initialValue: '${qa.question}',
                        decoration: const InputDecoration(
                          hintText: 'Question',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.required(),
                    ),
                    SizedBox(height: 16),
                    Text("Answer:", style: TextStyle(fontSize: setFontSize(context))),
                    FormBuilderTextField(
                      name: 'answer',
                      initialValue: '${qa.answer}',
                      decoration: const InputDecoration(
                        hintText: 'Answer',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                      validator: FormBuilderValidators.required(),
                    )
                  ],
                ),
              ),
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
              onPressed: () => _submit(colIndex, qaIndex),
              child: Text("Save"),
            ),
          ),
        ],
      ),
    );
  }
}

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

String resultText(int score, int total) {
  double ratio = score / total;

  if (ratio == 1.0) {
    return "🎉 Perfect score! 🎉";
  } else if (ratio >= 0.75) {
    return "👏 Great job! You're doing really well!";
  } else if (ratio >= 0.50) {
    return "👍 Good effort! Keep practicing!";
  } else if (ratio > 0) {
    return "💪 Don't give up! Keep learning!";
  } else {
    return "😅 Let's try again and do better!";
  }
}

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

    final totalStr = Get.parameters['total'];
    final total = int.tryParse(totalStr ?? '');

    if (total == null) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 110, 153, 222),
        appBar: AppBar(
          foregroundColor: Colors.white,
          centerTitle: true,
          backgroundColor: Constants.appBarBackgroundColor,
          title: Text("Error")
        ),
        body: Center(child: Text("Invalid amount of total amount of flashcards")),
      );
    }

    return Scaffold(
      appBar: DefaultAppBar(text: "Result"),
      backgroundColor: Constants.canvasBackgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Constants.maxScreenWidth),
          child: Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 800),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events, size: 80, color: Colors.amber),
                  SizedBox(height: 24),
                  Text(
                    resultText(score, total),
                    style: TextStyle(
                      fontSize: setFontSize(context),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "You scored",
                    style: TextStyle(fontSize: setFontSize(context), color: Colors.white70),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "$score out of $total",
                    style: TextStyle(
                      fontSize: setFontSize(context),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => Get.offNamed('/'),
                    icon: Icon(Icons.home),
                    label: Text("Back to Home"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}