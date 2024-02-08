import 'package:daily_advices/advice.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int index = 0;
  final List<Widget> screens = [
    const AdviceScreen(),
    const Center(
      child: Text('Work in progress...'),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(fontFamily: 'Poppins', brightness: Brightness.dark),
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: index,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.history_edu), label: 'Advice'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.history), label: 'History'),
              ],
              onTap: (newIndex) => {
                setState(() {
                  index = newIndex;
                })
              },
            ),
            body: screens[index],
          ),
        ));
  }
}
