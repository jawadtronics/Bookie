import 'package:flutter/material.dart';

void main() {
  runApp(opening());
}

class addContractor extends StatefulWidget {
  const addContractor({super.key});

  @override
  State<addContractor> createState() => _addContractorState();
}

class _addContractorState extends State<addContractor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Add Contractor", style: TextStyle(
            fontWeight: FontWeight.w900,
          ),),
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 500,
              width: 400,

              decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.amber,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 08,
                    blurRadius: 20,
                    blurStyle: BlurStyle.normal,
                    color: Colors.black12
                  )
                ]

              ),
              child: Column(
                children: [
                  Expanded(child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Text("Contractor Name", style: TextStyle(
                      fontWeight: FontWeight.w900,
                        fontSize: 18,
                    ),),
                  )),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextField(),
                  )),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Text("Contract Area" ,style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18
                    ),),
                  )),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextField(),
                  )),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: ElevatedButton(onPressed: (){
                      
                      // Supabase Function Addition
                      // Navigation To Back page
                      Navigator.pop(context);
                    }, child: Text("Submit"), ),
                  ))
                ],
              ),

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
      home: Scaffold(
        backgroundColor: Colors.amber,
        appBar: AppBar(
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
                  height: 200,
                  width: 400,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                      Text(
                        "Welcome Back 👋\nFiaz",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 30,
                          letterSpacing: -2,
                          height: 1.1
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => addContractor() ));

                        },
                        child: Text("Add Contractor"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,

                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text("Active Contractors",style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  color: Colors.white,
                  letterSpacing: -2,
                ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
