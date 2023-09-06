import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simp_3/pages/student_list.dart';

class Student {
  final String studentId;
  final String name;
  final String batch;
  final String phoneNumber;
  final String email;
  final String dateOfBirth;

  Student({
    required this.studentId,
    required this.name,
    required this.batch,
    required this.phoneNumber,
    required this.email,
    required this.dateOfBirth,
  });
}

class StudentUpdateFormPage extends StatefulWidget {
  final String studentId;

  StudentUpdateFormPage({required this.studentId});

  @override
  _StudentUpdateFormPageState createState() => _StudentUpdateFormPageState();
}

class _StudentUpdateFormPageState extends State<StudentUpdateFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _batchController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, update data in Firestore
      FirebaseFirestore.instance
          .collection('students')
          .doc(widget.studentId)
          .update({
        'name': _nameController.text,
        'batch': _batchController.text,
        'phone_number': _phoneNumberController.text,
        'email': _emailController.text,
        'dateOfBirth': _dobController.text,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Student updated successfully')),
          
        );
         Navigator.push(
          context, MaterialPageRoute(builder: (context) => StudentListPage()));
       
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating student')),
        );
      });
    }
  }

  void _fetchStudentData() {
    FirebaseFirestore.instance
        .collection('students')
        .doc(widget.studentId)
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = data['name'];
          _batchController.text = data['batch'];
          _phoneNumberController.text = data['phone_number'];
          _emailController.text = data['email'];
          _dobController.text = data['date_of_birth'];
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
        title: Text('Update ${_nameController.text}'),
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _batchController,
                decoration: InputDecoration(labelText: 'Batch'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a batch';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty || !value!.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(labelText: 'Date of Birth'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter date of birth';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
