import 'package:flutter/material.dart';

import '../../firebase/firebase_service.dart';
import '../../models/user_data.dart';

class ProfileUpdateView extends StatefulWidget {
  final UserData userData;

  ProfileUpdateView(this.userData);

  @override
  State<ProfileUpdateView> createState() => _ProfileUpdateViewState();
}

class _ProfileUpdateViewState extends State<ProfileUpdateView> {
  final _formKey = GlobalKey<FormState>();

  // Define controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.userData.name;
    _emailController.text = widget.userData.email;
    _contactController.text = widget.userData.contact;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Update Profile',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          icon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email (Optional)',
                          icon: Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              !RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b')
                                  .hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _contactController,
                        enabled: false,
                        // Change TextField to TextFormField
                        decoration: InputDecoration(
                          labelText: 'Enter Mobile Number',
                          prefixIcon: Icon(Icons.call),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, save the form and proceed
                            _formKey.currentState!.save();
                            // Update the user's profile
                            widget.userData.name = _nameController.text;
                            widget.userData.email = _emailController.text;
                            // Update the user's data in the database
                            await FirebaseService()
                                .updateUserData(widget.userData);
                            // Navigate back to the previous screen
                            Navigator.pop(context, true);
                          }
                        },
                        child: Text('Update Profile'),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
