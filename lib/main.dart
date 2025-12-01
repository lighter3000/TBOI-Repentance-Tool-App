import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:application/spindownPage.dart';
import 'package:application/settingPage.dart';

import 'package:application/data/items.dart';



void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  // Load items async in a background isolate
  final loadedItems = await Isolate.run(() => loadItems());


  runApp(MyApp(items: loadedItems));
}

class MyApp extends StatelessWidget {
  final List<Item> items;
  const MyApp({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Spindown Dice App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: MyHomePage(title: 'Spindown Dice App Home Page', items: items),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {

  var emails = 20;
  bool showItemId = true;
  bool showItemDesc = false;

  void toggleShowItemId(bool value) {
    showItemId = value;
    notifyListeners();
  }

  void toggleShowItemDesc(bool value) {
    showItemDesc = value;
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  final List<Item> items;
  const MyHomePage({super.key, required this.title, required this.items});

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
        page = SpindownPage(
            items: widget.items
          );
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

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text("You have ${emails} Emails") 
        ),
      ],
    );
  }

}



