import 'dart:isolate';

import 'package:application/backgroundWrapper.dart';
import 'package:application/data/items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:application/main.dart";


class SettingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    
    return Backgroundwrapper(
      child: ListView(
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
              "Item Image Source Credits",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              "All 717 Item Images sourced by u/Villainero - Reddit\n"
              "https://www.reddit.com/r/bindingofisaac/comments/14la4cn/made_a_user_friendly_512x512_png_set_of_all/"
            ),
            leading: Icon(Icons.info_outline),
          ),
          ListTile(
            title: const Text(
              "Background Image Source Credits",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              "Image downloaded from u/Tsiurtla - Reddit - Image owned by Niantic\n"
              "https://www.reddit.com/r/bindingofisaac/comments/dx959n/for_anybody_who_needs_it_a_doorless_basement/"
            ),
            leading: Icon(Icons.info_outline),
          ),
          ListTile(
            title: const Text(
              "Item Description / Information Source",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              "All the Description and Effect Description is sourced from: \n"
              "https://bindingofisaacrebirth.fandom.com/wiki/Items"
            ),
            leading: Icon(Icons.info_outline),
          ),
        ],
      ),
    );
  }
}