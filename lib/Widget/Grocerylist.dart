import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping/Model/groceryItem.dart';
import 'package:shopping/Widget/new_item.dart';
import 'package:http/http.dart' as http;
import 'package:shopping/data/Dummy_data.dart';
import 'package:shopping/data/catogries.dart';

class grocerylist extends StatefulWidget{
  const grocerylist({super.key});

  @override
  State<grocerylist> createState() => _grocerylistState();
}

class _grocerylistState extends State<grocerylist> {
  // @override
  List<groceryItem> groceryItems = [];
  var isloading = true;
  String? _error;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadItem();
  }
  void _loadItem() async{
    final url = Uri.https('shopping-c88ba-default-rtdb.firebaseio.com', 'shopping-list.json');
    final response = await http.get(url);
    if(response.statusCode >= 400){
      setState(() {
        _error = "error in fething data";
      });
    }
    final Map<String, dynamic> listdata = json.decode(response.body);
    // print(listdata.length);
    final List<groceryItem> loaded_data = [];
    for(final item in listdata.entries){
      print(1);
      final cat = categories.entries.firstWhere((element) => element.value.title == item.value['category']).value;
      loaded_data.add(
          groceryItem(id: item.key,
              name: item.value['name'],
              quantity: item.value['quantity'],
              category: cat));
    }
    setState(() {
      groceryItems = loaded_data;
      isloading = false;
    });
  }
  void _add_item() async {

    final New_item = await Navigator.of(context).push<groceryItem>(MaterialPageRoute(
        builder: (ctx) => const new_item()));
    if(New_item == null) return;
    setState(() {
      groceryItems.add(New_item);
    });
  }

  Future<void> _removeItem(groceryItem item) async {
    final ind = groceryItems.indexOf(item);
    setState(() {
      groceryItems.remove(item);
    });
    final url = Uri.https('shopping-c88ba-default-rtdb.firebaseio.com', 'shopping-list/${item.id}.json');
    final res = await http.delete(url);
    if(res.statusCode >=400){
      setState(() {
        groceryItems.insert(ind, item);
      });
    }
  }
  Widget content = const Center(child: Text("No content is added yet"),);

  @override
  Widget build(BuildContext context) {
    if(_error != null){
      content = Center(child: Text(_error!),);
    }
    if(isloading){
      content = const Center(child: CircularProgressIndicator(),);
    }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Grocery List"),
        actions: [
          IconButton(
              onPressed: _add_item,
              icon: Icon(Icons.add))
        ],
      ),
      body: ListView.builder(
          itemCount: groceryItems.length,
          itemBuilder: (ctx, ind) => Dismissible(
            onDismissed:(direction){
              _removeItem(groceryItems[ind]);
            },
            key: ValueKey(groceryItems[ind].id),
            child: ListTile(
              title: Text(groceryItems[ind].name),
              leading: Container(
                height: 25,
                width: 25,
                color: groceryItems[ind].category.color,
              ),
              trailing: Text(groceryItems[ind].quantity.toString()),
            ),
          )
      ),
    );

  }
}