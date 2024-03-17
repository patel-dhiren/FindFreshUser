import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import '../../constants/constants.dart';
import '../../firebase/firebase_service.dart';
import '../../gen/assets.gen.dart';
import '../../models/user_data.dart';


class UserDetailView extends StatefulWidget {
  UserCredential credential;

  UserDetailView({required this.credential});

  @override
  State<UserDetailView> createState() => _UserDetailViewState();
}

class _UserDetailViewState extends State<UserDetailView> {
  final _formKey = GlobalKey<FormState>();

  // Define controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Assets.images.logo.image(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Complete your profile',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
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
                            if (value!.isNotEmpty &&
                                !RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b')
                                    .hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              foregroundColor: Colors.white
                            ),
                            child: Text('CREATE ACCOUNT'),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // If the form is valid, save the form and proceed
                                _formKey.currentState!.save();
                                var result = await FirebaseService().createUser(UserData(
                                    id: widget.credential.user!.uid,
                                    contact: widget.credential.user!.phoneNumber!,
                                    name: _nameController.text.trim(),
                                    email: _emailController.text.trim(),
                                    createdAt:
                                    DateTime.now().millisecondsSinceEpoch));

                                if(result){
                                  Navigator.pushNamedAndRemoveUntil(context, AppConstant.homeView, (route) => false);
                                }

                              }
                            },
                          ),
                        )
                      ],
                    ),
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
