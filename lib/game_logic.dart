import 'dart:math';
import 'word_list.dart';

class GameLogic {
  late String wordToGuess; // The word to guess
  late List<String> displayedWord; // The displayed word (with blanks)
  Set<String> guessedLetters = {}; // A set to track guessed letters
  int lives = 6; // Number of lives
  bool isGameOver = false; // To check if the game is over
  int streak = 0; // Tracks the number of consecutive wins

  // Function to initialize the game
  void initializeGame({bool isNextRound = false}) {
    var random = Random();
    wordToGuess = wordList[random.nextInt(wordList.length)].toUpperCase();
    displayedWord = List.generate(wordToGuess.length, (_) => '_');
    guessedLetters.clear();
    lives = 6; // Reset lives
    isGameOver = false; // Reset game over state

    if (!isNextRound) {
      streak = 0; // Reset streak for a new game
    }
  }

  String getHangmanImage() {
    return 'assets/images/hangman$lives.png'; // Returns image path based on lives
  }

  // Function to handle letter presses
  void onLetterPressed(String letter) {
    if (isGameOver) return;

    guessedLetters.add(letter);

    // Check if the letter is in the word
    bool isLetterCorrect = false;

    for (int i = 0; i < wordToGuess.length; i++) {
      if (wordToGuess[i] == letter.toUpperCase()) {
        displayedWord[i] = letter.toUpperCase();
        isLetterCorrect = true;
      }
    }

    // If the letter is incorrect, reduce lives
    if (!isLetterCorrect) {
      lives--;
    }

    // If no lives are left, the game is over
    if (lives <= 0) {
      isGameOver = true;
    }

    // If the word has been guessed correctly
    if (!displayedWord.contains('_')) {
      isGameOver = true;
      streak++; // Increment streak
    }
  }

  String getDisplayedWord() {
    return displayedWord.join(' ');
  }

  Set<String> getGuessedLetters() {
    return guessedLetters;
  }

  int getLives() {
    return lives;
  }

  bool getIsGameOver() {
    return isGameOver;
  }

  int getStreak() {
    return streak;
  }
}