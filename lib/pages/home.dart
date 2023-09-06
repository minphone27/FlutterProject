import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:simp_3/pages/login.dart';
import 'package:simp_3/pages/student_list.dart'; // Import the intl package

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  DateTime? _lastLoggedInTime;
  String? _currentDay;
  String? _currentDate;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _getCurrentDateAndTime();
  }

  Future<void> _getUserInfo() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });

      // Fetch the last logged-in time
      final UserMetadata metadata = user.metadata;
      setState(() {
        _lastLoggedInTime = metadata.lastSignInTime;
      });
    }
  }

  void _getCurrentDateAndTime() {
    final now = DateTime.now();
    final dateFormat = DateFormat.yMMMMd('en_US'); // Customize the format as needed
    final timeFormat = DateFormat.jm(); // Customize the time format as needed

    setState(() {
      _currentDay = DateFormat('EEEE').format(now); // Retrieve the day of the week
      _currentDate = dateFormat.format(now); // Retrieve the formatted date
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _auth.signOut();
               Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage())); // Replace with your login route
            },
          ),
        ],
        automaticallyImplyLeading: false
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome, ${_user?.email ?? 'Guest'}!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Today is $_currentDay, $_currentDate', // Display the current day and date
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the student management page
                Navigator.push(context,
                      MaterialPageRoute(builder: (context) => StudentListPage())); // Replace with your student management route
              },
              child: Text('Manage Students'),
            ),
            SizedBox(height: 20),
            if (_lastLoggedInTime != null)
              Text(
                'Last logged in: ${_lastLoggedInTime?.toString()}',
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
