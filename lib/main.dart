import 'package:flutter/material.dart';
import 'dart:io';
// Partie robot
Robot robot = Robot("CY-TORYx3", Inventaire([], 5, 100));
void main() {
  runApp(const MyApp());

  // // Partie robot
  // Robot robot = Robot("CY-TORYx3", Inventaire([], 5, 100));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Namer App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 79, 92, 82)),
      ),
      home: const MyHomePage(title: 'Cyber Inventory'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
List<String> messages = [];
String show() {
  return "vide";
}
class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;
  
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      // _counter++;
    });
  }

  // void _showMessages() {
  //   // for(int i = 0; i < messages.length; i++) {
  //   //   if(messages.isEmpty) {
  //   //     "Vide";
  //   //   } else {
  //   //     messages[i];
  //   //   }
  //   // } 
  //   "vide";
  // }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: const Color.fromARGB(255, 66, 66, 66),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title, style:TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              robot._nom,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text("Inventaire : ..."),
            Text("Nbr item : ... | Poids total : ..."),
            Text("Message : ${show()}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Image.asset('assets/btn/fouiller.png'),
                  splashColor: Colors.black12,
                  tooltip: 'Fouiller',
                  onPressed: () {
                    robot.ramasser();
                  },
                ),
                IconButton(
                  icon: Image.asset('assets/btn/ramasser.png'),
                  tooltip: 'Ramasser',
                  onPressed: () {
                    // setState(() {
                    //   _volume += 10
                    // });
                  },
                ),
                IconButton(
                  icon: Image.asset('assets/btn/deposer.png'),
                  tooltip: 'Déposer',
                  onPressed: () {
                    // setState(() {
                    //   _volume += 10;
                    // });
                  },
                ),
                IconButton(
                  icon: Image.asset('assets/btn/voir.png'),
                  tooltip: 'Voir',
                  onPressed: () {
                    robot.voirInventaire();
                  },
                )
            ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// CODE DART DE BASE 


// List<String> loot = ["Epée rouillée", "Potion de soin", "Arc en bois", "Bouclier en fer"];

// void main() {
//   print("Quel est votre nom ?");
//   String username = stdin.readLineSync()!;
//   Inventaire inventaire = Inventaire([], 5, 100);
//   Robot robot = Robot(username, inventaire);
//   bool isOut = false;
//   while (isOut == false) {
//     print("Que souhaitez-vous faire ?");
//     print("[1] -> Ramasser un item | [2] -> Déposer un item | [3] -> Voir son inventaire | [4] -> Rentrer à la maison");
//     int answer = int.parse(stdin.readLineSync()!);
//     if(answer == 1) {
//       robot.ramasser();
//     } else if(answer == 2) {
//       robot.deposer();
//     } else if(answer == 3) {
//       robot.voirInventaire();
//     } else if(answer == 4) {
//       isOut = true;
//       print("Il fait nuit... ${robot._nom} rentre chez lui...");
//     } else {
//       print("Merci de choisir entre 1, 2, 3 ou 4 seulement");
//     }
//   }
// }

class Item {
  String _nom;
  int _poids;

  Item(this._nom, this._poids);

  String getName() {
    return _nom;
  }
  int getPoids() {
    return _poids;
  }
}

class Inventaire {
  List<Item> items;
  int maxLength;
  int maxPoids;

  Inventaire(this.items, this.maxLength, this.maxPoids);

  int checkFullOrEmpty(int listLengt, int type) {
    int rcheck = 0;
    if(maxLength - listLengt == 0) {
      if(type == 1) {
        messages.add("(Inventaire plein)");
      }
      rcheck = 1;
    } else if(maxLength - listLengt == 5) {
      if(type == 1) {
        messages.add("(Inventaire vide)");
      }
      rcheck = 2;
    }
    return rcheck;
  }

  void afficherInventaire() {
    int listLength = items.length;
    messages.add("-----------------");
    messages.add("Inventaire (${maxLength -(maxLength - listLength)}/$maxLength) :");
    items.sort((a, b) => a.toString().compareTo(b.toString())); // permet de trier par ordre alphabétique
    for(int i = 0; i < items.length; i++) {
      messages.add("Item $i -> ${items[i].getName()} (${items[i].getPoids()} kg)");
    }
    checkFullOrEmpty(items.length, 1);
    messages.add("Poids total : ${poidsTotal()}kg");
    messages.add("-----------------");
  }

  String ajouterItem() {
    if(checkFullOrEmpty(items.length, 0) == 1) {
      return "null";
    } else {
      print("Nom de l'item : ");
      String itemName = stdin.readLineSync()!; // permet à l'utilisateur une entrée, type String
      print("Poids de l'item : ");
      String itemPoids = stdin.readLineSync()!;
      String itemAdd = ("$itemName ($itemPoids kg)");
      Item item  = Item(itemName, int.parse(itemPoids));
      items.add(item);
      checkFullOrEmpty(items.length, 1);
      return itemAdd;
    }
  }

  String supprimerItem() {
    bool isRemove = false;
    if(checkFullOrEmpty(items.length, 0) == 2) {
      return "null2";
    } else {
      print("Nom de l'item :");
      String itemRemove = stdin.readLineSync()!;
      for(int i = 0; i < items.length; i++) {
        if(items[i].getName() == itemRemove) {
          items.removeAt(i);
          isRemove = true;
        }
      }
      checkFullOrEmpty(items.length, 1);
      if (isRemove == false) {
        return "null1";
      } else {
        return itemRemove;
      }
    }
  }

  int poidsTotal() {
    int poidsList = 0;
    for(int i = 0; i < items.length; i++) {
      poidsList += items[i].getPoids();
    }
    return poidsList;
  }
}

class Robot {
  String _nom;
  Inventaire _inventaire;

  Robot(this._nom, this._inventaire);

  void ramasser() {
    String item = _inventaire.ajouterItem();
    if(item == "null") {
      messages.add("$_nom n'arrive pas à mettre l'item dans son sac (inventaire plein)");
    } else {
      messages.add("$_nom ramasse '$item'");
    }
  }

  void voirInventaire() {
    messages.add("$_nom ouvre son sac...");
    _inventaire.afficherInventaire();
    messages.add("$_nom referme son sac...");
  }

  void deposer() {
    String item = _inventaire.supprimerItem();
    if(item == "null1") {
      messages.add("$_nom ne trouve pas l'item dans son sac (item introuvable)");
    } else if(item == "null2") {
      messages.add("$_nom n'a rien dans son sac (inventaire vide)");
    } else {
      messages.add("$_nom jette '$item'");
    }
  }
}






