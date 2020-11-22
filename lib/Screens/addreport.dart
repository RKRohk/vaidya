import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vaidya/models/report.dart';

class AddReport extends StatefulWidget {
  @override
  _AddReportState createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  List<Report> reports = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Documents"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Do you want to add any documents?",
              textAlign: TextAlign.center,
            ),
            Expanded(
                child: ListView.builder(
              itemBuilder: (context, index) {
                var report = reports[index];
                return ListTile(
                    title: Text(report.title),
                    subtitle: Text(report.filename ?? ""));
              },
              itemCount: reports.length,
            )),
            RaisedButton(
              onPressed: () async {
                FirebaseFirestore.instance
                    .collection("details")
                    .doc(FirebaseAuth.instance.currentUser.uid)
                    .update({
                  "reports": reports.map((e) {
                    return {
                      "title": e.title,
                      "filename": e.filename,
                      "url": e.url
                    };
                  }).toList()
                });
              },
              child: Text("Submit"),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add report",
        child: Icon(Icons.add),
        onPressed: () async {
          var newReport = await showDialog<Report>(
              context: context, builder: (context) => AddReportModal());
          if (newReport != null) {
            setState(() {
              reports.add(newReport);
            });
          }
        },
      ),
    );
  }
}

class AddReportModal extends StatefulWidget {
  @override
  _AddReportModalState createState() => _AddReportModalState();
}

class _AddReportModalState extends State<AddReportModal> {
  var nameController = TextEditingController();
  var fileController = TextEditingController();
  FilePickerResult report;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Add Report"),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText: "Report Type",
                  hintText: "e.g X-Ray, Blood Test, etc"),
            ),
            GestureDetector(
              onTap: () async {
                report = await FilePicker.platform
                    .pickFiles(withData: true, allowMultiple: false);
                setState(() {
                  fileController.text = report.names[0];
                });
              },
              child: TextFormField(
                controller: fileController,
                enabled: false,
              ),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () async {
              var ref = FirebaseStorage.instance.ref(report.files.first.name);
              if (report.files.first.bytes != null) {
                var uploadTask = await ref.putData(report.files.first.bytes);
                var url = await ref.getDownloadURL();
                Navigator.pop(
                    context,
                    Report(
                        title: nameController.value.text,
                        url: url,
                        filename: report.files.first.name));
              } else
                print("File ${report.files.first.name} is null");
            },
            child: Text("Save"))
      ],
    );
  }
}
