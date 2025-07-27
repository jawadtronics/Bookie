import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:untitled/screens/opening.dart'; // Ensure this path is correct

// Main Resources Screen
class resources extends StatefulWidget {
  const resources({super.key});

  @override
  State<resources> createState() => _resourcesState();
}

class _resourcesState extends State<resources> {
  late Future<List<Map<String, dynamic>>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = fetchitems();
  }

  Future<List<Map<String, dynamic>>> fetchitems() async {
    try {
      final response = await Supabase.instance.client
          .from('items')
          .select();

      if (response != null) {
        return List<Map<String, dynamic>>.from(response);
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching items: $e');
      throw Exception('Failed to load items');
    }
  }

  Future<void> deleteItem(int itemId) async {
    try {
      await Supabase.instance.client
          .from('items')
          .delete()
          .eq('id', itemId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item deleted successfully!')),
      );
      setState(() {
        _itemsFuture = fetchitems(); // Re-fetch the items to update the UI
      });
    } catch (e) {
      print('Error deleting item: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete item: $e')),
      );
    }
  }

  void _confirmDelete(BuildContext context, int itemId, String itemName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: Text("Are you sure you want to delete '$itemName'?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop();
                deleteItem(itemId);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resources"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Manage Your\nResources",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 30,
                height: 1.1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Navigate to AddItemScreen and wait for result
                  final bool? itemAdded = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddItemScreen(), // Navigate to your new screen
                    ),
                  );

                  // If an item was successfully added, refresh the list
                  if (itemAdded == true) {
                    setState(() {
                      _itemsFuture = fetchitems(); // Re-fetch the items
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Add Resource",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _itemsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No resources found.'));
                } else {
                  final items = snapshot.data!;
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final c = items[index];
                      final itemId = c['id'] as int?;
                      final itemName = c['item'] ?? 'No Name';

                      if (itemId == null) {
                        return const SizedBox.shrink();
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 2,
                        child: ListTile(
                          title: Text(itemName),
                          // subtitle: Text("${c['price'] ?? 'No Price'}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _confirmDelete(context, itemId, itemName);
                            },
                          ),
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => personalPage(
                            //       id: c['id'],
                            //       name: c['name'] ?? 'No Name',
                            //       phone: c['phone']?.toString() ?? 'No Phone',
                            //       area: c['area'] ?? 'No Area',
                            //     ),
                            //   ),
                            // );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- NEW CLASS: AddItemScreen for adding new items ---
class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  Future<void> _addItem() async {
    if (_formKey.currentState!.validate()) {
      final String itemName = _itemController.text.trim();
      final double? itemPrice = double.tryParse(_priceController.text.trim());

      // if (itemPrice == null) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Please enter a valid price.')),
      //   );
      //   return;
      // }

      try {
        await Supabase.instance.client.from('items').insert({
          'item': itemName,
          // 'price': itemPrice,
          // Add other fields if necessary, e.g., 'created_at': DateTime.now().toIso8601String(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item added successfully!')),
        );
        Navigator.of(context).pop(true); // Pop with true to indicate success
      } catch (e) {
        print('Error adding item: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add item: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _itemController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _itemController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an item name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // TextFormField(
              //   controller: _priceController,
              //   decoration: const InputDecoration(
              //     labelText: 'Price',
              //     border: OutlineInputBorder(),
              //   ),
              //   keyboardType: TextInputType.number,
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter a price';
              //     }
              //     if (double.tryParse(value) == null) {
              //       return 'Please enter a valid number';
              //     }
              //     return null;
              //   },
              // ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _addItem,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Add Item',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}