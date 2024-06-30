import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xemphim/common/languageManager.dart';
import 'package:xemphim/screens/splash/splash_screen.dart';
import 'package:xemphim/common/session_manager.dart'; // Import your SessionManager

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SessionManager.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageManager()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, theme, _) {
          return MaterialApp(
            title: 'Movie App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.black,
              scaffoldBackgroundColor: Colors.grey[900],
              colorScheme: ColorScheme.dark(),
            ),
            themeMode: theme.themeMode,
            home: SplashScreen(),
            onGenerateRoute: (settings) {
              if (settings.name == '/logout') {
                // Clear session when logging out
                SessionManager.clearSession();
                return MaterialPageRoute(builder: (context) => SplashScreen());
              }
              return null;
            },
          );
        },
      ),
    );
  }
}

class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark; // Set default theme to dark

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }
}
