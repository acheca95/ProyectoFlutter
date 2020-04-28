import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

Firestore _firestore = Firestore.instance;
Firestore _firestore2 = Firestore.instance;
List<DocumentSnapshot> Profesores = [];
List<DocumentSnapshot> Profesores2 = [];
List<DocumentSnapshot> Profesores4 = [];
List<DocumentSnapshot> Profesores3 = [];
List<DocumentSnapshot> Profesores5 = [];
List<DocumentSnapshot> Profesores6 = [];
bool loadingProfes = true;
bool loadingProfes2 = true;
//bool todos = false;
var show = false;
var show2 = false;
//busqueda
DateTime selectedDate = DateTime.now();
DateTime selectedDate2 = DateTime.now();

class _ListPageState extends State<ListPage> {
  final pdf = pw.Document();
  _getPosts() async {
    Query q = _firestore
        .collection("Asistencia")
        .orderBy("Apellidos")
        .orderBy("Nombre");

    setState(() {
      loadingProfes = true;
    });
    QuerySnapshot querySnapshot = await q.getDocuments();

    Profesores2 = querySnapshot.documents;
    Profesores4 = querySnapshot.documents;
    int eliminado = 0;
    int count;
    for (var i = 0; i < Profesores2.length; i++) {
      //  print(Profesores[i].data["Nombre"]);
      if (eliminado == 1) {
        i = i - 1;
        eliminado = 0;
      }
      if (Profesores2[i].data["Apellidos"] ==
              Profesores2[i + 1].data["Apellidos"] &&
          Profesores2[i].data["Nombre"] == Profesores2[i + 1].data["Nombre"]) {
        // Profesores2.remove(Profesores2[i+1]);
        Profesores2.removeAt(i + 1);
        eliminado = 1;
        Profesores = Profesores2;
        // Profesores2.sort();
      }
    }

    //  loadingProfes = loadingProfes2;
    setState(() {
      loadingProfes = false;
    });
  }

  @override
  void initSate() {
    super.initState();
    _getPosts();
    if (Profesores2.isEmpty) {
      _getPosts();
    }
  }

  navigateToDetail(DocumentSnapshot post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  post: post,
                )));
  }

  writeOnPdf() async {
    pdf.addPage(pw.MultiPage(
      pageFormat:
          PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      header: (pw.Context context) {
        if (context.pageNumber == 1) {
          return null;
        }
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const pw.BoxDecoration(
                border: pw.BoxBorder(
                    bottom: true, width: 0.5, color: PdfColors.grey)),
            child: pw.Text('Portable Document Format',
                style: pw.Theme.of(context)
                    .header5
                    .copyWith(color: PdfColors.grey)));
      },
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Header(level: 0, child: pw.Text("Listado Asistencia")),

          //  pw.Table.fromTextArray(context: context, data:  Profesores[index].data["Apellidos"]
          pw.Table.fromTextArray(context: context, data: <List<String>>[
            <String>[
              'Apellidos',
              'Nombre',
              'Fecha Inicio',
              'Fecha Fin',
              'Latitud',
              'Longitud'
            ],
            // se obtiene la fecha de inicio de y de fin para imprimir en el pdf
            ...Profesores4.map((item) => [
                  item.data["Apellidos"].replaceAll(' – ', ' '),
                  item.data["Nombre"].replaceAll(' – ', ' '),
                  item.data["Fecha_inicio"].replaceAll(' – ', ' '),
                  item.data["Fecha_fin"].replaceAll(' – ', ' '),
                  item.data["Latitud"].toString(),
                  item.data["Longitud"].toString()
                ])
          ]),
          pw.Column(children: <pw.Widget>[]),
        ];
      },
    ));
  }

  Future savePdf() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;

    File file = File("$documentPath/Listado.pdf");

    file.writeAsBytesSync(pdf.save());
  }
