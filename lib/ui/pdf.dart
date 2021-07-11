import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

class Pdf extends StatefulWidget {
  String url;

  Pdf(this.url);
  @override
  _PdfState createState() => _PdfState();
}

class _PdfState extends State<Pdf> {
bool _isLoading = true;
PDFDocument doc;

@override
void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

  void load() async {
    print(widget.url);
    doc = await PDFDocument.fromURL(widget.url);
    setState(() {
      _isLoading = false;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber)))
          : PDFViewer(
            
            // scrollDirection: Axis.vertical,
            showNavigation: false,
            showPicker: false,
            document: doc));
  }
}