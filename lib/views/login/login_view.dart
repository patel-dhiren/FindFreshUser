import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../firebase/firebase_service.dart';
import '../../gen/assets.gen.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>(); // Add this line
  String mobileNumber = '';

  void _verifyPhoneNumber() async {
    FirebaseService().verifyPhoneNumber(
      mobileNumber,
      () {
        Navigator.pushNamed(context, AppConstant.verificationView,
            arguments: mobileNumber);
      },
      (String message) {
        print('error : $message');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Assets.images.veggieBg.image(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    // Wrap your Column in a Form widget
                    key: _formKey, // Add this line
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Get your groceries\nwith Find Fresh',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          // Change TextField to TextFormField
                          decoration: InputDecoration(
                            labelText: 'Enter Mobile Number',
                            prefixIcon: Icon(Icons.call),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your mobile number';
                            } else if (value.length != 10) {
                              // Assuming Indian mobile numbers
                              return 'Please enter a valid 10-digit mobile number';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            mobileNumber = "+91$value";
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Add this line
                                // If the form is valid, display a Snackbar.
                                _formKey.currentState!.save(); // Save the form
                                _verifyPhoneNumber();
                              }
                            },
                            child: Text('CONTINUE'),
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
}
