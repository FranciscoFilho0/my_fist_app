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
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: const Color.fromARGB(255, 0, 59, 59),
        ),
      ),
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
  void initState() {
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
        itemCount: candidates.length,
        itemBuilder: (context, index) {
          final candidate = candidates[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(15),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,

                
                children: [
                  ListTile(
                    leading: CircleAvatar(

                      backgroundColor:  candidate.available
                        ? const Color.fromARGB(255, 89, 210, 254)
                        : const Color.fromARGB(122, 191, 26, 48),
                        child: Text(candidate.name[0]),
                    ),
                  
                    title: Text(candidate.name),

                    subtitle: Text(candidate.email),

                    trailing: Icon(
                      candidate.available
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      color: candidate.available ? Color.fromARGB(143, 62, 255, 139) :Color.fromARGB(255, 191, 26, 48),
                    ),
                   
                  ),
                   

                  const Text(
                    "Habilidades técnicas:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Color.fromARGB(255, 0, 16, 17),
                      fontFamily: 'Arial',
                    ),

                    textAlign: TextAlign.center,
                  ),

                  Wrap(
                    spacing: 4,
                    runSpacing: 3,

                    children: candidate.technicalSkills.map((skill) {
                      return Chip(
                        label: Text(skill,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 16, 17),
                          fontSize: 10,
                          fontFamily: 'Arial',
                        ),
                        ),
                        backgroundColor: candidate.available
                        ? const Color.fromARGB(255, 201, 251, 255)
                        : const Color.fromARGB(88, 255, 0, 34),

                        padding:EdgeInsets.zero,
                      );
                    }).toList(),
                  ),

                   const Text(
                    "Habilidades Pessoais:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Color.fromARGB(255, 0, 16, 17),
                      fontFamily: 'Arial',
                    ),

                    textAlign: TextAlign.center,
                  ),

                  Wrap(
                    spacing: 4,
                    runSpacing: 3,

                    children: candidate.softSkills.map((skill) {
                      return Chip(
                        label: Text(skill,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 16, 17),
                          fontSize: 10,
                          fontFamily: 'Arial',
                        ),
                        ),
                        backgroundColor: candidate.available
                        ? const Color.fromARGB(255, 201, 251, 255)
                        : const Color.fromARGB(88, 255, 0, 34),

                        padding:EdgeInsets.zero,
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
