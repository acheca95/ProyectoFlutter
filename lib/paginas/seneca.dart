import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class seneca extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<seneca> {
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
    final double itemHeight = (size.height - kToolbarHeight - 200) / 2;
    final double itemWidth = size.width / 2;

    return Column(
      children: <Widget>[
        image,
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          margin: EdgeInsets.only(top: 20.0),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Color(0xff2b2b2b),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Bienvenido : Prueba ',
              style: TextStyle(fontSize: 20.0, fontFamily: 'Karla'),

            ),
          ),
        ),

        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          child: Text('   I.E.S - Jandula',
              style: DefaultTextStyle.of(context)
                  .style
                  .apply(color: Colors.blueAccent)
                  .apply(fontSizeFactor: 1.5)),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          child: Text('   Profesorado',
              style: DefaultTextStyle.of(context)
                  .style
                 .apply(color: Colors.blueAccent)
                  .apply(fontSizeFactor: 1.5)),
        ),
        SizedBox(height: 10),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecondRoute(),
                    ),
                  );
                },
                child: new Card(
                  child: new Container(
                    padding: new EdgeInsets.all(17.0),
                    child: new Column(
                      children: <Widget>[
                        new Text('Asistencia'),
                        SizedBox(height: 10),
                        Icon(Icons.question_answer)
                      ],
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
                    padding: new EdgeInsets.all(17.0),
                    child: new Column(
                      children: <Widget>[
                        new Text('Listado'),
                        SizedBox(height: 10),
                        Icon(Icons.local_printshop)
                      ],
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
                      padding: new EdgeInsets.all(17.0),
                      child: new Column(
                        children: <Widget>[
                          Text('Salir'),
                          SizedBox(height: 10),
                          Icon(Icons.exit_to_app)
                        ],
                      ),
                    ),
                  )),
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
                      padding: new EdgeInsets.all(17.0),
                      child: new Column(
                        children: <Widget>[
                          new Text('pagina1'),
                          SizedBox(height: 10),
                          Icon(Icons.share)
                        ],
                      ),
                    ),
                  )),
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
                      padding: new EdgeInsets.all(17.0),
                      child: new Column(
                        children: <Widget>[
                          new Text('pagina1'),
                          SizedBox(height: 10),
                          Icon(Icons.share)
                        ],
                      ),
                    ),
                  )),
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
                      padding: new EdgeInsets.all(17.0),
                      child: new Column(
                        children: <Widget>[
                          new Text('pagina1'),
                          SizedBox(height: 10),
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

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pagina2"),
      ),
      body: Center(
        child: Container(
          alignment: Alignment.bottomCenter,
          child: RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Atras'),
          ),
        ),
      ),
    );
  }
}

class FlightImageAsset extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    AssetImage assetImage = AssetImage('assets/images/j.png');
    Image image = Image(image: assetImage, width: 100);
    return Container(
      child: image,
    );
  }
}
