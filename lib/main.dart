import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee/form_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const floating(),
    );
  }
}

class floating extends StatefulWidget {
  const floating({Key? key}) : super(key: key);

  @override
  State<floating> createState() => _floatingState();
}

class _floatingState extends State<floating> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<User>>(
        stream: readUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something Went Wrong");
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView(
              children: users.map(buildUser).toList(),
            );
          }
          else if(snapshot.hasData && snapshot.data!.isEmpty){
            return Center(child: Text("No data",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),));

          }
          // } else if (snapshot.hasData && snapshot.data?.users.isEmpty) {
          //   return Text("No data",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),);
          // }
          else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => formscreen()));
        },
      ),
    );
  }

  Widget buildUser(User user) => Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListTile(
                    // leading: Icon(Icons.arrow_drop_down_circle),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text('${user.name}'),
                    ),

                    subtitle: Text(
                      '${user.email}',
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                          height: 25,
                          width: 70,
                          child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  elevation: 10,
                                  primary: user.experience >= 5
                                      ? Colors.green
                                      : Colors.red,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              icon: Icon(
                                Icons.star,
                                size: 15,
                              ),
                              onPressed: () {},
                              label: Text(
                                "${user.experience}",
                                style: TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.bold),
                              ))),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: Column(
                children: [
                  Divider(
                    color: Colors.black,
                    height: 20,
                    thickness: .5,
                    indent: 10,
                    endIndent: 10,
                  ),
                  Text(
                    'UserID : ${user.company_id}',
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ],
              ),
            )
          ],
        ),
      );
  Stream<List<User>> readUsers() => FirebaseFirestore.instance
      .collection("users")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
}

class infowidgets extends StatelessWidget {
  const infowidgets({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListTile(
                  // leading: Icon(Icons.arrow_drop_down_circle),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: const Text(''),
                  ),

                  subtitle: Text(
                    'Secondary Text',
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                        height: 25,
                        width: 70,
                        child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                elevation: 10,
                                primary: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            icon: Icon(
                              Icons.star,
                              size: 15,
                            ),
                            onPressed: () {},
                            label: Text(
                              "4.3",
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ))),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Column(
              children: [
                Divider(
                  color: Colors.black,
                  height: 20,
                  thickness: .5,
                  indent: 10,
                  endIndent: 10,
                ),
                Text(
                  'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Future createUser({required String name}) async {
  final docUser = FirebaseFirestore.instance.collection("users").doc();
  // final json = {"name": name, "company_id": 21, "birthday": DateTime(2001, 7, 20)};
  final user = User(
    id: docUser.id,
    name: name,
    email: "a@gmail.com",
    company_id: 21,
    experience: 66,
  );

  final json = user.toJson();
  await docUser.set(json);
}

class User {
  String? id;
  final String? email;
  final String name;
  final int company_id;
  final int experience;
  User(
      {this.id = "",
      required this.email,
      required this.name,
      required this.company_id,
      required this.experience});
  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "company_id": company_id,
        "experience": experience
      };
  static User fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      company_id: json["company_id"],
      experience: json["experience"]);
}