//pdf metodos

  // pdf metodos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Listado "),
          actions: <Widget>[
            //condicion checkbox para mostrar el boton del listado de todos los usuarios.
            //         todos == false
            //                ? Center(
            //                    child: Text(" "),
            //                  )
            //                :
            IconButton(
              icon: Icon(Icons.picture_as_pdf),
              onPressed: () async {
                writeOnPdf();
                await savePdf();

                Directory documentDirectory =
                    await getApplicationDocumentsDirectory();

                String documentPath = documentDirectory.path;

                String fullPath = "$documentPath/Listado.pdf";

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PdfViewerPage(
                              path: fullPath,
                            )));
              },
            ),
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () async {
                await Printing.sharePdf(
                    bytes: pdf.save(), filename: 'Listado.pdf');
              },
            ),
            SizedBox(width: 10),
          ],
        ),
        body: _getPosts() == true
            ? Container(
                child: Center(
                child: Text("Cargando..."),
              ))
            : Center(
                child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Profesores.length == 0
                          ? Center(
                              child: Text("No existen Profesores"),
                            )
                          : ListView.builder(
                              itemCount: Profesores.length,
                              itemBuilder: (BuildContext ctx, int index) {
                                return ListTile(
                                  title: Text("Apellidos : " +
                                      Profesores[index].data["Apellidos"]),
                                  subtitle: Text(",Nombre: " +
                                      Profesores[index].data["Nombre"]),
                                  onTap: () =>
                                      navigateToDetail(Profesores[index]),
                                );
                              }),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        //       Container(
                        //                            child: Profesores.length == 0
                        //                                ? Center(
                        //                                    child: Text(" "),
                        //                                  )
                        //                                : Text("Todos")),
//                        Container(
//                            child: Profesores.length == 0
//                                ? Center(
//                                    child: Text(" "),
//                                  )
//                                : Checkbox(
//                                    value: todos,
//                                    onChanged: (bool value) {
//                                      setState(() {
//                                        todos = value;
//                                        print(todos);
//                                      });
//                                    },
//                                  )),
                      ],
                    ),
                  ),
                ],
              )));
  }
}

class DetailPage extends StatefulWidget {
  final DocumentSnapshot post;

  DetailPage({this.post});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<String> data = new List<String>();
  final pdf = pw.Document();

  _getPostss() async {
    // se crea una query para odernar por fecha
    Query q2 = _firestore2.collection("Asistencia").orderBy("Fecha_fin");
    Query q3 = _firestore2.collection("Asistencia").orderBy("Fecha_fin");
    //se filtra por apellidos y nombre
    final snapshots = q2.snapshots().map((snapshot) => snapshot.documents.where(
        (doc) =>
            doc["Apellidos"] == widget.post.data["Apellidos"] &&
            doc["Nombre"] == widget.post.data["Nombre"]));
    final snapshots2 = q3.snapshots().map((snapshot) => snapshot.documents
        .where((doc) =>
            doc["Apellidos"] == widget.post.data["Apellidos"] &&
            doc["Nombre"] == widget.post.data["Nombre"] &&
            selectedDate.isAtSameMomentAs(doc["Fecha_inicio"])));
    final snapshots3 = q3.snapshots().map((snapshot) => snapshot.documents
        .where((doc) =>
            doc["Apellidos"] == widget.post.data["Apellidos"] &&
                doc["Nombre"] == widget.post.data["Nombre"] &&
                selectedDate.isBefore(doc["Fecha_fin"]) ||
            selectedDate.isAtSameMomentAs(doc["Fecha_fin"]) &&
                selectedDate2.isAfter(doc["Fecha_inicio"]) ||
            selectedDate2.isAtSameMomentAs(doc["Fecha_inicio"])));
    setState(() {
      loadingProfes2 = true;
    });
    QuerySnapshot querySnapshot2 = await q2.getDocuments();
    //Profesores3 = querySnapshot2.documents;
    Profesores3 = (await snapshots.first).toList();
    Profesores5 = (await snapshots2.first).toList();
    Profesores6 = (await snapshots3.first).toList();
    setState(() {
      loadingProfes2 = false;
    });
  }

  @override
  void initSate() {
    super.initState();
    _getPostss();
  }

