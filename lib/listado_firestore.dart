import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

Firestore _firestore = Firestore.instance;
Firestore _firestore2 = Firestore.instance;
List<DocumentSnapshot> Profesores = [];
List<DocumentSnapshot> Profesores2 = [];
List<DocumentSnapshot> Profesores3 = [];
bool loadingProfes = true;
bool loadingProfes2 = true;

class _ListPageState extends State<ListPage> {
  _getPosts() async {
    Query q = _firestore.collection("Asistencia");

    setState(() {
      loadingProfes = true;
    });
    QuerySnapshot querySnapshot = await q.getDocuments();
    Profesores = querySnapshot.documents;
    Profesores2 = querySnapshot.documents;
    int eliminado = 0;

    for (var i = 0; i < Profesores.length; i++) {
      if (eliminado == 1) {
        i = i - 1;
        eliminado = 0;
      }
      if (Profesores[i].data["Apellidos"] ==
          Profesores2[i + 1].data["Apellidos"]) {
        Profesores.removeAt(i + 1);
        eliminado = 1;
      }
    }
    setState(() {
      loadingProfes = false;
    });
  }

  @override
  void initSate() {
    super.initState();
    _getPosts();
  }

  navigateToDetail(DocumentSnapshot post) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  post: post,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Listado ")),
        body: _getPosts() == true
            ? Container(
                child: Center(
                child: Text("Cargando..."),
              ))
            : Container(
                child: Profesores.length == 0
                    ? Center(
                        child: Text("No existen Profesores"),
                      )
                    : ListView.builder(
                        itemCount: Profesores.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return ListTile(
                            title: Text(Profesores[index].data["Apellidos"]),
                            onTap: () => navigateToDetail(Profesores[index]),
                          );
                        }),
              ));
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
    Query q3 = _firestore2
        .collection("Asistencia")
        .where("Nombre", isEqualTo: widget.post.data["Nombre"].toString())
        .orderBy("Fecha_fin");
    //se filtra por apellidos y nombre
    final snapshots = q2.snapshots().map((snapshot) => snapshot.documents.where(
        (doc) =>
            doc["Apellidos"] == widget.post.data["Apellidos"] &&
            doc["Nombre"] == widget.post.data["Nombre"]));

    setState(() {
      loadingProfes2 = true;
    });
    QuerySnapshot querySnapshot2 = await q2.getDocuments();
    //Profesores3 = querySnapshot2.documents;
    Profesores3 = (await snapshots.first).toList();
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
          SizedBox(width: 10),
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
                              Text("Apellidos: " + widget.post.data["Apellidos"]),
                          subtitle:
                              Text("Nombre: " + widget.post.data["Nombre"]),
                        ),
                        ListView.builder(
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
                      ],
                    ),
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
      path: path,
    );
  }
}
