import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vaidya/Screens/addreport.dart';
import 'package:vaidya/models/details.dart';
import 'package:vaidya/models/symptom.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

Future<bool> saveDetails(
    {String name,
    Gender gender,
    DateTime dob,
    List<Symptom> conditions}) async {
  await FirebaseFirestore.instance
      .collection("details")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .set({
    "name": name,
    "gender": gender == Gender.male ? "male" : "female",
    "dob": dob,
    "symptoms": conditions.map((e) {
      return {"ID": e.ID, "Name": e.Name};
    }).toList()
  });

  return true;
}

class _HomePageState extends State<HomePage> {
  DateTime dob;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _name = TextEditingController();
  Gender _gender;
  var conditions = List.filled(symptoms.length, false, growable: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Enter Details"),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "Full Name"),
                  controller: _name,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Date of Birth"),
                  controller: _dateController,
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime selection = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.fromMicrosecondsSinceEpoch(0),
                        lastDate: DateTime.now());

                    dob = selection;
                    _dateController.text = selection.toString();
                  },
                ),
                Text(
                  "Gender",
                  textAlign: TextAlign.start,
                ),
                Column(
                  children: [
                    RadioListTile(
                      title: Text("Male"),
                      value: Gender.male,
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                      groupValue: _gender,
                    ),
                    RadioListTile(
                      title: Text("Female"),
                      value: Gender.female,
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                      groupValue: _gender,
                    )
                  ],
                ),
                Text("Which of the following symptoms do you have?"),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var symptom = Symptom.fromMap(symptoms[index]);
                      return CheckboxListTile(
                        value: conditions[index],
                        onChanged: (value) {
                          setState(() {
                            conditions[index] = value;
                          });
                        },
                        title: Text(symptom.Name),
                      );
                    },
                    itemCount: symptoms.length,
                  ),
                ),
                RaisedButton(
                  onPressed: () async {
                    var selectedSymptoms = List<Symptom>();
                    for (int i = 0; i < conditions.length; ++i) {
                      if (conditions[i])
                        selectedSymptoms.add(Symptom.fromMap(symptoms[i]));
                    }
                    bool saved = await saveDetails(
                        name: _name.value.text,
                        dob: dob,
                        gender: _gender,
                        conditions: selectedSymptoms);
                    print(saved);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddReport()));
                  },
                  child: Text("Next"),
                )
              ],
            ),
          ),
        ));
  }
}
