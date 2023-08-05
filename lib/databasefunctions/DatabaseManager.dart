import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {
  Future getDocIds() async {
    List docIds = [];
    // this will bring main collection
    //await FirebaseFirestore.instance.collection("Students");
    // now move into student reocrds individually
    await FirebaseFirestore.instance.collection("Students").get().then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              print(document.reference);
              docIds.add(document.reference.id);
            },
          ),
        );
    return docIds;
  }
}
