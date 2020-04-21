import 'package:cloud_firestore/cloud_firestore.dart';
class addmethods
{
  Future<void> addData(desc) async
  {
    Firestore.instance.collection('testcrud').add(desc).catchError((e){print(e);});
  }
}