  writeOnPdf() async {
    pdf.addPage(pw.MultiPage(
      pageFormat:
          PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      header: (pw.Context context) {
        if (context.pageNumber == 1) {
          return null;
        }
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const pw.BoxDecoration(
                border: pw.BoxBorder(
                    bottom: true, width: 0.5, color: PdfColors.grey)),
            child: pw.Text('Portable Document Format',
                style: pw.Theme.of(context)
                    .header5
                    .copyWith(color: PdfColors.grey)));
      },
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Header(level: 0, child: pw.Text("Listado Asistencia")),
          pw.Paragraph(
              // se obtienen el nombre y el apellidos del usuario selccionado para imprimir en el pdf
              text: "Apellidos: " +
                  widget.post.data["Apellidos"] +
                  ", Nombre : " +
                  widget.post.data["Nombre"]),
          //  pw.Table.fromTextArray(context: context, data:  Profesores[index].data["Apellidos"]
          pw.Table.fromTextArray(context: context, data: <List<String>>[
            <String>['Fecha Inicio', 'Fecha Fin'],
            // se obtiene la fecha de inicio de y de fin para imprimir en el pdf
            ...Profesores3.map((item) => [
                  item.data["Fecha_inicio"].replaceAll(' – ', ' '),
                  item.data["Fecha_fin"].replaceAll(' – ', ' ')
                ])
          ]),
          pw.Column(children: <pw.Widget>[]),
        ];
      },
    ));
  }

  Future savePdf() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;

    File file = File("$documentPath/Listado.pdf");

    file.writeAsBytesSync(pdf.save());
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    show = true;
  }

  Future<Null> _selectDate2(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate2)
      setState(() {
        selectedDate2 = picked;
      });

    if (selectedDate2.isBefore(selectedDate)) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("La fecha debe ser posterior a la inicial."),
            );
          });
    } else {
      show2 = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () async {
              writeOnPdf();
              await savePdf();

              Directory documentDirectory =
                  await getApplicationDocumentsDirectory();

              String documentPath = documentDirectory.path;

              String fullPath = "$documentPath/Listado.pdf";

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PdfViewerPage(
                            path: fullPath,
                          )));
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              await Printing.sharePdf(
                  bytes: pdf.save(), filename: 'Listado.pdf');
            },
          ),
        ],
      ),
      body: _getPostss() == true
          ? Container(
              child: Center(
              child: Text("Cargando..."),
            ))
          : Container(
              child: Profesores3.length == 0
                  ? Center(
                      child: Text("No existen Registros"),
                    )
                  : Column(
                      children: <Widget>[
                        ListTile(
                          title:
                              //se imprime el nombre y el apellido seleccionado
                              Text("Apellidos: " +
                                  widget.post.data["Apellidos"]),
                          subtitle:
                              Text("Nombre: " + widget.post.data["Nombre"]),
                        ),
                        Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: Profesores3.length,
                              itemBuilder: (BuildContext ctx, int index) {
                                return ListTile(
                                  //se imprime la fecha de inicio y la de fin del usuario correspondiente.
                                  title: Text("Fecha Inicio: " +
                                      Profesores3[index].data["Fecha_inicio"]),
                                  subtitle: Text("Fecha Fin: " +
                                      Profesores3[index].data["Fecha_fin"]),
                                );
                              }),
                        ),
                        const SizedBox(height: 30),
                        show == false
                            ? Text("")
                            : MaterialButton(
                                child: Text(selectedDate.toString().substring(0,
                                    selectedDate.toString().indexOf(":") - 2)),
                                onPressed: () {
                                  show = false;
                                  show2 = false;
                                },
                              ),
                        if (show2) const SizedBox(height: 30),
                        show2 == false
                            ? Text("")
                            : MaterialButton(
                                child: Text(selectedDate2.toString().substring(
                                    0,
                                    selectedDate.toString().indexOf(":") - 2)),
                                onPressed: () {
                                  show2 = false;
                                },
                              )
                      ],
                    ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (show == true) {
            _selectDate2(context);
          } else {
            _selectDate(context);
          }

          //          print(selectedDate.toString());
        },
        label: show == false
            ? Center(
                child: Text("Filtrar "),
              )
            : Text('Rango'),
        icon: Icon(Icons.date_range),
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }
}

//vista de pdf
class PdfViewerPage extends StatelessWidget {
  final String path;
  const PdfViewerPage({Key key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(
        title: Text("Listado"),
        actions: <Widget>[],
      ),
      path: path,
    );
  }
}
