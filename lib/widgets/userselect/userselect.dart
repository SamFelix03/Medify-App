import 'package:Medify/widgets/profile/editprofilepage.dart';
import 'package:Medify/widgets/profile/profilepage.dart';
import 'package:flutter/material.dart';
import 'newuser.dart';
import '../illnesslist/illnesslist.dart';

class UserSelectPage extends StatefulWidget {
  @override
  State<UserSelectPage> createState() => _UserSelectPageState();
}

class _UserSelectPageState extends State<UserSelectPage> {
  @override
  List<Map<String, Object>> userList = [
    {'name': 'Max', 'id': 'u1'},
    {'name': 'Sam', 'id': 'u2'},
    {'name': 'Sai', 'id': 'u3'},
    {'name': 'Ritesh', 'id': 'u4'},
  ];

  void _addUserDetails(BuildContext ctx) {
    Navigator.push(
        ctx,
        MaterialPageRoute(
          builder: (context) => AddProfile(
            adduser: _addUser,
          ),
        ));
  }

  void _addUser({name}) {
    setState(() {
      userList.add({'name': name, 'id': 'u${userList.length + 1}'});
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text("Users"),
          actions: [
            IconButton(
              onPressed: (() => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(),
                  ))),
              icon: Text("Edit"),
            ),
          ],
        ),
        body: userList.isEmpty
            ? Center(
                child: Container(
                    child: const Text(
                  "No users found, tap the '+' button below to add new user",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
              )
            : ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(
                              adduser: _addUser,
                            ),
                          ));
                    },
                    child: Container(
                      width: 150,
                      height: 80,
                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Image.asset("assets/images/noprofile.jpg"),
                            radius: 30,
                          ),
                          title: Text(
                            userList[index]["name"] as String,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
            onPressed: () => _addUserDetails(context),
            child: const Icon(Icons.add)));
  }
}
