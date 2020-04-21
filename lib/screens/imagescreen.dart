import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
class imageScreen extends StatefulWidget {
  @override
  _imageScreenState createState() => _imageScreenState();
}

class _imageScreenState extends State<imageScreen> {

  File SampleImage;
  String url;
  Future getImage() async {
    var temp =  await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      SampleImage = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
        centerTitle: true,
      ),
      body: Center
        (
        child: SampleImage==null?Text('Select an Image'):_enableUpload()

         ),
        floatingActionButton: FloatingActionButton(
          onPressed: getImage,
        tooltip:'Add Image',
          child: Icon(Icons.add),
    ),
    );
  }
  Widget _enableUpload()
  {
    return Column(
      children: <Widget>[
        Image.file(SampleImage,height: 300,width: 200,),
        RaisedButton(
          child: Text('Upload'),
          onPressed: ()
          {
            uploadimg();

          },
        )

      ],
    );
  }
  void uploadimg () async
  {
    final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('postimages');
    var timekey = DateTime.now();
    final StorageUploadTask task = firebaseStorageRef.child(timekey.toString()+".jpg").putFile(SampleImage);
    var imgUrl = await (await task.onComplete).ref.getDownloadURL();
    url = imgUrl.toString();
    savetodb(url);
  }

  void savetodb(url)
  {
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('MMM d,yyyy');
    var formatTime = DateFormat('EEEE,hh:mm aaa');
    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);
    CollectionReference ref = Firestore.instance.collection("imagedata");

    var data =
    {
    "image": url,
      "date":date,
      "time":time
    };
    ref.add(data).catchError((e){print(e);});
  }

}
