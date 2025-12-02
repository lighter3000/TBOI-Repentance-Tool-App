import 'package:application/data/items.dart';

class ItemController {
  int index=0;
  String name = "The Sad Onion";
  String desc = "Tears Up";
  String effect = "+0.7 tears.";

  ItemController();

  void setItem(int itemIndex, Item item) {
    index = itemIndex;
    name = item.name;
    desc = item.desc;
    effect = item.effect;
  }
}