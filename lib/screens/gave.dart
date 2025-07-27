import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:untitled/screens/resources.dart';
import 'package:flutter/gestures.dart';

class gave extends StatefulWidget {
  final int id;

  const gave({super.key, required this.id});

  @override
  State<gave> createState() => _gaveState();
}

class _gaveState extends State<gave> {
  final TextEditingController quantity = TextEditingController();
  final TextEditingController rate = TextEditingController();
  final TextEditingController description = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int? selectedItemId;

  Future<List<Map<String, dynamic>>> fetchItems() async {
    try {
      final response = await Supabase.instance.client.from('items').select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching items: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("I Gave")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  final items = snapshot.data ?? [];

                  return DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'Select Item',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedItemId,
                    items: items.map((item) {
                      return DropdownMenuItem<int>(
                        value: item['id'],
                        child: Text(item['item'] ?? 'Unnamed Item'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedItemId = value;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null) return 'Please select an item';
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: quantity,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: rate,
                decoration: const InputDecoration(
                  labelText: 'Rate',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter rate';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: description,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 30),
              RichText(
                text: TextSpan(
                  text: 'Cant Find Any Item ? ',
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(
                      text: 'Add It',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = ()  {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddItemScreen()),
                          ).then((_) {
                            // Refresh the state when returning
                            setState(() {});
                          });
                        },
                    ),
                  ],
                ),
              ),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final quantityValue = int.tryParse(quantity.text);
                    final rateValue = double.tryParse(rate.text);

                    if (quantityValue == null || rateValue == null || selectedItemId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fill all fields properly')),
                      );
                      return;
                    }

                    try {
                      await Supabase.instance.client.from('transactions').insert({
                        'user_id': widget.id,
                        'item_id': selectedItemId,
                        'quantity': quantityValue,
                        'rate': rateValue,
                        'description': description.text,
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Transaction Added')),
                      );

                      Navigator.pop(context); // 👈 pop the page

                    } catch (e) {
                      print(e);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error saving Transaction')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Add Transaction', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
