# Quiz Application

## Application idea and purpose
The idea of this application is to help users learn words or some other information with the help of flashcards. This is something similar to "Quizlet", but does not have that much functionality. 

## 🌐 Live Demo
[Click here to try it out](https://dad-first-project.web.app/)

## Brief instructions on how to use the application
When the application is started, the home screen is shown. To add a new collection a button named "Add New Collection" should be pressed. This button navigates the user to the screen with one text field. After typing and saving the collection name, the "Save" button navigates back to home screen. A new box with the given name should be shown. Additionally this box contains four icon buttons: Delete, Edit, Learn and Quiz. When clicking "Delete" button a pop up window is shown and asks the user if she/he really want to delete the collection.

Currently, before doing anything else, the user should see amount of flashcards added to the collection (shown below the collection name). When the user clicks on "Edit" button a new screen will be shown. There flashcards can be added by clicking the "New Flashcard" button. After clicking the button the user is shown a screen with two text field, one for question and one for answer. After filling the information the "Save" button should be clicked. Now, a new flashcard is shown in the collection. Flashcards can be edited and deleted.

When going back to Home screen, "Learn" and "Quiz" buttons should now be clickable. When pressing "Learn" button the user should see one of the flashcards. If clicking on the flashcard, the answer is shown. For learning purposes, flashcards are randomized in both "Learn" and "Quiz" screens.
If clicking the "Quiz" button instead, the user is navigated to the screen, where she/he can test her/his knowledge. The screen shows two buttons "thumb-down" and "thumb-up". The next question is shown only after clicking one of those buttons. At the end of the quiz the amount of correct answers is shown.


## 🔧 In Development

- **Text recognition from images** (branch: `read-text-from-image-functionality`)
  - Use a photo of a schoolbook to auto-generate flashcards.
- **Camera integration** (branch: `camera`)
  - Take pictures directly in the app instead of uploading via File Explorer.