import 'dart:ui';
import 'package:flutter/material.dart';
import 'game_logic.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  late GameLogic gameLogic;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool isDialogVisible = false;
  bool isWin = false;

  @override
  void initState() {
    super.initState();
    gameLogic = GameLogic();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (var i = 0; i < 7; i++) {
      precacheImage(AssetImage('assets/images/hangman$i.png'), context);
    }
    gameLogic.initializeGame();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void onLetterPressed(String letter) {
    setState(() {
      gameLogic.onLetterPressed(letter);

      if (gameLogic.getIsGameOver()) {
        _showEndGameDialog(isWin: !gameLogic.getDisplayedWord().contains('_'));
      }
    });
  }

  void onRetry({bool isNextRound = false}) {
    _hideEndGameDialog();
    Future.delayed(const Duration(milliseconds: 150), () {
      setState(() {
        gameLogic.initializeGame(isNextRound: isNextRound);
      });
    });
  }

  void _showEndGameDialog({required bool isWin}) {
    setState(() {
      this.isWin = isWin;
      isDialogVisible = true;
    });
    _animationController.forward();
  }

  void _hideEndGameDialog() {
    _animationController.reverse().then((_) {
      setState(() {
        isDialogVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              "assets/images/start.png", // Same background as StartPage
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Game title
              Text(
                "HANGMAN GAME",
                style: TextStyle(
                  fontFamily: 'hangmanTitle', // Same font as StartPage title
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 5.0,
                      color: Colors.black.withValues(alpha: .5),
                    ),
                  ],
                ),
              ),
              // Hangman image
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  gameLogic.getHangmanImage(),
                  height: screenHeight * 0.3,
                ),
              ),
              // Word display
              Text(
                gameLogic.getDisplayedWord(),
                style: TextStyle(
                  fontFamily: 'hangmanTitle', // Same font as Start button
                  fontSize: 50,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              // Lives and streak
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: screenWidth * 0.06,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Lives: ${gameLogic.getLives()} ||',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    'Streak: ${gameLogic.getStreak()}',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              // Alphabet buttons
              Expanded(
                child: Center(
                    child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 26,
                  itemBuilder: (context, index) {
                    String letter = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"[index];
                    bool isUsed = gameLogic.guessedLetters.contains(letter);

                    return Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed:
                            isUsed ? null : () => onLetterPressed(letter),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors
                              .transparent, // Ensure transparency for gradient
                          shadowColor: Colors.black.withValues(alpha: .5),
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Smooth corners
                            side: BorderSide(
                              color: Colors
                                  .white, // White border around the button
                              width: 2,
                            ),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isUsed
                                  ? [
                                      const Color.fromARGB(255, 79, 2, 67), // Purple shade for clicked
                                      const Color.fromARGB(255, 230, 7, 238),
                                    ]
                                  : [
                                      const Color.fromARGB(
                                          255, 0, 0, 0), // Black
                                      const Color.fromARGB(
                                          255, 50, 50, 50), // Grey
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(
                                12), // Same corner radius as border
                          ),
                          child: Center(
                            child: Text(
                              letter,
                              style: TextStyle(
                                fontFamily: 'buttonFont', // Retro font
                                fontSize: 24,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 4.0,
                                    color: Colors.black
                                        .withValues(alpha: .5), // Retro text shadow
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )),
              ),
            ],
          ),
          // Dialog box
          if (isDialogVisible)
            FadeTransition(
              opacity: _fadeAnimation,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                // Inside FadeTransition in _showEndGameDialog
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 0, 0, 0), // Black
                          const Color.fromARGB(255, 50, 50, 50), // Grey
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20), // Smooth corners
                      border: Border.all(
                        color: const Color.fromARGB(
                            255, 255, 255, 255), // White border
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .5),
                          blurRadius: 10,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isWin ? "You Win!" : "Game Over",
                          style: TextStyle(
                            fontFamily: 'buttonFont',
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 4.0,
                                color: Colors.black.withValues(alpha: .5),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          isWin
                              ? "Congratulations! You've guessed the word."
                              : "The word was: ${gameLogic.wordToGuess}",
                          style: TextStyle(
                            fontFamily: 'buttonFont',
                            fontSize: 30,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 4.0,
                                color: Colors.black.withValues(alpha: .5),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => onRetry(isNextRound: isWin),
                          style: ElevatedButton.styleFrom(
                            
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.black.withValues(alpha: .5),
                            elevation: 10.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                width: 2,
                              ),
                            ),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color.fromARGB(255, 0, 0, 0),
                                  const Color.fromARGB(255, 50, 50, 50),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: Text(
                                isWin ? "Next Round" : "Retry",
                                style: TextStyle(
                                  fontFamily: 'buttonFont',
                                  fontSize: 30,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 4.0,
                                      color: Colors.black.withValues(alpha: .5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
