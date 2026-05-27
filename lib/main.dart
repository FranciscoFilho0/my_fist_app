import 'package:flutter/material.dart';
import 'models/candidate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App do Pedro',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.red)),
      home: const MyHomePage(title: 'Minha aplicação em Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Candidate> candidates = Candidate.candidates(); 

@override
void initState(){
  super.initState();

    for (var candidate in candidates) {
    print(candidate.name);
    print(candidate.email);
    print(candidate.available);
    print("---");

  }
}

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount:candidates.length,
        itemBuilder:(context, index){
          final candidate = candidates[index];
          return Card(
            
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

            child: ListTile(

              leading: CircleAvatar(
                backgroundColor: candidate.available ? const Color.fromARGB(80, 37, 223, 43) : const Color.fromARGB(69, 244, 67, 54),
                child: Text(candidate.name[0]),             
              ),

              title: Text(candidate.name),

              subtitle: Text(candidate.email),

              trailing: Icon(
                candidate.available ? Icons.favorite_rounded : Icons.cancel_rounded,
                color: candidate.available ? Colors.green : Colors.red,
              ),
              tileColor:candidate.available ? const Color.fromARGB(54, 65, 202, 70) : const Color.fromARGB(54, 244, 67, 54),
              ),
            );

        },
      ),
     
      
      
    );
  }
}