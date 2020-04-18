import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homePage.dart';
class LoginPage extends StatefulWidget{
  @override
  LoginPageState createState(){
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage>{

  bool isLoggedIn = true;

  bool showPassword = true;

  final formKey = GlobalKey<FormState>();

//  FirebaseAuth firebaseAuth;


  String name, password;

  loginUser() async{
    if(formKey.currentState.validate()){
      formKey.currentState.save();
      setState((){
        isLoggedIn = false;
      });
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: name, password: password).then((data){
        print('LoggedIn');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }).catchError((error){
        setState((){
          isLoggedIn = true;
        });
        print(error.toString());
      });
    }
  }

  @override
  Widget build(BuildContext contex){
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.pinkAccent,
        body: Center(
          child: isLoggedIn? SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 15.0,
                child: Container(

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                  ),

                  height: MediaQuery.of(context).size.height * 0.45,
                  padding: EdgeInsets.all(10.0),

                  child: Form(

                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          validator: (input){
                            if(input.length == 0){
                              return 'Enter Valid Email';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Name',
                          ),
                          onSaved: (input) => name = input,
                        ),
                        SizedBox(height: 15.0,),
                        TextFormField(
                          obscureText: showPassword,

                          validator: (input){
                            if(input.length == 0){
                              return 'Please Enter Password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: showPassword? GestureDetector(child: Icon(Icons.panorama_fish_eye),
                            onTap: (){
                              setState((){
                                showPassword = false;
                              });
                            },) : GestureDetector(child: Icon(Icons.remove_red_eye),
                              onTap: (){
                                setState((){
                                  showPassword = true;
                                });
                              },),
                            labelText: 'Password',
                          ),
                          onSaved: (input) => password = input,
                        ),
                        SizedBox(
                          height: 55,
                        ),
                        RaisedButton(
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                          shape: RoundedRectangleBorder(

                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.pinkAccent,
                          child: Text('LOGIN', style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            letterSpacing: 1.0,
                          )),
                          onPressed: (){
                            loginUser();
                          }
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ): CircularProgressIndicator(),
        ),
      ),
    );
  }
}