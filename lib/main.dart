import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'signin.dart';
import 'principal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(); // Iniciar Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  AuthChecker(),
    );
  }
}
//verificar sesion iniciada
class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return StreamBuilder(
    stream:FirebaseAuth.instance.authStateChanges() , 
    builder:(context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting){
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }else {
        if(snapshot.hasData){
          //usuario ya inicio sesion
          return principal();
        }else{
          return ResUsuario();
        }
      }
    },
    );
  }
}
// union
class RegisUsuario extends StatelessWidget {
  final TextEditingController emailContro = TextEditingController();
  final TextEditingController passwordContro = TextEditingController();
  final TextEditingController confirmPasswordContro = TextEditingController();
  

//Estilos de los textos y de toda la pagina en general
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("imagenes/signup_screen.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0).add(EdgeInsets.only(top: 50.0)),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black), 
                      ),
                      child: TextFormField(
                        controller: emailContro,
                        decoration: InputDecoration(
                          hintText: 'Type your Email',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none, 
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black), 
                      ),
                      child: TextFormField(
                        controller: passwordContro,
                        decoration: InputDecoration(
                          hintText: 'Type Your Password',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none, 
                        ),
                        obscureText: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black), 
                      ),
                      child: TextFormField(
                        controller: confirmPasswordContro,
                        decoration: InputDecoration(
                          hintText: 'Retype Your Password',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none, 
                        ),
                        obscureText: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _registerWithEmailAndPassword(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                      ),
                      child: Text('Sign Up',
                      style: TextStyle(color: Colors.black,
                      fontWeight: FontWeight.bold
                      ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ResUsuario()),
                      );
                    },
                    child: Text(
                      'Already Registered, Sign In!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _registerWithEmailAndPassword(BuildContext context) async {
    // tomar el texto
    String email = emailContro.text.trim();
    String password = passwordContro.text.trim();
    String confirmPassword = confirmPasswordContro.text.trim();

    // verificar si contrase;as iguakes
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Passwords do not match.'),
        duration: Duration(seconds: 3),
      ));
      return;
    }

    try {
      // crear cuenta email y contrase;a
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResUsuario()),
      );
    } catch (e) {
      // Error creando usuario
      print('Error Registrando Usuario: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error Registrando Usuario: $e'),
        duration: Duration(seconds: 3),
      ));
    }
  }
}










