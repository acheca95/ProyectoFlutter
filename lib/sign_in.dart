import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

//final databaseReference = FirebaseDatabase.instance.reference().child("correos");

String name;
String apellidos;
String email;
String imageUrl;

var correcto = false;

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  // Checking if email and name is null
  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);

  name = user.displayName;
  email = user.email;
  imageUrl = user.photoUrl;

  // Obtenemos nombre y apellidos
  if (name.contains(" ")) {
    apellidos = name.substring(name.indexOf(" ") + 1);
    name = name.substring(0, name.indexOf(" "));
  }

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

 // Future<String> getEmail() {
  //    List<String> names;
  //
  //    databaseReference.once().then((DataSnapshot snapshot) {
  //      List.from(snapshot.value);
  //      print(snapshot.value);
  //    });
  //    for (var i = 0; i < names.length; i++) {
  //      if (email == names[i]) {
  //        correcto = true;
  //      }
  //    }
  //  }
  //
  //  if (correcto == true) {
  //    return 'Login realizado correctamente: $user';
  //  } else {
  //    return 'error el usuario no tiene permisos: $user';
  //  }
}

void signOutGoogle() async {
  await googleSignIn.signOut();
  print("Se cerro la sesion.");
}
