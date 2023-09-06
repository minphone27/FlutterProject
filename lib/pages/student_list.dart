import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simp_3/pages/student_create.dart';
import 'package:simp_3/pages/student_detail.dart';

class Student {
  final String id;
  final String batch;
  final String name;
  final String studentID;
  final String profile_pic;


  Student({required this.id, required this.batch, required this.name, required this.studentID,required this.profile_pic});
}

class StudentListPage extends StatefulWidget {
  @override
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
       
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Search by Name',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchText = '';
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: StudentList(searchText: _searchText),
          ),
        ],
      ),
       floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StudentFormPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class StudentList extends StatelessWidget {
  final String searchText;

  StudentList({required this.searchText});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('students').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final List<Student> students = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Student(
              id: doc.id,
              batch: data['batch'],
              name: data['name'],
              studentID: data['student_id'],
              profile_pic: data['profile_pic'],

              
            );
          }).toList();

          // Filter students by name based on the search text
          final filteredStudents = students.where((student) {
            final studentName = student.name.toLowerCase();
            return studentName.contains(searchText.toLowerCase());
          }).toList();

          return ListView.builder(
            itemCount: filteredStudents.length,
            itemBuilder: (context, index) {
              final student = filteredStudents[index];
              return CustomStudentTile(student: student,);
            },
          );
        }
      },
    );
    
  }
}


class CustomStudentTile extends StatelessWidget {
  final Student student;

  CustomStudentTile({required this.student});

  Future<void> _deleteStudent(BuildContext context) async {
    try {
      // Show a confirmation dialog
      final bool confirm = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Delete'),
            content: Text('Are you sure you want to delete ${student.name}?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // User canceled delete
                },
                child: Text('Cancel',style: TextStyle(color: Colors.black),),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // User confirmed delete
                },
                child: Text('Delete',style: TextStyle(color: Colors.black),),
              ),
            ],
          );
        },
      );

      // If the user confirmed the delete, proceed with deletion
      if (confirm) {
        // Delete the student from Firebase
        await FirebaseFirestore.instance.collection('students').doc(student.id).delete();
      }
    } catch (error) {
      // Handle any errors that occur during the delete operation
      print('Error deleting student: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
         title: Text(
        '${student.name}',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '${student.batch}',
        style: TextStyle(color: Colors.black),
      ),
      leading: CircleAvatar(
        backgroundImage: AssetImage(student.profile_pic ?? 'assets/images/dummy.png'), // Replace with your image asset path
        radius: 30, // Adjust as needed
      ),

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            child: Text("view",),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentDetailPage(studentId: student.id),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Call the delete function when the delete button is pressed
              _deleteStudent(context);
            },
          ),
        ],
      ),
    );
  }
}



