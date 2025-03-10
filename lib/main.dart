import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double angleX = 0.0;
  double angleY = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward(); // Start animation forward initially
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/back02.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.dilate(radiusX: 1, radiusY: 1),
              child: Container(
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onPanStart: (_) {
                _controller.stop();
                _controller.repeat();
              },
              onPanEnd: (_) {
                _controller.stop();
                _controller
                    .animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutQuad,
                )
                    .then((_) => _controller.reset());
              },
              onPanUpdate: (details) {
                setState(() {
                  angleX += details.delta.dy * 0.01;
                  angleY += details.delta.dx * 0.01;
                });
              },
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(angleX)
                  ..rotateY(angleY),
                alignment: Alignment.center,
                child: Card(
                  elevation: 40,
                  shadowColor: Colors.green.shade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return ShaderMask(
                          shaderCallback: (rect) {
                            return LinearGradient(
                              begin: Alignment(-1.0, -1.0), // Top-left
                              end: Alignment(1.5, 1.5), // Bottom-right
                              colors: [
                                Colors.white, // Bright start
                                Colors.white.withOpacity(0.5), // Semi-opaque middle
                                Colors.white, // Bright end
                              ],
                              stops: [
                                -0.3, // Start slightly before the card
                                _controller.value, // Animate the middle
                                1.2, // Extend beyond the card
                              ],
                            ).createShader(rect);
                          },
                          child: Image.asset(
                            'assets/images/img.png',
                            width: 250,
                            height: 350,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
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