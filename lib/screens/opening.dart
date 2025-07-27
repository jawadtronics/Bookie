import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:untitled/screens/gave.dart';
import 'package:untitled/screens/received.dart';
import 'package:untitled/screens/resources.dart';

void main() {
  runApp(opening());
}
class personalPage extends StatefulWidget {
  final int id;
  final String name;
  final String phone;
  final String area;

  const personalPage({
    super.key,
    required this.id,
    required this.name,
    required this.phone,
    required this.area,
  });

  @override
  State<personalPage> createState() => _personalPageState();

}


class _personalPageState extends State<personalPage> {

  Future<List<Map<String, dynamic>>> fetchTransactions(int userId) async {
    try {
      final response = await Supabase.instance.client
          .from('transactions')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false); // Optional: latest first

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching transactions: $e');
      return [];
    }
  }
  late Future<List<Map<String, dynamic>>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _transactionsFuture = fetchTransactions(widget.id); // replace with actual ID source
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
          Padding(
            padding: const EdgeInsets.only(top: 40,),
            child: Container(
            height: 190,
            width: 400,
            // padding: const EdgeInsets.only(top: 90,bottom: 20,left: 20,right: 20 ),
            decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    blurStyle: BlurStyle.normal,
                    blurRadius: 10,
                    spreadRadius: 4,
                    color: Colors.black12,
                  ),
                ]
            ),
              child: Column(
                children: [
                  // Text('${widget.name}', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),),
                  Text("Hello " + '${widget.name}' , style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _transactionsFuture,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return SizedBox(); // Don't show totals if no data
                      }

                      final transactions = snapshot.data!;
                      double totalGiven = 0;
                      double totalReceived = 0;

                      for (final tx in transactions) {
                        final isReceived = tx['transaction_type'] == 2;

                        if (isReceived) {
                          final recAmount = tx['rec_amount'];
                          if (recAmount != null) totalReceived += recAmount;
                        } else {
                          final quantity = tx['quantity'];
                          final rate = tx['rate'];
                          if (quantity != null && rate != null) {
                            totalGiven += quantity * rate;
                          }
                        }
                      }

                      final netTotal = totalReceived - totalGiven;

                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            Text(
                              "Given: Rs ${totalGiven.toStringAsFixed(0)}",
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                            Text(
                              "Received: Rs ${totalReceived.toStringAsFixed(0)}",
                              style: TextStyle(color: Colors.green, fontSize: 16),
                            ),
                            Text(
                              "Net: Rs ${netTotal.toStringAsFixed(0)}",
                              style: TextStyle(
                                color: netTotal >= 0 ? Colors.green : Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Container(
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Align(
                            alignment:Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: ElevatedButton(onPressed: (){

                                  Navigator.push(context, MaterialPageRoute(builder: (context) => gave(
                                    id: widget.id,
                                  )));

                                }, child: Text("Gave"), style:
                                  ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                  ),),
                              )),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: ElevatedButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReceivedPage(
                                    id : widget.id
                                  )));
                                }, child: Text("Receieved"), style:
                                  ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                  ),),
                              )),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text("Transactions", style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _transactionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No transactions found.'));
                  }

                  final transactions = snapshot.data!;
                  double totalGiven = 0;
                  double totalReceived = 0;

                  for (final tx in transactions) {
                    final isReceived = tx['transaction_type'] == 2;

                    if (isReceived) {
                      final recAmount = tx['rec_amount'];
                      if (recAmount != null) {
                        totalReceived += recAmount;
                      }
                    } else {
                      final quantity = tx['quantity'];
                      final rate = tx['rate'];
                      if (quantity != null && rate != null) {
                        totalGiven += quantity * rate;
                      }
                    }
                  }

                  final netTotal = totalReceived - totalGiven;
                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final tx = transactions[index];
                      final isReceived = tx['transaction_type'] == 2;

                      final recAmount = tx['rec_amount'];
                      final quantity = tx['quantity'];
                      final rate = tx['rate'];
                      final description = tx['description'] ?? 'No description';

                      final gaveAmount = (quantity != null && rate != null)
                          ? (quantity * rate)
                          : null;

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(
                            isReceived
                                ? 'Amount Recieved: $recAmount'
                                : 'Amount Gave: ${gaveAmount ?? 'N/A'}',
                            style: TextStyle(
                              color: isReceived ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Description: $description'),
                              if (!isReceived) ...[
                                Text('Rate: ${rate ?? 'N/A'}'),
                                Text('Quantity: ${quantity ?? 'N/A'}'),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}


class addContractor extends StatefulWidget {
  const addContractor({super.key});

  @override
  State<addContractor> createState() => _addContractorState();
}
Future<List<dynamic>> fetchContractors() async {
  final response = await Supabase.instance.client
      .from('contractors')
      .select()
      .order('created_at' , ascending: false);
  return response;
}

class _addContractorState extends State<addContractor> {
  final TextEditingController name = TextEditingController();
  final TextEditingController area = TextEditingController();
  final TextEditingController phone = TextEditingController();



  Future<void> addContractorToSupabase() async {
    if (name.text.isEmpty || area.text.isEmpty || phone.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    try {
      await Supabase.instance.client.from('contractors').insert({
        'name': name.text,
        'area': area.text,
        'phone': phone.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Contractor added successfully")),
      );

      Navigator.pop(context, 'refresh');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Widget buildRow(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 80,
            child: Text(label,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: type,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }



  @override


  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Client", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildRow("Name", name),
            buildRow("Phone", phone, type: TextInputType.phone),
            buildRow("Area", area),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addContractorToSupabase,
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}



class opening extends StatefulWidget {
  const opening({super.key});

  @override
  State<opening> createState() => _openingState();
}

class _openingState extends State<opening> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> resources()));
              },
              child: Text("Resources"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,

                ),
              ),
            ),
          ),
          backgroundColor: Colors.amber,
        ),
        // appBar: AppBar(
        //   title: Text(
        //     "Minhas Construction",
        //     style: TextStyle(fontWeight: FontWeight.w800),
        //   ),
        //   backgroundColor: Colors.amber,
        // ),
        body: Center(
          child: Column(
            // mainAxisSize: MainAxisSize.min, // so it doesn't take full vertical space
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 190,
                  width: 400,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        blurStyle: BlurStyle.normal,
                        blurRadius: 10,
                        spreadRadius: 4,
                        color: Colors.black12,
                      )
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Minhas Construction Assosisates",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            letterSpacing: -1,
                            height: 1.1,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                          },
                          child: Text("CLIENT LIST"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,

                            ),
                          ),
                        ),
                      ),

                       Container(
                         height: 40,
                       ),
                       Align(
                         alignment: Alignment.centerRight,
                           child: ElevatedButton(onPressed: () async {
                             final result = await Navigator.push(
                               context,
                               MaterialPageRoute(builder: (context) => addContractor()),
                             );

                             if (result == 'refresh') {
                               setState(() {}); // Refresh the contractor list
                             }
                           }, child: Icon(Icons.add)))
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text("Active Landlords",style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  color: Colors.black,
                  letterSpacing: -2,
                ),),
              ),
              SizedBox(height: 12),
              Expanded( // <-- FIX: wrap FutureBuilder in Expanded!
                child: FutureBuilder<List<dynamic>>(
                  future: fetchContractors(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                              'Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
                    }

                    final contractors = snapshot.data ?? [];

                    if (contractors.isEmpty) {
                      return Center(child: Text("No contractors found."));
                    }

                    return ListView.builder(
                      itemCount: contractors.length,
                      itemBuilder: (context, index) {
                        final c = contractors[index];
                        return Card(
                          child: ListTile(
                            title: Text(c['name'] ?? 'No Name'),
                            subtitle: Text("${c['phone']} | ${c['area']}"),
                            onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>personalPage(
                              id: c['id'], // 👈 This line is new
                              name: c['name'] ?? 'No Name',
                              phone: c['phone'].toString() ?? 'No Phone',
                              area: c['area'] ?? 'No Area',
                            )));},
                           ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
