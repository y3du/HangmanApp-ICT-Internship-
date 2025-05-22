import 'package:flutter/material.dart';
import 'package:hangman/game_page.dart';

class StartPage extends StatelessWidget {
  // Start the game when the button is pressed
  void startgame(BuildContext context) {
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => GamePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var curve = Curves.easeInOut;
        var tween = Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
        var scaleAnimation = animation.drive(tween);

        return ScaleTransition(
          scale: scaleAnimation,
          child: child,
        );
      },
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              "assets/images/start.png",
              fit: BoxFit.cover, // Make the image cover the entire background
            ),
          ),
          // Centered button overlay
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "HANGMAN",
                style: TextStyle(
                  fontFamily: 'hangmanTitle',
                  fontSize: 90,
                  fontWeight: FontWeight.bold,
                  color: Colors
                      .white, // Ensures good visibility over the background
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 5.0,
                      color: Colors.black.withValues(alpha: .5),
                    ),
                  ],
                ),
              ),
              Image.asset(
                "assets/images/hangman0.png",
                width: 300,
                height: 300,
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () =>
                      startgame(context), // Pass context to startgame
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero, // Remove default padding
                    backgroundColor:
                        Colors.transparent, // Transparent to allow gradient
                    shadowColor: Colors.black.withValues(alpha: .5),
                    elevation: 20.0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                      side: BorderSide(
                        color: const Color.fromARGB(
                            255, 255, 255, 255), // Retro contrasting border
                        width: 2,
                      ),
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 0, 0, 0),
                          const Color.fromARGB(255, 0, 0, 0)
                        ], // Retro gradient colors
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 5), // Minimal padding for text
                      child: Text(
                        "START",
                        style: TextStyle(
                          fontFamily: 'buttonFont', // Use a retro font
                          fontSize: 60, // Adjust font size
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 4.0,
                              color: Colors.black.withValues(
                                  alpha: .5), // Text shadow for retro effect
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
