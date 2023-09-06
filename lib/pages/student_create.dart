import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import 'dart:math';


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

String generateRandomImageUrl() {
  final List<String> imageUrls = [
     'assets/images/Frame1.png',
    'assets/images/Frame2.png',
    'assets/images/Frame3.png',
    'assets/images/Frame4.png',
    'assets/images/Frame5.png',
    'assets/images/Frame6.png',
    'assets/images/Frame7.png',
    'assets/images/Frame8.png',
    'assets/images/Frame9.png',

  ];

  final Random random = Random();
  final int randomIndex = random.nextInt(imageUrls.length);

  return imageUrls[randomIndex];
}


class StudentFormPage extends StatefulWidget {
  @override
  _StudentFormPageState createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _batchController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, save data to Firestore
      final student = Student(
        studentId: _studentIdController.text,
        name: _nameController.text,
        batch: _batchController.text,
        phoneNumber: _phoneNumberController.text,
        email: _emailController.text,
        dateOfBirth: _dobController.text!,
      );

      FirebaseFirestore.instance.collection('students').add({
        'student_id': student.studentId,
        'name': student.name,
        'batch': student.batch,
        'phone_number': student.phoneNumber,
        'email': student.email,
        'date_of_birth': student.dateOfBirth,
        'profile_pic': generateRandomImageUrl(),

      });

      // Clear form fields
      _studentIdController.clear();
      _nameController.clear();
      _batchController.clear();
      _phoneNumberController.clear();
      _emailController.clear();
      _dobController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student added successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _studentIdController,
                decoration: InputDecoration(labelText: 'Student ID'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a student ID';
                  }
                  return null;
                },
              ),
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
                decoration: InputDecoration(labelText: 'Date of birth'),
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
                child: Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
