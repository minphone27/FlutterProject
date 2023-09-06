import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simp_3/pages/student_update.dart';


class StudentDetailPage extends StatefulWidget {
  final String studentId;

  StudentDetailPage({required this.studentId});

  @override
  _StudentDetailPageState createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {
  String? _studentName;
  String? _studentBatch;
  String? _studentPhoneNumber;
  String? _studentEmail;
  String? _studentDateOfBirth;
  String? _studentProfile;
  String? _studentID;

  void _fetchStudentData() {
    FirebaseFirestore.instance
        .collection('students')
        .doc(widget.studentId)
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _studentName = data['name'];
          _studentBatch = data['batch'];
          _studentPhoneNumber = data['phone_number'];
          _studentEmail = data['email'];
          _studentDateOfBirth = data['date_of_birth'];
          _studentProfile = data['profile_pic'];
          _studentID = data['student_id'];

        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchStudentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_studentName ?? 'loading...'),
        actions: [
          TextButton(
            child: Text("update",style: TextStyle(color: Colors.white),),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentUpdateFormPage(studentId: widget.studentId),
                ),
              );
            },
          ),
         
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Center(
              child: Image.asset(_studentProfile ?? 'assets/images/dummy.png',
              width: 100,
              height: 100,
              ),
              )
              ,
            ListTile(
              title: Text('Name'),
              subtitle: Text(_studentName ?? 'Loading...'),
            ),
            ListTile(
              title: Text('Student ID'),
              subtitle: Text(_studentID ?? 'Loading...'),
            ),
            ListTile(
              title: Text('Batch'),
              subtitle: Text(_studentBatch ?? 'Loading...'),
            ),
            ListTile(
              title: Text('Phone Number'),
              subtitle: Text(_studentPhoneNumber ?? 'Loading...'),
            ),
            ListTile(
              title: Text('Email'),
              subtitle: Text(_studentEmail ?? 'Loading...'),
            ),
            ListTile(
              title: Text('Date of Birth'),
              subtitle: Text(_studentDateOfBirth ?? 'Loading...'),
            ),
          ],
        ),
      ),
    );
  }
}
