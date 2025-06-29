import 'package:finshyt/firebase_options.dart'; //
import 'package:finshyt/Features/auth/auth_exceptions.dart';
import 'package:finshyt/Features/auth/auth_provider.dart';
import 'package:finshyt/Features/auth/auth_user.dart'; //
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException; //
import 'package:firebase_core/firebase_core.dart'; //

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == "invalid-email") {
        throw InvalidEmailAuthException();
      } else if (e.code == "weak-password") {
        throw WeakPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-credential") {
        throw InvalidCredentialsAuthException();
      } else if (e.code == "channel-error") {
        throw ChannelErrorAuthException();
      } else if (e.code == "invalid-email") {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logout() async {
    final user = currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  

  @override
  Future<void> sendEmailVerification() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await firebaseUser.sendEmailVerification(); //we need to separately use firebase user becoz this methos isn't defined for AuthUser, its just a datamodel
                                                  //whereas in other functions we are returning theAuthUser in Future<AuthUser>
    }
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'firebase_auth/invalid-email':
          throw InvalidEmailAuthException();
        case 'firebase_auth/invalid-credential':
          throw InvalidCredentialsAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }
  
  @override
  Future<void> reloadUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if(user != null){
      await user.reload();
    }
  }
}
