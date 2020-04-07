import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jandulaseneca/sign_in.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'listado.dart';
import 'listado_firestore.dart';

final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

//firebase
final databaseReference = FirebaseDatabase.instance.reference();
final _firebaseRef = FirebaseDatabase().reference();
var referencia = _firebaseRef.child("asistencia").push().path;
String clave = referencia.substring(referencia.indexOf("-"));
//firebase


final databaseReferencef = Firestore.instance;
DocumentReference ref;
String myId;
class FirstScreen extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<FirstScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w700);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold es un layout para la mayoría de los Material Components.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Seneca',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Asistencia'),
            ),
            ListTile(
              leading: Icon(Icons.print),
              title: Text('Listado'),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Salir'),
            ),
          ],
        ),
      ),
      body: Body(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Inicio'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Busqueda'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            title: Text('Ayuda'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}

class Body extends StatelessWidget {
  static AssetImage assetImage = AssetImage('assets/images/j.png');
  Image image = Image(image: assetImage, width: 100);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 300) / 2;
    final double itemWidth = size.width / 2;

    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        CircleAvatar(
          backgroundImage: NetworkImage(
            imageUrl,
          ),
          radius: 40,
          backgroundColor: Colors.transparent,
        ),
        SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          margin: EdgeInsets.only(top: 6.0),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Color(0xff2b2b2b),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Bienvenido: ' + name + ' ' + apellidos,
              style: TextStyle(fontSize: 20.0, fontFamily: 'Karla'),
            ),
          ),
        ),
        SizedBox(height: 30),
        Container(
          alignment: Alignment.centerLeft,
          child: Text('  I.E.S - Jandula    -    Profesorado',
              style: DefaultTextStyle.of(context)
                  .style
                  .apply(color: Colors.blueAccent)
                  .apply(fontSizeFactor: 1.5)),
        ),
        SizedBox(height: 20),
        Container(
          alignment: Alignment.centerLeft,
          child: Text('  EMAIL:  ' + email,
              style: DefaultTextStyle.of(context)
                  .style
                  .apply(color: Colors.blueAccent)
                  .apply(fontSizeFactor: 1.5)),
        ),
        SizedBox(height: 90),
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: (itemWidth / itemHeight),
            controller: new ScrollController(keepScrollOffset: false),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              new GestureDetector(
                onTap: () {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.SCALE,
                    dialogType: DialogType.INFO,
                    body: Center(
                      child: Text(
                        'Asistencia',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    tittle: 'This is Ignored',
                    desc: 'This is also Ignored',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {
                      _firebaseRef.child("asistencia").child(clave).set({
                        "Apellidos": apellidos,
                        "Nombre": name,
                        "fecha_inicio": new DateFormat('yyyy-MM-dd – kk:mm')
                            .format(DateTime.now()),
                        "fecha_fin": new DateFormat('yyyy-MM-dd – kk:mm')
                            .format(DateTime.now())
                      });
                    },
                  ).show();
                },
                child: new Card(
                  child: new Container(
                    padding: new EdgeInsets.all(13.0),
                    child: new Column(
                      children: <Widget>[
                        new Text('Asistencia'),
                        SizedBox(height: 30),
                        Icon(Icons.question_answer)
                      ],
                    ),
                  ),
                ),
              ),
              new GestureDetector(
                onTap: () async {
                  //  _firebaseRef.child("asistencia").child(clave).update({
                  //                    "fecha_fin": new DateFormat('yyyy-MM-dd – kk:mm')
                  //                        .format(DateTime.now())
                  //                  });

                  getData();
                  //generarclave();
                },
                child: new Card(
                  child: new Container(
                    padding: new EdgeInsets.all(13.0),
                    child: new Column(
                      children: <Widget>[
                        new Text('Listado'),
                        SizedBox(height: 30),
                        Icon(Icons.local_printshop)
                      ],
                    ),
                  ),
                ),
              ),
              new GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: new Card(
                    child: new Container(
                      padding: new EdgeInsets.all(13.0),
                      child: new Column(
                        children: <Widget>[
                          Text('Salir'),
                          SizedBox(height: 30),
                          Icon(Icons.exit_to_app)
                        ],
                      ),
                    ),
                  )),
              FlipCard(
                key: cardKey,
                flipOnTouch: false,
                front: GestureDetector(
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.SCALE,
                      dialogType: DialogType.INFO,
                      body: Center(
                        child: Text(
                          'Asistencia',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      tittle: 'This is Ignored',
                      desc: 'This is also Ignored',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        //firebase
                        //  _firebaseRef.child("asistencia").child(clave).set({
                        //                          "Apellidos": apellidos,
                        //                          "Nombre": name,
                        //                          "fecha_inicio": new DateFormat('yyyy-MM-dd – kk:mm')
                        //                              .format(DateTime.now()),
                        //                          "fecha_fin": new DateFormat('yyyy-MM-dd – kk:mm')
                        //                              .format(DateTime.now())
                        //                        });
                        //firebase

                        createRecord();
                        cardKey.currentState.toggleCard();
                      },
                    ).show();
                  },
                  child: new Card(
                    color: Colors.green,
                    child: new Container(
                      padding: new EdgeInsets.all(13.0),
                      child: new Column(
                        children: <Widget>[
                          new Text('Asistencia'),
                          SizedBox(height: 30),
                          Icon(Icons.verified_user)
                        ],
                      ),
                    ),
                  ),
                ),
                back: GestureDetector(
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.SCALE,
                      dialogType: DialogType.INFO,
                      body: Center(
                        child: Text(
                          'Liberar Asistencia',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      tittle: 'This is Ignored',
                      desc: 'This is also Ignored',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        updateData();
                        //firebase
                        // _firebaseRef.child("asistencia").child(clave).update({
                        //                          "fecha_fin": new DateFormat('yyyy-MM-dd – kk:mm')
                        //                              .format(DateTime.now())
                        //                        });
                        //firebase
                        generarclave();
                        cardKey.currentState.toggleCard();
                      },
                    ).show();
                  },
                  child: new Card(
                    color: Colors.red,
                    child: new Container(
                      padding: new EdgeInsets.all(13.0),
                      child: new Column(
                        children: <Widget>[
                          new Text('Dejar Asistencia'),
                          SizedBox(height: 30),
                          Icon(Icons.next_week)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              new GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SecondRoute(),
                      ),
                    );
                  },
                  child: new Card(
                    child: new Container(
                      padding: new EdgeInsets.all(13.0),
                      child: new Column(
                        children: <Widget>[
                          new Text('Imprimir'),
                          SizedBox(height: 30),
                          Icon(Icons.view_list)
                        ],
                      ),
                    ),
                  )),
              new GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListPage(),
                      ),
                    );
                  },
                  child: new Card(
                    child: new Container(
                      padding: new EdgeInsets.all(13.0),
                      child: new Column(
                        children: <Widget>[
                          new Text('pagina1'),
                          SizedBox(height: 30),
                          Icon(Icons.share)
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

void generarclave() {
  referencia =
      new FirebaseDatabase().reference().child("asistencia").push().path;
  clave = referencia.substring(referencia.indexOf("-"));
}


//funciones firestore

void createRecord() async {
 ref = await databaseReferencef
      .collection("Asistencia")
      .add({
    "Apellidos": apellidos,
    "Nombre": name,
    "Fecha_inicio": new DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
    "Fecha_fin": new DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now())
  });
}

void updateData() {

  myId= ref.documentID;
  try {
    databaseReferencef
        .collection('Asistencia')
        .document(myId)
        .updateData({
      "Fecha_fin": new DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now())
    });
  } catch (e) {
    print(e.toString());
  }
}
void getData() {
  databaseReferencef
      .collection("Asistencia")
      .getDocuments()
      .then((QuerySnapshot snapshot) {
    snapshot.documents.forEach((f) => print('${f.data}}'));
  });
}

//funciones firestore