import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:intl/intl.dart';
import 'package:jandulaseneca/sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';

class ListUser extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

Firestore _firestore = Firestore.instance;
Firestore _firestore2 = Firestore.instance;
List<DocumentSnapshot> Profesores3 = [];
List<DocumentSnapshot> Profesores6 = [];
bool loadingProfes = true;
var show = false;
//busqueda
DateTime selectedDate = DateTime.now();

class _ListPageState extends State<ListUser> {
  final pdf = pw.Document();
  _getPosts() async {
    Query q = _firestore
        .collection("Asistencia")
        .orderBy("Apellidos")
        .orderBy("Nombre");
    Query q2 = _firestore2.collection("Asistencia").orderBy("Fecha_fin");
    Query q3 = _firestore2
        .collection("Asistencia")
        .where("Nombre", isEqualTo: name)
        .orderBy("Fecha_fin");
    //se filtra por apellidos y nombre
    final snapshots = q2.snapshots().map((snapshot) => snapshot.documents.where(
        (doc) => doc["Apellidos"] == apellidos && doc["Nombre"] == name));
    setState(() {
      loadingProfes = true;
    });
    QuerySnapshot querySnapshot = await q.getDocuments();
    QuerySnapshot querySnapshot2 = await q2.getDocuments();
    Profesores3 = (await snapshots.first).toList();
    //  loadingProfes = loadingProfes2;
    setState(() {
      loadingProfes = false;
    });
  }

  @override
  void initSate() {
    super.initState();
    _getPosts();
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
              text: "Apellidos: " + apellidos + ", Nombre : " + name),
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
      body: _getPosts() == true
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
                              Text("Apellidos: " + apellidos),
                          subtitle: Text("Nombre: " + name),
                        ),
                        Expanded(
                          child: show == true && Profesores6.length != 0
                              ? Center(
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: Profesores6.length,
                                      itemBuilder:
                                          (BuildContext ctx, int index) {
                                        return ListTile(
                                          //se imprime la fecha de inicio y la de fin del usuario correspondiente.
                                          title: Text("Fecha Inicio: " +
                                              Profesores6[index]
                                                  .data["Fecha_inicio"]),
                                          subtitle: Text("Fecha Fin: " +
                                              Profesores6[index]
                                                  .data["Fecha_fin"]),
                                        );
                                      }),
                                )
                              : ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: Profesores3.length,
                                  itemBuilder: (BuildContext ctx, int index) {
                                    return ListTile(
                                      //se imprime la fecha de inicio y la de fin del usuario correspondiente.
                                      title: Text("Fecha Inicio: " +
                                          Profesores3[index]
                                              .data["Fecha_inicio"]),
                                      subtitle: Text("Fecha Fin: " +
                                          Profesores3[index].data["Fecha_fin"]),
                                    );
                                  }),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Query q2 = _firestore2.collection("Asistencia").orderBy("Fecha_fin");

          DateTime now = DateTime.now();
          DateTime last = DateTime.now();
          DateTimeRangePicker(
              startText: "Inicio",
              endText: "Fin",
              doneText: "Aceptar",
              cancelText: "Cancelar",
              interval: 5,
              initialStartTime: now.toLocal(),
              initialEndTime: last.toLocal().add(Duration(days: 20)),
              mode: DateTimeRangePickerMode.dateAndTime,
              minimumTime:
                  DateTime.now().toLocal().subtract(Duration(days: 25)),
              maximumTime: DateTime.now().toLocal().add(Duration(days: 25)),
              onConfirm: (start, end) async {
                print(start);
                print(end);
                if (start.isBefore(end)) {
                  show = true;
                  print(new DateFormat('yyyy-MM-dd – kk:mm').format(start));
                  print(new DateFormat('yyyy-MM-dd – kk:mm').format(end));
                  Query q = _firestore
                      .collection("Asistencia")
                      .where("Nombre", isEqualTo: name)
                      .where("Apellidos", isEqualTo: apellidos)
                      .where("Fecha_inicio",
                          isGreaterThanOrEqualTo:
                              new DateFormat('yyyy-MM-dd – kk:mm')
                                  .format(start))
                      .where("Fecha_inicio",
                          isLessThanOrEqualTo:
                              new DateFormat('yyyy-MM-dd – kk:mm').format(end));

                  QuerySnapshot querySnapshot = await q.getDocuments();
                  Profesores6 = querySnapshot.documents;
                  for (int i = 0; i < Profesores6.length; i++) {
                    print(Profesores6[i]);
                  }
                  // navigateToDetail(start, end, Profesores6[Profesores6.length]);
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Error"),
                          content: Text(
                              "La fecha de fin debe ser posterior a la inicial."),
                        );
                      });
                }
              }).showPicker(context);
        },
        label: Center(
          child: Text("Filtrar "),
        ),
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
