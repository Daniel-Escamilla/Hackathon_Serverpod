import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'client.dart';
import 'screens/group_screen.dart';
import 'screens/todo_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  runApp(const MyApp());
}

/// Builds a theme for the given [brightness].
ThemeData _buildTheme(Brightness brightness) {
  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: brightness,
    ),
  );
  return base.copyWith(textTheme: GoogleFonts.archivoTextTheme(base.textTheme));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serverpod Demo',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.light,
      home: const MyHomePage(title: 'Hackathon App'),
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
  late final _tabController = TabController(length: 2, vsync: this);

  // Placeholder balance, wired to a real backend value later.
  final int _coins = 0;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/coin.svg',
                  width: 22,
                  height: 22,
                ),
                const SizedBox(width: 4),
                // Reserves room for up to 5 digits (e.g. 10000) so the bar
                // doesn't shift width as the balance grows.
                SizedBox(
                  width: 48,
                  child: Text(
                    '$_coins',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(text: 'Grupo'),
            Tab(text: 'Tareas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          GroupScreen(),
          TodoListScreen(),
        ],
      ),
    );
  }
}
