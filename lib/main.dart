
import 'package:contextmenu/Menu/context_menu.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Context Menu Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Stack(
            children: [
              
              const Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Text(
                  'CONTEXT MENU',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
            
              Positioned(
                left: constraints.maxWidth / 6,
                top: constraints.maxHeight / 6,
                child: ContextMenu(
                  child: RectangleArea(
                    label: 'Top left',
                    color: Colors.yellow,
                    size: constraints.biggest.shortestSide / 4,
                  ),
                ),
              ),
            
              
              Positioned(
                right: constraints.maxWidth / 6,
                top: constraints.maxHeight / 6,
                child: ContextMenu(
                  child: RectangleArea(
                    label: 'Top right',
                    color: Colors.green,
                    size: constraints.biggest.shortestSide / 4,
                  ),
                ),
              ),
              
              
              Positioned(
                right: constraints.maxWidth / 6,
                bottom: constraints.maxHeight / 6,
                child: ContextMenu(
                  child: RectangleArea(
                    label: 'Bottom right',
                    color: Colors.blue,
                    size: constraints.biggest.shortestSide / 4,
                  ),
                ),
              ),
              
          
              Positioned(
                left: constraints.maxWidth / 6,
                bottom: constraints.maxHeight / 6,
                child: ContextMenu(
                  child: RectangleArea(
                    label: 'Bottom left',
                    color: Colors.purple,
                    size: constraints.biggest.shortestSide / 4,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}