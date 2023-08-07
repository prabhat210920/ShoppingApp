import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping/Model/category.dart';
import 'package:shopping/Model/groceryItem.dart';
import 'package:shopping/data/catogries.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class new_item extends StatefulWidget{
  const new_item({super.key});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _new_item();
  }

}

class _new_item extends State<new_item>{
  final _formKey = GlobalKey<FormState>();
  var enteredName = '';
  var enteredQuantity = 1;
  var selectedCategory = categories[Categories.dairy];
  var isSending = false;
  // void _loadItem() async{
  //   final url = Uri.https('shopping-c88ba-default-rtdb.firebaseio.com', 'shopping-list.json');
  //   final response = await http.get(url);
  //   // final map<String, map<String, Dynamic>>
  //   final Map<String, Map<String, dynamic>> listdata = json.decode(response.body);
  //   print(response.body);
  // }
  void _addData() async {

    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      setState(() {
        isSending = true;
      });
      final url = Uri.https('shopping-c88ba-default-rtdb.firebaseio.com', 'shopping-list.json');
      final response = await http.post(url,
        headers: {'Content': 'Application/json'},
        body: json.encode({
          'name': enteredName,
          'quantity': enteredQuantity,
          'category': selectedCategory!.id
        }),
      );
      final Map<String, dynamic> resdata = json.decode(response.body);
      if(!context.mounted) return;
      print(resdata);

      Navigator.of(context).pop(groceryItem(id: resdata['name'],
          name: enteredName,
          quantity: enteredQuantity,
          category: selectedCategory!));
    }

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Add an new Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: InputDecoration(
                  label: Text("Item Name"),

                ),
                validator: (value){
                  if(value == null || value.trim().length <= 1 ||
                      value.isEmpty ||value.trim().length > 50){
                    return "value size must be between 1 to 50";
                  }
                  return null;
                },
                onSaved: (value){
                  enteredName = value!;
                },

                // onSaved: ,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        label: Text("Quantity"),
                      ),
                      initialValue: enteredQuantity.toString(),
                      validator: (value){
                        if(value == null ||
                        value.isEmpty||
                        int.tryParse(value) == null||
                        int.tryParse(value)! <= 0){
                          return "Must fill a valid positive number";
                        }
                        return null;
                      },
                      onSaved: (value){
                        enteredQuantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(width:10,),
                  Expanded(
                    child: DropdownButtonFormField(
                        value: selectedCategory,
                        items: [
                      for(final category in categories.entries)
                        DropdownMenuItem(
                          value: category.value,
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                color: category.value.color,
                              ),
                              const SizedBox(width: 10,),
                              Text(category.value.id)
                            ],
                          ),
                        )
                      ], onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });

                    } ),
                  )

                ],
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // MainAxisAlignment: Main
                  TextButton(
                    onPressed: () {},
                      child: const Text("Reset"),
                  ),
                  ElevatedButton(onPressed: isSending ? null: _addData,
                      child: isSending?
                          const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          ):
                      Text("Submit")
                  ),
                ],
              ),
            ],
          )
        ),
      ),
    );
  }
}