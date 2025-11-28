import 'dart:isolate';

import 'package:application/data/items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
class SpindownPage extends StatefulWidget {
  
  final List<Item> items;
  SpindownPage({required this.items});

  
  
  @override
  State<SpindownPage> createState() => _SpindownPageState();
}


class _SpindownPageState extends State<SpindownPage> {

  final ScrollController _scrollController = ScrollController();
  final _imageCache = <String, ImageProvider>{};
  final TextEditingController _ItemDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [
                SizedBox(height: 24),
                Text("What Item do you search for?\nEnter either one", textAlign: TextAlign.center,),
                SizedBox(height: 12,),
                Row(
                
                  children: [
                
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Search by Item Name"),
                          SizedBox(height: 8,),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder()
                            ),
                            onSubmitted: (value) {
                              final itemName = value;
                              if (itemName != null){
                                scrollToItemName(itemName);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(width: 20,),
                    
                    
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Search by Item Id:"),
                          SizedBox(height: 8,),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder()
                            ),
                            onSubmitted: (value) {
                              final itemId = int.tryParse(value);
                              if (itemId != null) {
                                scrollToItemId(itemId);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30,),

                Column(
                  children: [
                    SizedBox(
                      height: 240,
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        cacheExtent: 500,
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                    showDescription(index); // widget.items[index].id wont work, because some ids arent taken
                                  },
                                  child: Ink(
                                    width: 150,
                                    //margin: EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(widget.items[index].name),
                                        SizedBox(height: 2,),
                                        Image(
                                          image: getCachedImage(widget.items[index].imagePath)
                                        ),
                                        SizedBox(height: 2,),
                                        if(appState.showItemId)
                                          Text("Item id: ${widget.items[index].id}"),
                                      ],
                                    )
                                  )
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text("Description:\n", textAlign: TextAlign.center,),
                      if(true)
                        TextField(
                          controller: _ItemDescriptionController,
                          readOnly: true,
                          maxLines: null,
                        ),
                    ],
                  ),
                ),

                Placeholder(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void scrollToItemId(int itemId) {
    final index = widget.items.indexWhere((item) => item.id == itemId);

    if (index == -1) return; // Not found

    const double itemWidth = 150 + 16;
    final double position = index * itemWidth;

    _scrollController.animateTo(
      position, 
      duration: Duration(milliseconds: 500), 
      curve: Curves.easeInOut
    );
  }

  void scrollToItemName(String itemName) {
    final index = widget.items.indexWhere((item) => item.name.toLowerCase().contains(itemName.toLowerCase()));

    if (index == -1) return; // Not found

    const double itemWidth = 150 + 16;
    final double position = index * itemWidth;

    _scrollController.animateTo(
      position, 
      duration: Duration(milliseconds: 500), 
      curve: Curves.easeInOut
    );
  }

  void showDescription(int itemId) {
    _ItemDescriptionController.text = """
      Id: ${widget.items[itemId].id}\n
      Name: ${widget.items[itemId].name}\n
      Description: ${widget.items[itemId].desc}\n
      Effect: ${widget.items[itemId].effect}\n
    """;

  }

  ImageProvider getCachedImage(String path) {
    if(!_imageCache.containsKey(path)){
      _imageCache[path] = AssetImage(path);
    }
    return _imageCache[path]!;
  }
}

class SettingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    
    return ListView(
      padding: (const EdgeInsets.all(20)),
      children: [
        Column(
          children: [
            Row(
              children: [
                Text("Show Item id:"),
                Checkbox(
                  value: appState.showItemId, 
                  onChanged: (bool? value) {
                      appState.toggleShowItemId(value!);
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text("Show Item description:"),
                Checkbox(
                  value: appState.showItemDesc, 
                  onChanged: (bool? value) {
                      appState.toggleShowItemDesc(value!);
                  },
                ),
              ],
            ),
          ],
        ),
        Placeholder(),

        const SizedBox(height: 30,),

        // Icon Credit
        ListTile(
          title: const Text(
            "Icon Credits",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text(
            "D20 Icons created by Freepik - Flaticon\n"
            "https://www.flaticon.com/de/kostenlose-icons/d20",
          ),
          leading: Icon(Icons.info_outline),
        ),
        ListTile(
          title: const Text(
            "Image Source Credits",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text(
            "All 717 Item Images sourced by u/Villainero - Reddit\n"
            "https://www.reddit.com/r/bindingofisaac/comments/14la4cn/made_a_user_friendly_512x512_png_set_of_all/"
          ),
          leading: Icon(Icons.info_outline),
        )
      ],
    );
  }
}
