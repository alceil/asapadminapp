import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:asapadminapp/services/crudmethods.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  addmethods addObj = addmethods();
  File SampleImage;
  String dept;
  String instructor;
  String subject;
  String topic;
  String mno;
  String sno;
  String url;
  Future<bool> dialogTrigger(BuildContext context) async
  {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {
          return AlertDialog(
            title:Text('Job done',style: TextStyle(fontSize: 15.0),) ,
            content: Text('Added'),
            actions: <Widget>
            [
              FlatButton(
                child: Text('Alright'),
                textColor: Colors.blue,
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }
  Future getImage() async{
    var temp = await ImagePicker.pickImage(source:ImageSource.gallery);
    setState(() {
      SampleImage = temp;
    });
    uploadimg();
  }
  void uploadimg() async
  {
    final StorageReference StorageRef = FirebaseStorage.instance.ref().child('Classimgs');
    var timekey =DateTime.now();
    final StorageUploadTask task = StorageRef.child(timekey.toString()+".jpg").putFile(SampleImage);
    var imgurl = await (await task.onComplete).ref.getDownloadURL();
    url = imgurl.toString();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin app'),
        centerTitle: true,
      ),
      body:ListView(
        children: <Widget>
        [
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>
              [
                Container(
                  height: 300,
                  width: 200,
                  color: Colors.grey,
                  child:SampleImage==null?Center(child: Text('Select an Image')):Image.file(SampleImage,height: 300,width: 200,),
                ),
                SizedBox(height: 5.0,),
                FlatButton(
                  color: Colors.green,
                  child: Text('choose an image'),
                  onPressed: () async {
                    getImage();
                  },
                ),
                TextField(
                  decoration: InputDecoration(
                      hintText:'Enter department'
                  ),
                  onChanged: (value)
                  {
                    this.dept = value;
                  },
                ),
                SizedBox(height: 5.0,),
                TextField(
                  decoration: InputDecoration(
                      hintText:'instructor name'
                  ),
                  onChanged: (value)
                  {
                    this.instructor = value;
                  },
                ),
                SizedBox(height: 5.0,),
                TextField(
                  decoration: InputDecoration(
                      hintText:'Module no'
                  ),
                  onChanged: (value)
                  {
                    this.mno = value;
                  },
                ),
                SizedBox(height: 5.0,),
                TextField(
                  decoration: InputDecoration(
                      hintText:'Semister'
                  ),
                  onChanged: (value)
                  {
                    this.sno = value;

                  },
                ),
                SizedBox(height: 5.0,),
                TextField(
                  decoration: InputDecoration(
                      hintText:'Subject'
                  ),
                  onChanged: (value)
                  {
                    this.subject = value;

                  },
                ),
                SizedBox(height: 5.0,),
                TextField(
                  decoration: InputDecoration(
                      hintText:'Topic'
                  ),
                  onChanged: (value)
                  {
                    this.topic = value;
                  },
                ),
                SizedBox(height: 5.0,),
                FlatButton(
                  color: Colors.green,
                  onPressed: ()
                  {
                    addObj.addData(
                        { 'imgurl':this.url,
                          'dept':this.dept,
                          'instructor':this.instructor,
                          'mno':this.mno,
                          'sno':this.sno,
                          'subject':this.subject,
                          'topic':this.topic}).then((result) {dialogTrigger(context);});
                  },
                  child:Text('Upload data') ,
                )
              ],
            ),
          ),

        ],
      )
      );
  }
}
