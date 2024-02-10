import 'package:daily_advices/advice.dart';
import 'package:daily_advices/history.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const isDarkKey = '@sharedpreferences:isDark';

class Tab {
  final String title;
  final Widget screen;

  Tab({required this.title, required this.screen});
}

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
  final List<Tab> tabs = [
    Tab(title: '', screen: const AdviceScreen()),
    Tab(title: 'Advice history', screen: const HistoryScreen()),
  ];
  bool isDark = true;

  @override
  void initState() {
    super.initState();
    loadThemeMode();
  }

  void loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      isDark = prefs.getBool(isDarkKey) ?? true;
    });
  }

  void switchThemeMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool(isDarkKey, value);

    setState(() {
      isDark = prefs.getBool(isDarkKey) ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            fontFamily: 'Poppins',
            brightness: isDark ? Brightness.dark : Brightness.light),
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              actions: [
                Row(
                  children: [
                    Icon(isDark ? Icons.dark_mode : Icons.light_mode, size: 32),
                    const SizedBox(
                      width: 8,
                    ),
                    Switch(value: isDark, onChanged: switchThemeMode)
                  ],
                )
              ],
              title: Text(tabs[index].title),
            ),
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
            body: tabs[index].screen,
          ),
        ));
  }
}
