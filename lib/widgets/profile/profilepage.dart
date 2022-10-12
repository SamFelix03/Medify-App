import 'package:flutter/material.dart';
import '../illnesslist/illnesslist.dart';
import '../userselect/userselect.dart';

class ProfilePage extends StatefulWidget {
  @override
  Function adduser;

  ProfilePage({required this.adduser});

  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var _nameController = TextEditingController();
  void submitData() {
    var enteredName = _nameController.text;
    if (enteredName.isEmpty) {
      return;
    }
    widget.adduser(name: enteredName);
    Navigator.of(context).pop();
  }

  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                "Profile Details",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                "assets/images/noprofile.jpg",
                              ))),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Colors.green,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              buildTextField("Full Name", "Max", false, _nameController),
              buildTextField("E-mail", "max2003@gmail.com", false, null),
              buildTextField("Height", "183cm", false, null),
              buildTextField("Weight", "67kg", false, null),
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // OutlinedButton(
                  //   style: OutlinedButton.styleFrom(
                  //       padding: EdgeInsets.symmetric(horizontal: 50),
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(20))),
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  //   child: Text("CANCEL",
                  //       style: TextStyle(
                  //           fontSize: 14,
                  //           letterSpacing: 2.2,
                  //           color: Colors.black)),
                  // ),
                  ElevatedButton(
                    onPressed: (() => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IllnessList(),
                        ))),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.green,
                      elevation: 6,
                    ),
                    child: Text(
                      "VIEW HEALTH RECORDS",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder,
      bool isPasswordTextField, controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      // child: TextField(
      //   controller: controller,
      //   obscureText: isPasswordTextField ? showPassword : false,
      //   decoration: InputDecoration(
      //       suffixIcon: isPasswordTextField
      //           ? IconButton(
      //               onPressed: () {
      //                 setState(() {
      //                   showPassword = !showPassword;
      //                 });
      //               },
      //               icon: Icon(
      //                 Icons.remove_red_eye,
      //                 color: Colors.grey,
      //               ),
      //             )
      //           : null,
      //       contentPadding: EdgeInsets.only(bottom: 3),
      //       labelText: labelText,
      //       floatingLabelBehavior: FloatingLabelBehavior.always,
      //       hintText: placeholder,
      //       hintStyle: TextStyle(
      //         fontSize: 16,
      //         fontWeight: FontWeight.bold,
      //         color: Colors.black,
      //       )),
      // ),
      child: Card(
        child: ListTile(
          leading: Text(
            "${labelText} :",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          title: Text(
            placeholder,
          ),
        ),
      ),
    );
  }
}
