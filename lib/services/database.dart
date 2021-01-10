import 'package:brew_crew_firebase/models/brew.dart';
import 'package:brew_crew_firebase/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // user uid reference
  final String uid;

  DatabaseService({this.uid});

  // collection reference
  final CollectionReference brewCollection =
      Firestore.instance.collection('brews');

  // update user data on db
  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.document(uid).setData({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  // brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents
        .map((doc) => Brew(
            name: doc.data['name'] ?? '',
            sugars: doc.data['sugars'] ?? '0',
            strength: doc.data['strength'] ?? 0))
        .toList();
  }

  // get bews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  // userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      sugars: snapshot.data['sugars'],
      strength: snapshot.data['strength'],
    );
  }

  // get user doc stream
  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}
