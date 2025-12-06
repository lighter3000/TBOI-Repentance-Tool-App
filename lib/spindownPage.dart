import 'dart:isolate';

import 'package:application/backgroundWrapper.dart';
import 'package:application/data/items.dart';
import 'package:application/repository/item_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:application/main.dart";
import "package:application/itemController.dart";

import 'package:google_fonts/google_fonts.dart';

import 'globals.dart' as globals;



class SpindownPage extends StatefulWidget {
  SpindownPage();

  
  
  @override
  State<SpindownPage> createState() => _SpindownPageState();

}


class _SpindownPageState extends State<SpindownPage> {

  final ScrollController _scrollController = ScrollController();
  final _imageCache = <String, ImageProvider>{};

  final ItemController _selectedItem = ItemController();

  final ItemRepository _repo = ItemRepository();
  List<Item> _itemsFromDb = [];
  bool _loadingItems = true;

  @override
  void initState() {
    super.initState();
    _repo.getAllItems().then((items) {
      setState(() {
        _itemsFromDb = items;
        _loadingItems = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    if (_loadingItems) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    var appState = context.watch<MyAppState>();

    Color textColor = appState.showDarkText ? globals.textColorDark : globals.textColorLight;
    

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 100, // I know, no magic numbers, i dont know why 100 works, but it works  
        ),
        child: Backgroundwrapper(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 40, 40, 60),
                child: Column(
                  children: [
                    SizedBox(height: 24),
                    Text(
                      "What Item do you search for?\nEnter either one",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.oswald(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: textColor, // #46393b #e1dcbf
                        shadows: [
                            Shadow(
                                blurRadius: 4.0,  // shadow blur
                                  color: globals.shadowColor, // shadow color
                                  offset: Offset(2.0,2.0), // how much shadow will be shown
                            ),
                        ],
                      ),
                    ),
                    //Text("What Item do you search for?\nEnter either one", textAlign: TextAlign.center,),
                    SizedBox(height: 12,),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Text(
                                      "Search by Item Name:",
                                      style: GoogleFonts.oswald(
                                        fontSize: 15, // 15
                                        fontWeight: FontWeight.w400,
                                        color: textColor, // #46393b
                                        decorationColor: Colors.green,
                                        shadows: [
                                            Shadow(
                                                blurRadius: 4.0,  // shadow blur
                                                  color: globals.shadowColor, // shadow color
                                                  offset: Offset(2.0,2.0), // how much shadow will be shown
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8,),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15,5,0,0),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0,5,0,0),
                                        child: FittedBox(
                                          fit: BoxFit.fill,
                                          child: Transform.scale(
                                            scaleX: 1.25,
                                            scaleY: 1.5,
                                            child: Image(
                                              image: AssetImage("assets/textures/selectionwidget.png"),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0,0,0,0),
                                        child: TextField(
                                          style: TextStyle(color: globals.textColorDark),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                          onSubmitted: (value) {
                                            final itemName = value;
                                            if (itemName != null){
                                              scrollToItemName(itemName);
                                            }
                                          },
                                        ),
                                      ),
                                    ]
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(width: 20,),
                          
                          
                          
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Search by Item Id:",
                                  style: GoogleFonts.oswald(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: textColor, // #46393b
                                    shadows: [
                                        Shadow(
                                            blurRadius: 4.0,  // shadow blur
                                              color: globals.shadowColor, // shadow color
                                              offset: Offset(2.0,2.0), // how much shadow will be shown
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8,),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15,5,0,0),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0,5,0,0),
                                        child: FittedBox(
                                          fit: BoxFit.fill,
                                          child: Transform.scale(
                                            scaleX: 1.25,
                                            scaleY: 1.5,
                                            child: Image(
                                              image: AssetImage("assets/textures/selectionwidget.png"),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0,0,0,0),
                                        child: TextField(
                                          style: TextStyle(color: globals.textColorDark),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                          onSubmitted: (value) {
                                            final itemId = int.tryParse(value);
                                            if (itemId != null) {
                                              scrollToItemId(itemId);
                                            }
                                          },
                                        ),
                                      ),
                                    ]
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                            itemCount: _itemsFromDb.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                        showDescription(index); // _itemsFromDb[index].id wont work, because some ids arent taken
                                      },
                                      child: Ink(
                                        width: 150,
                                        //margin: EdgeInsets.symmetric(horizontal: 8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          // before color: const Color.fromARGB(255, 121, 92, 74),
                                          image: DecorationImage(
                                            image: AssetImage("assets/textures/itemshow_widget.png"),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              _itemsFromDb[index].name,
                                              style: GoogleFonts.oswald(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: globals.textColorDark, // #46393b textColor Color.fromARGB(255, 63, 48, 29)
                                                shadows: [
                                                    Shadow(
                                                        blurRadius: 4.0,  // shadow blur
                                                          color: globals.shadowColor, // shadow color
                                                          offset: Offset(2.0,2.0), // how much shadow will be shown
                                                    ),
                                                ],
                                              ),
                                            ),
                                            //Text(_itemsFromDb[index].name, style: TextStyle(color: Colors.black)),
                                            SizedBox(height: 2,),
                                            Image(
                                              image: getCachedImage(_itemsFromDb[index].imagePath)
                                            ),
                                            SizedBox(height: 2,),
                                            if(appState.showItemId)
                                              Text(
                                                "Item Id: ${_itemsFromDb[index].id}",
                                                style: GoogleFonts.oswald(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                  color: globals.textColorDark, // #46393b
                                                  shadows: [
                                                      Shadow(
                                                          blurRadius: 4.0,  // shadow blur
                                                            color: globals.shadowColor, // shadow color
                                                            offset: Offset(2.0,2.0), // how much shadow will be shown
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              //Text("Item id: ${_itemsFromDb[index].id}", style: TextStyle(color: Colors.black),),
                                          ],
                                        )
                                      ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(true)
                              Padding(
                                padding: const EdgeInsets.only(left: 22.0), // shift TextField too
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Name: \t${_selectedItem.name}",
                                                style: GoogleFonts.oswald(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400,
                                                  color: textColor, // #46393b
                                                  shadows: [
                                                      Shadow(
                                                          blurRadius: 4.0,  // shadow blur
                                                            color: globals.shadowColor, // shadow color
                                                            offset: Offset(2.0,2.0), // how much shadow will be shown
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                "ID: \t\t\t\t\t\t\t\t${_itemsFromDb[_selectedItem.index].id.toString()}",
                                                style: GoogleFonts.oswald(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400,
                                                  color: textColor, // #46393b
                                                  shadows: [
                                                      Shadow(
                                                          blurRadius: 4.0,  // shadow blur
                                                            color: globals.shadowColor, // shadow color
                                                            offset: Offset(2.0,2.0), // how much shadow will be shown
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              //Text("Name: \t${_selectedItem.name}"),
                                              //Text("ID: \t\t\t\t\t\t\t\t${_itemsFromDb[_selectedItem.index].id.toString()}"),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: Stack(
                                            clipBehavior: Clip.none,   // THIS allows overflow
                                            children: [
                                              /*
                                              Positioned(
                                                top: 65,
                                                left: -10,
                                                child: Transform.scale(
                                                  scale: 0.5,
                                                  child: Image.asset("assets/textures/item_pedestal_widget_test.png"),
                                                ),
                                              ),
                                              */ // Not fully right yet
                                              Image(
                                                fit: BoxFit.contain,
                                                image: getCachedImage(_itemsFromDb[_selectedItem.index].imagePath),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 4,),
                                    Text(
                                      "Description: ${_selectedItem.desc}",
                                      style: GoogleFonts.oswald(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: textColor, // #46393b
                                        shadows: [
                                            Shadow(
                                                blurRadius: 4.0,  // shadow blur
                                                  color: globals.shadowColor, // shadow color
                                                  offset: Offset(2.0,2.0), // how much shadow will be shown
                                            ),
                                        ],
                                      ),
                                    ),
                                    //Text("Description: ${_selectedItem.desc}"), // Desc
                                    SizedBox(height: 8,),
                                    Text(
                                      "Effect: ${_selectedItem.effect}",
                                      style: GoogleFonts.oswald(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: textColor, // #46393b
                                        shadows: [
                                            Shadow(
                                                blurRadius: 4.0,  // shadow blur
                                                  color: globals.shadowColor, // shadow color
                                                  offset: Offset(2.0,2.0), // how much shadow will be shown
                                            ),
                                        ],
                                      ),
                                    ),
                                    //Text("Effect: ${_selectedItem.effect}") // Effect
                                    ],
                                )
                              ),
                          ],
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void scrollToItemId(int itemId) {
    final index = _itemsFromDb.indexWhere((item) => item.id == itemId);

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
    final index = _itemsFromDb.indexWhere((item) => item.name.toLowerCase().contains(itemName.toLowerCase()));

    if (index == -1) return; // Not found

    const double itemWidth = 150 + 16;
    final double position = index * itemWidth;

    _scrollController.animateTo(
      position, 
      duration: Duration(milliseconds: 500), 
      curve: Curves.easeInOut
    );
  }

  void showDescription(int index) {
    _selectedItem.setItem(index, _itemsFromDb[index]);
    setState(() {
      
    });
  }

  ImageProvider getCachedImage(String path) {
    if(!_imageCache.containsKey(path)){
      _imageCache[path] = AssetImage(path);
    }
    return _imageCache[path]!;
  }
}