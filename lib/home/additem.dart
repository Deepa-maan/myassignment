import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';

import '../db/dbhelper.dart';
import '../model/item.dart';


class AddItemScreen extends StatefulWidget {
  final Item? item;

  AddItemScreen({this.item});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  int _rating = 1;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nameController.text = widget.item!.name;
      _descriptionController.text = widget.item!.description;
      _imageUrlController.text = widget.item!.imageUrl;
      _rating = widget.item!.rating;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add New Item' : 'Edit Item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Item Name',),
                
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Description',),
                
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.length < 10) {
                    return 'Description must be at least 10 characters';
                  }
                  return null;
                },
                maxLines: 5,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Image URL',
                              hintText: "https://picsum.photos/250?image=9"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: _rating,
                decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Rating',),
                
                items: [1, 2, 3, 4, 5].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _rating = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),
              FilledButton(
                  onPressed: _submitForm,
              child: Text(widget.item == null ? 'Add Item' : 'Update Item'),
              ),
            
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newItem = Item(
        id: widget.item?.id,
        name: _nameController.text,
        description: _descriptionController.text,
        imageUrl: _imageUrlController.text,
        timeAdded: widget.item?.timeAdded ?? "",
        rating: _rating,
        numberOfViews: widget.item?.numberOfViews ?? 0,
      );

      if (widget.item == null) {
        await DatabaseHelper().insertItem(newItem);
      } else {
       await DatabaseHelper().updateItem(newItem);
      }

      Navigator.pop(context);
    }
  }
}