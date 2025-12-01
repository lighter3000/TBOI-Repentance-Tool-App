import 'dart:isolate';

import 'package:application/data/items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:application/main.dart";


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
      Id: 
      ${widget.items[itemId].id}\n
      Name: 
      ${widget.items[itemId].name}\n
      Description: 
      ${widget.items[itemId].desc}\n
      Effect: 
      ${widget.items[itemId].effect}\n
    """;

  }

  ImageProvider getCachedImage(String path) {
    if(!_imageCache.containsKey(path)){
      _imageCache[path] = AssetImage(path);
    }
    return _imageCache[path]!;
  }
}