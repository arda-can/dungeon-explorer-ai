import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/storage_service.dart';
import 'providers/game_provider.dart';
import 'providers/level_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/level_map_screen.dart';
import 'screens/game_screen.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const DungeonExplorerApp());
}

class DungeonExplorerApp extends StatelessWidget {
  const DungeonExplorerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LevelProvider()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: MaterialApp(
        title: GameStrings.appTitle,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: GameColors.darkBg,
          appBarTheme: const AppBarTheme(
            backgroundColor: GameColors.darkBg,
            elevation: 0,
          ),
        ),
        home: const _AppNavigator(),
      ),
    );
  }
}

class _AppNavigator extends StatefulWidget {
  const _AppNavigator({Key? key}) : super(key: key);

  @override
  State<_AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<_AppNavigator> {
  int _currentScreen = 0;
  int _selectedLevel = 0;

  @override
  Widget build(BuildContext context) {
    switch (_currentScreen) {
      case 0:
        return SplashScreen(
          onStart: () {
            setState(() => _currentScreen = 1);
          },
        );
      case 1:
        return LevelMapScreen(
          onLevelSelected: (levelId) {
            setState(() {
              _selectedLevel = levelId;
              _currentScreen = 2;
            });
          },
        );
      case 2:
        return GameScreen(
          levelId: _selectedLevel,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
