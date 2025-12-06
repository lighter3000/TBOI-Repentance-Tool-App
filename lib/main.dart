import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'package:application/spindownPage.dart';
import 'package:application/settingPage.dart';

import 'package:application/data/items.dart';

import 'package:application/backgroundWrapper.dart';

import 'package:google_fonts/google_fonts.dart';

import 'globals.dart' as globals;



void main() async{

  WidgetsFlutterBinding.ensureInitialized();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Spindown Dice App',
        theme: ThemeData(
          colorScheme: ColorScheme(
            brightness: Brightness.dark,

            // Primary = main UI accent (buttons, sliders etc.)
            primary: const Color(0xFF8F6D57),       // stone border color
            onPrimary: const Color(0xFF2C1A14),

            // Secondary = supporting accents
            secondary: const Color(0xFF7E4A37),     // inner wood tone
            onSecondary: const Color(0xFF2C1A14),

            // Tertiary = optional accents (e.g. highlights)
            tertiary: const Color(0xFFC59A7A),      // light beige highlights
            onTertiary: const Color(0xFF3C1F16),

            // Background colors (app-level background)
            background: const Color(0xFF3C1F16),    // deep dark brown (shadow)
            onBackground: const Color(0xFFE5D3C0),

            // Surface = cards, sheets, panels
            surface: const Color(0xFF6C3A2C),       // inner panel color
            onSurface: const Color(0xFFE8D2C0),

            // Error colors (you can keep defaults or theme them too)
            error: Colors.red,
            onError: Colors.black,
          ),
        ),
        home: MyHomePage(title: 'Spindown Dice App Home Page'),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {

  var emails = 20;
  bool showItemId = true;
  bool showDarkText = false;
  bool showItemDesc = false;

  void toggleShowItemId(bool value) {
    showItemId = value;
    notifyListeners();
  }

  void toggleTextColor(bool value) {
    showDarkText = value;
    notifyListeners();
  }

  void toggleShowItemDesc(bool value) {
    showItemDesc = value;
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  var showItemId = true;



  @override
  Widget build(BuildContext context) {
    
    Widget page;
    switch(selectedIndex) {
      case 0:
        page = MainPage();
        break;
      case 1:
        page = SpindownPage();
        break;
      case 2:
        page = SettingPage();
        break;
      default:
        throw UnimplementedError("No widget for $selectedIndex");
    }

    return LayoutBuilder(
      builder: (context, constraints) {

        return Scaffold(
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedIndex,
            indicatorColor: Colors.amber,
            destinations: [
              NavigationDestination(icon: Icon(Icons.home), label: "Home"),
              NavigationDestination(icon: ImageIcon(AssetImage("assets/icon/d20.png")), label: "Spindown Dice"),
              NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
            ],
            onDestinationSelected: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
          ),
          body: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: page,
          ),
        );
      }
    );
  }
}

class MainPage extends StatelessWidget {
  
  
  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();
    var emails = 20;

    var appState = context.watch<MyAppState>();
    Color textColor = appState.showDarkText ? globals.textColorDark : globals.textColorLight;

    return Backgroundwrapper(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 30, 30),
            child: Column(
              children: [
                Stack(
                  children: [
                    FittedBox(
                      fit: BoxFit.fill,
                      child: Image(
                        image: AssetImage("assets/textures/selectionwidget.png"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10,0,0,0),
                      child: Text(
                        "Tools",
                        style: GoogleFonts.oswald(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: globals.textColorDark, // #46393b
                          shadows: [
                              Shadow(
                                  blurRadius: 4.0,  // shadow blur
                                    color: Color.fromARGB(255, 82, 70, 72), // shadow color
                                    offset: Offset(2.0,2.0), // how much shadow will be shown
                              ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 40,),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(80, 10, 0, 0),
                      child: FittedBox(
                        child: Transform.scale(
                          scaleX: 2.5,
                          scaleY: 2,
                          child: Image(
                            image: AssetImage("assets/textures/selectionwidget.png")
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Text(
                        "Spindown Dice Tool",
                        style: GoogleFonts.oswald(
                          fontSize: 32,
                          fontWeight: FontWeight.w400,
                          color: globals.textColorDark, // #46393b
                          shadows: [
                              Shadow(
                                  blurRadius: 4.0,  // shadow blur
                                    color: Color.fromARGB(255, 82, 70, 72), // shadow color
                                    offset: Offset(2.0,2.0), // how much shadow will be shown
                              ),
                          ],
                        ),
                      ), 
                    )
                  ]
                ),

              ],
            ),
          ),
        ],
    ),
    );
  }

}



