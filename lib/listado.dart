

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseDatabase _database = FirebaseDatabase.instance;


class SecondRoute extends StatefulWidget  {
  @override
  SecondRouteState createState() => SecondRouteState();
}
class SecondRouteState extends State<SecondRoute> {

  List<Profesores> profesores;
  Profesores profesor;
  DatabaseReference ProfesRef;


  @override
  void initState() {
    super.initState();
    profesores = new List();
    profesor =  Profesores("","", "", "", "");
    final FirebaseDatabase database = FirebaseDatabase.instance;
    ProfesRef = database.reference().child("asistencia");
    ProfesRef.onChildAdded.listen(_onEntryAdded);
    ProfesRef.onChildChanged.listen(_onEntryChanged);

  }
  _onEntryAdded(Event event) {
    setState(() {
      profesores.add(Profesores.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var old = profesores.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      profesores[profesores.indexOf(old)] = Profesores.fromSnapshot(event.snapshot);
    });
  }


  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Listado Asistencia"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Expanded(child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                    text: "Listado\n",
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ],
              ),
            ) ),
            Flexible(
              child: FirebaseAnimatedList(
                query: ProfesRef,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  return new ListTile(
                    title: Text('Apellidos: ' +profesores[index].Apellidos+' - Nombre: ' +profesores[index].Nombre),

                    subtitle: Text('Fecha Inicio: ' +profesores[index].fecha_inicio+'                                       - Fecha Fin: ' +profesores[index].fecha_fin),
              
                  );
                },
              ),
            ),

            new Expanded(
                child: new Align(
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Atras'),
                  ),
                )),
          ],
        ),
      ),
    );
  }

}

class Profesores {
  String key;
  String Apellidos;
  String Nombre;
  String fecha_inicio;
  String fecha_fin;
  Profesores(this.key,this.Apellidos, this.Nombre, this.fecha_inicio,this.fecha_fin);

  Profesores.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        Apellidos = snapshot.value["Apellidos"],
        Nombre = snapshot.value["Nombre"],
        fecha_inicio = snapshot.value["fecha_inicio"],
        fecha_fin = snapshot.value["fecha_fin"];

  toJson() {
    return {
      "Apellidos": Apellidos,
      "Nombre": Nombre,
      "fecha_inicio": fecha_inicio,
      "fecha_fin": fecha_fin,
    };
  }

}



