// import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart' as path;

// partie initialisation
Inventaire sacados = Inventaire([], 5, 100);
Robot robot = Robot("CY-TORYx3", sacados);



void main() async {
  // var db = await openDatabase('../bdd.db');
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(path.join(await getDatabasesPath(), 'bdd.db'),
    onCreate: (db, version) {
      return db.execute('CREATE TABLE item(item_id INTEGER PRIMARY KEY, item_nom TEXT, item_poids INTEGER)');
    },
    version: 1,
  );
  Future<void> insertDog(Item item) async {
    final db = await database;
    await db.insert(
      'item',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  var nI = Item(0, 'Rodéo des bois', 35);
  await insertDog(nI);
  Future<List<Item>> getItems() async {
    final db = await database;
    final List<Map<String, Object?>> itemMaps = await db.query('item');
    return [
      for (final {'item_id': id as int, 'item_nom': nom as String, 'item_poids': poids as int} 
          in itemMaps)
        Item(item_id: id, item_nom: nom, item_poids: poids),
    ];
  }
  print(await getItems());
  Future<void> updateItem(Item item) async {
    final db = await database;
    await db.update(
      'item',
      item.toMap(),
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [item._id],
    );
  }
  Item nI2 = Item(0, "Ari", 0);
  await updateItem(nI2);
  print(await getItems());
  Future<void> deleteItem(int id) async {
    final db = await database;
    await db.delete(
      'item',
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
  // await deleteItem(0);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyber Inventory',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(94, 83, 95, 83)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CYBERWORLD - Une aventure arduinesque'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<String> messages = [];

class _MyHomePageState extends State<MyHomePage> {
  ScrollController scrollController = ScrollController();

  void _scrollAuto() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }
  void _voir() {
    setState(() {
      robot.voirInventaire();
      _scrollAuto();
    });
  }
  void _fouiller() {
    setState(() {
      robot.fouiller();
      _scrollAuto();
    });
  }
  void _ajouter() {
    setState(() {
      robot.ramasser();
      _scrollAuto();
    });
  }
  void _deposer() {
    setState(() {
      robot.deposer();
      _scrollAuto();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(238, 54, 97, 70),
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              robot._nom,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text("Nbr item : ${sacados.items.length}/${sacados.maxLength} | Poids total : ${sacados.poidsTotal()}/${sacados.maxPoids}kg"),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                bool isFull = messages[index].contains("Inventaire plein");
                return ListTile(
                  title: Text(
                    messages[index],
                    style: TextStyle(
                      fontFamily: 'SourceCodePro',
                      fontWeight: FontWeight.w900,
                      fontSize: 15.5,
                      backgroundColor: const Color.fromARGB(14, 17, 17, 17),
                      color: isFull? Colors.red : Colors.black,
                    ),
                  ),
                );
                }
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Image.asset('assets/btn/fouiller.png'),
                  tooltip: 'Fouiller (cherche un item au hasard)',
                  onPressed: () {
                    _fouiller();
                  },
                ),
                IconButton(
                  icon: Image.asset('assets/btn/ramasser.png'),
                  tooltip: 'Ramasser (permet de ramasser l\'item trouvé)',
                  onPressed: () {
                    _ajouter();
                  },
                ),
                IconButton(
                  icon: Image.asset('assets/btn/deposer.png'),
                  tooltip: 'Déposer (permet de jeter le dernier item ajouté)',
                  onPressed: () {
                    _deposer();
                  },
                ),
                IconButton(
                  icon: Image.asset('assets/btn/voir.png'),
                  tooltip: 'Voir (permet de voir le sac à dos)',
                  onPressed: () {
                    _voir();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

List<List<dynamic>> loot = [
  ["Epée rouillée", 10],
  ["Potion de soin", 1],
  ["Arc en émeraude", 5],
  ["Couteau cassé", 2],
  ["Heaume du Roi", 10],
  ["Cheval malade", 100],
  ["Trésor national", 50],
  ["Pique-nique de Mamie", 7]];

class Item {
  int _id;
  String _nom;
  int _poids;

  Item(this._id, this._nom, this._poids);

  String getName() {
    return _nom;
  }

  int getPoids() {
    return _poids;
  }

  Map<String, dynamic> toMap() {
    return {'id': _id, 'nom': _nom, 'poids': _poids};
  }

  @override
  String toString() {
    return 'Item{id: $_id, name: $_nom, age: $_poids}';
  }
}

class Inventaire {
  List<Item> items;
  int maxLength;
  int maxPoids;

  Inventaire(this.items, this.maxLength, this.maxPoids);

  String itemNameLoot = "";
  int itemWeightLoot = 0;
  int countItem = 0;

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

  int checkWeight(int weight, int type) {
    int rcheck = 0;
    if(maxPoids <= weight) {
      if(type == 1) {
        messages.add("(Poids max de ${maxPoids}kg atteint)");
      }
      rcheck = 1;
    } else {
      if(type == 2) {
        messages.add("(Poids restant : ${maxPoids - weight}kg)");
      }
      rcheck = 2;
    }
    return rcheck;
  }
  
  void afficherInventaire() {
    messages.add("-----------------");
    messages.add("Inventaire (${items.length}/$maxLength) :");
    items.sort((a, b) => a.toString().compareTo(b.toString()));
    for (int i = 0; i < items.length; i++) {
      messages.add("Item ${i + 1} -> ${items[i].getName()} (${items[i].getPoids()}kg)");
    }
    messages.add("Poids total : ${poidsTotal()}/${maxPoids}kg");
    checkFullOrEmpty(items.length, 1);
    checkWeight(poidsTotal(), 1);
    messages.add("-----------------");
  }

  int poidsTotal() {
    int poidsList = 0;
    for (int i = 0; i < items.length; i++) {
      poidsList += items[i].getPoids();
    }
    return poidsList;
  }

  String aleatoireItem() {
    var rand = Random().nextInt(loot.length);
    // permet d'avoir une chance sur 2 d'avoir un nouvel item
    if(Random().nextBool()) {
      // si le cas où l'user obtient un nouvel item, choix de l'item au hasard dans la list loot
      String itemAddName = loot[rand][0];
      int itemAddWeight = loot[rand][1];
      itemNameLoot = itemAddName;
      itemWeightLoot = itemAddWeight;
      return "$itemAddName (${itemAddWeight}kg)";
    } else {
      itemNameLoot = "";
      itemWeightLoot = 0;
      return "null";
    }
  }

  String ajouterItem() {
    if(checkFullOrEmpty(items.length, 0) == 1) {
      return "null";
    } else {
      if(checkWeight(poidsTotal(), 0) == 1) {
        return "null";
      } else {
        int count = 0;
        // test si l'user a fouiller avant de pouvoir ajouter l'item
        if(itemNameLoot != "" && itemWeightLoot != 0) {
          for(int x = 0; x < items.length; x++) {
            // test via la boucle for et if, si l'item n'est pas déjà présent dans l'inventaire
            if(itemNameLoot == items[x].getName() && itemWeightLoot == items[x].getPoids()) {
              count++;
            }
          }
        } else {
          return "null3";
        }
        if(count > 0) {
          return "null2";
        } else {
          
          Item newItem = Item(countItem + 1, itemNameLoot, itemWeightLoot);
          items.add(newItem);
          return "$itemNameLoot ($itemWeightLoot kg)";
        }
      }
    }
  }

  String supprimerItem() {
    bool isRemove = false;
    String itemRemove = "";
    if(checkFullOrEmpty(items.length, 0) == 2) {
      return "null2";
    } else {
      String itemRemoveName = items.last.getName();
      int itemRemoveWeight = items.last.getPoids();
      items.removeAt(items.indexOf(items.last));
      itemRemove = "$itemRemoveName (${itemRemoveWeight}kg)";
      isRemove = true;
    }
    if (isRemove == false) {
      return "null";
    } else {
      return itemRemove;
    }
  }
}

class Robot {
  String _nom;
  Inventaire _inventaire;

  Robot(this._nom, this._inventaire);

  void fouiller() {
    String item = _inventaire.aleatoireItem();
    if(item == "null") {
      messages.add("$_nom n'a rien trouvé");
    } else {
      messages.add("$_nom trouve au fond de sa poche '$item'");
      messages.add("(Pour ajouter '$item' à votre inventaire : cliquez sur le bouton 'Ramasser', sinon ignorez et relancez)");
    }
  }

  void ramasser() {
    String item = _inventaire.ajouterItem();
    if(item == "null") {
      messages.add("$_nom n'arrive pas à mettre l'item dans son sac (inventaire plein)");
    } else if(item == "null2") {
      messages.add("$_nom a trouvé le même item dans son sac, il jette donc celui trouvé");
    } else if(item == "null3") {
      messages.add("$_nom n'a pas fouillé autour de lui");
    } else {
      messages.add("$_nom ramasse '$item'");
      _inventaire.checkFullOrEmpty(_inventaire.items.length, 1);
      _inventaire.checkWeight(_inventaire.poidsTotal(), 2);
    }
  }

  void voirInventaire() {
    messages.add("$_nom ouvre son sac...");
    _inventaire.afficherInventaire();
    messages.add("$_nom referme son sac...");
  }

  void deposer() {
    String item = _inventaire.supprimerItem();
    if(item == "null") {
      messages.add("$_nom ne trouve pas l'item dans son sac (item introuvable)");
    } else if(item == "null2") {
      messages.add("$_nom n'a rien dans son sac (inventaire vide)");
    } else {
      messages.add("$_nom jette '$item'");
      _inventaire.checkFullOrEmpty(_inventaire.items.length, 1);
      _inventaire.checkWeight(_inventaire.poidsTotal(), 2);
    }
  }
}
