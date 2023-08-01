import 'package:firebase_auth/firebase_auth.dart';

class Authenticate {
  final FirebaseAuth auth;

  Authenticate({required this.auth});

  Stream<User?> get user => auth.authStateChanges();

  Future<String?> createAccount(
      {required String email, required String password}) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> signIn(
      {required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> signOut() async {
    try {
      await auth.signOut();
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }
  Future resetPassword({ required String email})async{
    try{
      await auth.sendPasswordResetEmail(email: email);
      return "Success";


    }on FirebaseAuthException catch(e){
      return e.message;
    }catch(e){
      rethrow;
    }
  }
}