import 'package:flutter/material.dart';
import 'item_details_page.dart'; // Import the MyItem class
import 'item.dart'; // Import the MyItem class

class MyItemList extends StatefulWidget {
  @override
  _MyItemListState createState() => _MyItemListState();
}

class _MyItemListState extends State<MyItemList> {
  List<MyItem> items = [
    MyItem("Item 1", "Description of Item 1", ItemStatus.approved),
    MyItem("Item 2", "Description of Item 2", ItemStatus.approved),
    MyItem("Item 3", "Description of Item 3", ItemStatus.pending),
    MyItem("Item 4", "Description of Item 4", ItemStatus.rejected),
  ];

  Set<ItemStatus> activeFilters = Set.from(ItemStatus.values);

  @override
  void initState() {
    super.initState();
  }

  void _navigateToItemDetails(MyItem item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailsPage(item: item),
      ),
    );

    if (result != null) {
      setState(() {
        item.status = result ? ItemStatus.approved : ItemStatus.rejected;
      });
    }
  }

  void toggleFilter(ItemStatus filter) {
    setState(() {
      if (activeFilters.contains(filter)) {
        activeFilters.remove(filter);
      } else {
        activeFilters.add(filter);
      }
    });
  }

  List<MyItem> getFilteredItems() {
    if (activeFilters.isEmpty) {
      return items;
    } else {
      return items.where((item) => activeFilters.contains(item.status)).toList();
    }
  }

  Widget _getStatusBadge(ItemStatus status) {
    Color badgeColor;
    String badgeText;

    switch (status) {
      case ItemStatus.pending:
        badgeColor = Colors.orange;
        badgeText = 'Pending';
        break;
      case ItemStatus.approved:
        badgeColor = Colors.green;
        badgeText = 'Approved';
        break;
      case ItemStatus.rejected:
        badgeColor = Colors.red;
        badgeText = 'Rejected';
        break;
      default:
        badgeColor = Colors.grey;
        badgeText = 'Unknown';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        badgeText,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<MyItem> filteredItems = getFilteredItems();

    return Scaffold(
      appBar: AppBar(
        title: Text('Item List'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (ItemStatus status in ItemStatus.values)
                if (status != ItemStatus.all) // Skip the "All" button
                  FilterButton(
                    label: status.toString().split('.').last, // Use the enum name as the label
                    filter: status,
                    isActive: activeFilters.contains(status),
                    onPressed: toggleFilter,
                  ),
            ],
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredItems.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    item.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(item.description),
                  trailing: _getStatusBadge(item.status),
                  onTap: () {
                    _navigateToItemDetails(item);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final ItemStatus filter;
  final bool isActive;
  final Function(ItemStatus) onPressed;

  FilterButton({
    required this.label,
    required this.filter,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {
          onPressed(filter);
        },
        style: ElevatedButton.styleFrom(
          primary: isActive
              ? Colors.blue
              : Colors.grey, // Set all active buttons to blue
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }
}


