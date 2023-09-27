import 'package:flutter/material.dart';
import 'list.dart'; // Import the MyItem class
import 'item.dart'; // Import the MyItem class
class ItemDetailsPage extends StatefulWidget {
  final MyItem item;

  ItemDetailsPage({required this.item});

  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  bool isEditMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Item Name: ${widget.item.name}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Description: ${widget.item.description}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle the "Approve" action here
                Navigator.pop(context, true); // Return true to indicate approval
              },
              child: Text('Approve'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle the "Cancel" action here
                Navigator.pop(context, false); // Return false to indicate cancellation
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isEditMode = !isEditMode;
                });
              },
              child: Text(isEditMode ? 'Exit Edit Mode' : 'Enter Edit Mode'),
            ),
            if (isEditMode)
              TextFormField(
                decoration: InputDecoration(labelText: 'Edit Field'),
              ),
          ],
        ),
      ),
    );
  }
}
