import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:employee/main.dart';
import 'package:flutter/material.dart';

class formscreen extends StatefulWidget {
  const formscreen({Key? key}) : super(key: key);

  @override
  State<formscreen> createState() => _formscreenState();
}

class _formscreenState extends State<formscreen> {
  final namecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final idcontroller = TextEditingController();
  final experincecontroller = TextEditingController();
  @override
  void dispose() {
    namecontroller.dispose();
    emailcontroller.dispose();
    experincecontroller.dispose();
    idcontroller.dispose();
    super.dispose();
  }

  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formkey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                    TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: namecontroller,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(labelText: "Name"),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailcontroller,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(labelText: "Email"),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? "Enter a valid email"
                            : null,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  TextFormField(
                    maxLength: 10,
                    controller: idcontroller,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
    
                    // inputFormatters: [],
                    decoration: InputDecoration(labelText: "Enter the Id"),
                    validator: (id) {
                      if (id != null && id.length < 10) {
                        return " Enter valid ID";
                      } else {
                        return null;
                      }
                      // return id.length<6 ? "Id should be greater than 6 characters" : null;
                    },
                  ),
                  TextFormField(
                    maxLength: 2,
                    controller: experincecontroller,
                    onTap: () {
                      final age = experincecontroller.text;
                      // createUser(name: name, age: age, bday: bday)
                    },
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.phone,
                    // inputFormatters: [],
                    textInputAction: TextInputAction.next,
                    decoration:
                        InputDecoration(labelText: "Work Experience in Years"),
                    validator: (val) {
                      if (val != null && val.length > 2) {
                        return "Enter valid number";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        final user = User(
                          email: emailcontroller.text,
                            name: namecontroller.text,
                            company_id: int.parse(idcontroller.text),
                            experience: int.parse(experincecontroller.text));
                        createUser(user);
                        Navigator.pop(context);
    
                        // createUser(name: name,age: ,bday: )
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: ((context) => datascreen())));
                      },
                      icon: Icon(Icons.add),
                      label: Text(
                        "Add",
                        style: TextStyle(fontSize: 15),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future createUser(User user) async {
    final docUser = FirebaseFirestore.instance.collection("users").doc();
    user.id = docUser.id;

    final json = user.toJson();
    await docUser.set(json);
  }
}
