// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfReadScreen extends StatefulWidget {
  PdfReadScreen({required this.pdfPath});
  String pdfPath;
  @override
  State<PdfReadScreen> createState() => _PdfReadScreenState();
}

class _PdfReadScreenState extends State<PdfReadScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SfPdfViewer.asset(
              widget.pdfPath,
            ),
          ],
        ),
      ),
    );
  }
}
