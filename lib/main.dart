// ignore_for_file: library_private_types_in_public_api
import 'package:attendance_web_app/Functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DICT Attendance Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AttendanceForm(),
    );
  }
}

class AttendanceForm extends StatefulWidget {
  const AttendanceForm({super.key});

  @override
  _AttendanceFormState createState() => _AttendanceFormState();
}

class _AttendanceFormState extends State<AttendanceForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoggedIn = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _stController = TextEditingController();
  String? _sex;
  String? _purpose;
  bool _consentGiven = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color of the scaffold
      appBar: AppBar(
        backgroundColor: Colors.white, // Set background color of the app bar
        title: const Text('Attendance Form'),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.dashboard),
          onPressed: () {
            if (!_isLoggedIn) {
              // Show login dialog if not logged in
              _showLoginDialog(context);
            } else {
              // Directly show dashboard if already logged in
              _showDashboard();
            }
          },
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 100,
                width: 200,
                child: Opacity(
                  opacity: 0.5, // Set opacity value between 0.0 to 1.0
                  child: Image.asset(
                    'assets/dict.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                width: 200,
                child: Opacity(
                  opacity: 0.5, // Set opacity value between 0.0 to 1.0
                  child: Image.asset(
                    'assets/ilcdb.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                width: 200,
                child: Opacity(
                  opacity: 0.5, // Set opacity value between 0.0 to 1.0
                  child: Image.asset(
                    'assets/bagong-pilipinas.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                width: 200,
                child: Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    'assets/tech4ed.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                width: 200,
                child: Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    'assets/dtc.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
          // Sample image
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth;
                double formWidth;
                if (maxWidth < 600) {
                  formWidth = maxWidth;
                } else {
                  formWidth = 550;
                }
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey), // Add border decoration
                    ),
                    child: SizedBox(
                      width: formWidth,
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(labelText: 'Name'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(labelText: 'Phone Number'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                return null;
                              },
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(15),
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              ],
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(labelText: 'Email'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                            DropdownButtonFormField<String>(
                              value: _sex,
                              onChanged: (newValue) {
                                setState(() {
                                  _sex = newValue;
                                });
                              },
                              items: [
                                'Male',
                                'Female'
                              ]
                                  .map((sex) => DropdownMenuItem(
                                        value: sex,
                                        child: Text(sex),
                                      ))
                                  .toList(),
                              decoration: const InputDecoration(labelText: 'Sex'),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select your sex';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _stController,
                              decoration: const InputDecoration(labelText: 'Sector'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your sector';
                                }
                                return null;
                              },
                            ),
                            DropdownButtonFormField<String>(
                              value: _purpose,
                              onChanged: (newValue) {
                                setState(() {
                                  _purpose = newValue;
                                });
                              },
                              items: [
                                '(CI) Upgrade / Maintenance of Equipment (Software/Hardware)',
                                '(CI) Internet Connectivity',
                                '(CI) Capability Building for Center Managers',
                                '(TA) Online Transactions on Government Sites',
                                '(TA) School-related Support',
                                '(TA) Venue for Meetings / Webinars / Online Class',
                                '(CI/TA) Lending of ICT Equipment',
                                '(CI/TA) General Client-related'
                              ]
                                  .map((purpose) => DropdownMenuItem(
                                        value: purpose,
                                        child: Text(purpose),
                                      ))
                                  .toList(),
                              decoration: const InputDecoration(labelText: 'Purpose of Visit'),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select the purpose of your visit';
                                }
                                return null;
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: CheckboxListTile(
                                title: const Text(
                                  'I am giving consent to DICT Region V Catanduanes to collect and process my information in order for me to join any of the webinars under this cluster. My information will not be shared to any DICT Region V affiliated partners or service providers, and will only be used for data reports and for communication before the start and end of the webinar.',
                                  style: TextStyle(fontSize: 12),
                                ),
                                value: _consentGiven,
                                onChanged: (value) {
                                  setState(() {
                                    _consentGiven = value!;
                                  });
                                },
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _consentGiven
                                  ? () {
                                      if (_formKey.currentState!.validate()) {
                                        DateTime now = DateTime.now();
                                        String currentDate = "${now.year}-${now.month}-${now.day}";
                                        String currentTime = DateFormat.jm().format(now);

                                        CollectionReference collRef = FirebaseFirestore.instance.collection('attendance');
                                        collRef.add({
                                          'date': currentDate,
                                          'time': currentTime,
                                          'name': _nameController.text,
                                          'phone': _phoneController.text,
                                          'email': _emailController.text,
                                          'sex': _sex,
                                          'sector': _stController.text,
                                          'purpose': _purpose,
                                        });

                                        _showPopupMessage();
                                        // Clear text fields
                                        _nameController.clear();
                                        _phoneController.clear();
                                        _emailController.clear();
                                        _stController.clear();
                                        setState(() {
                                          _sex = null;
                                          _purpose = null;
                                          _consentGiven = false;
                                        });
                                      } else if (_consentGiven) {
                                        setState(() {
                                          _consentGiven = false;
                                        });
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Information Required'),
                                            content: const Text('Please fill out the necessary requirements to proceed.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Ok'),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    }
                                  : null,
                              child: const Text('Submit'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _login(BuildContext context) {
    // Implement your login logic here
    // For demonstration, let's just compare with hardcoded credentials
    if (_usernameController.text.trim() == 'admin' && _passwordController.text.trim() == 'admin123') {
      // Set login status to true
      setState(() {
        _isLoggedIn = true;
      });
      // Close the login dialog
      Navigator.of(context).pop();
      // Show the dashboard after successful login
      _showDashboard();
      _usernameController.clear();
      _passwordController.clear();
    } else {
      // Show error message for invalid credentials
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('Invalid username or password. Please try again.'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _showDashboard() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
          future: FirebaseFirestore.instance.collection('attendance').get(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            return AlertDialog(
              title: const Text('Client Records'),
              content: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(
                      label: Text(
                        'DATE',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'TIME',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'NAME',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'PHONE NUMBER',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'EMAIL',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'SEX',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'SECTOR',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'PURPOSE OF VISIT',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    return DataRow(cells: [
                      DataCell(Text(data['date'] ?? '')),
                      DataCell(Text(data['time'] ?? '')),
                      DataCell(Text(data['name'] ?? '')),
                      DataCell(Text(data['phone'] ?? '')),
                      DataCell(Text(data['email'] ?? '')),
                      DataCell(Text(data['sex'] ?? '')),
                      DataCell(Text(data['sector'] ?? '')),
                      DataCell(Text(data['purpose'] ?? '')),
                    ]);
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    exportToExcel('Attendance');
                  },
                  child: const Text('Export'),
                ),
                TextButton(
                  onPressed: () {
                    _clearAllConfirmation();
                  },
                  child: const Text('Clear'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    setState(() {
                      _isLoggedIn = false;
                    });
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _clearAllConfirmation() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to clear all records?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _clearAllRecords();
                Navigator.of(context).pop();
              },
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }

  void _clearAllRecords() {
    FirebaseFirestore.instance.collection('attendance').get().then((snapshot) {
      if (snapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('There are no records to clear.'),
          ),
        );
      } else {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
          setState(() {
            Navigator.of(context).pop();
            _showDashboard();
          });
        }
      }
    });
  }

  void _showPopupMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Message'),
          content: const Text('Your attendance has been successfully submitted.\nThank you for your participation!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Okay'),
            ),
          ],
        );
      },
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Login')),
          content: LoginDialogContent(
            usernameController: _usernameController,
            passwordController: _passwordController,
            onLogin: () => _login(context),
          ),
        );
      },
    );
  }
}

class LoginDialogContent extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;

  const LoginDialogContent({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          controller: usernameController,
          decoration: const InputDecoration(labelText: 'Username'),
        ),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Password'),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0), // Add space between input fields and buttons
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ElevatedButton(
                onPressed: onLogin,
                child: const Text('Login'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


//------------------------------------------------------------------------------
