import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';

File? _imageFile=null;
File? _imageFile2=null;
UploadTask? uploadTask;

final _picker = ImagePicker();
final _picker2 = ImagePicker();
final controller = TextEditingController();
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MediaQuery(
      data: MediaQueryData(
        size: Size(800, 600),
        textScaleFactor: 1.0,
        devicePixelRatio: 1.0,
      ),
      child: MaterialApp(
        home: HomePage(),
      ),
    ),
  );
}
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text("OMR EVALUATOR"),
        backgroundColor: Colors.black45,
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.only(left: 20,right: 20,top: 30,bottom: 30),
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ImagePickerExample()));
              },
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                elevation: 8.0,
                child: Container(
                  width: 300.0,
                  height: 200.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(
                      image: AssetImage("assets/image1.jpg"),
                      fit: BoxFit.cover,
                    ),),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '             ANSWER KEY',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 27.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        '              Uplode your\n              answer key here',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ImagePickerExample2()));
              },
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                elevation: 8.0,
                child: Container(
                  width: 300.0,
                  height: 200.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(
                      image: AssetImage("assets/image2.jpg"),
                      fit: BoxFit.cover,
                    ),),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'ANSWER SCRIPT',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 27.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'Uplode your answer script here',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            Container(
                margin: const EdgeInsets.only(left: 45.0, right: 45.0,top: 0),
                height: 40,
                width: 250,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                    boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))]
                ),
                child: Builder(
                  builder: (BuildContext context) {
                    return ElevatedButton(
                      onPressed: () {
                        uploadFile();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("File(s) UPLOADING"),
                            )
                        );
                        Navigator.push(context, MaterialPageRoute(builder: (context) => uploder()));
                      },
                      child: Text('UPLOAD',
                        style: TextStyle(color: Colors.black87,
                          fontFamily: 'RobotoMono',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    );
                  },
                )

            ),
            SizedBox(height: 50),
            Container(
              margin: const EdgeInsets.only(left: 45.0, right: 45.0,top: 0),
              height: 40,
              width: 250,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                  boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))]
              ),
              child: ElevatedButton(
                onPressed: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => uploder()));
                },
                child: Text('PROCESS',
                  style: TextStyle(color: Colors.black87,
                    fontFamily: 'RobotoMono',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),

            ),
            SizedBox(height: 50),
            Container(
              margin: const EdgeInsets.only(left: 45.0, right: 45.0,top: 0),
              height: 40,
              width: 250,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                  boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))]
              ),
              child: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () {
                      uploadFile();
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("LOADING MARKS FROM DATABASE"),
                          )
                      );
                      getDataFromFirestore().then((mark) => Navigator.push(context, MaterialPageRoute(builder: (context) => ResultsTable(finalMarks: mark,))));
                    },
                    child: Text('VIEW MARKS',
                      style: TextStyle(color: Colors.black87,
                        fontFamily: 'RobotoMono',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 50),
            Container(
              margin: const EdgeInsets.only(left: 45.0, right: 45.0,top: 0),
              height: 40,
              width: 250,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                  boxShadow: [BoxShadow(blurRadius: 10,color: Colors.black,offset: Offset(1,3))]
              ),
              child: ElevatedButton(
                onPressed: ()
                {
                  createUser(name: false,name2: "NULL",name3: "NULL");
                },
                child: Text('RESET',
                  style: TextStyle(color: Colors.black87,
                    fontFamily: 'RobotoMono',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),

            ),
          ],
        ),
      ),
    );
  }

  Future createUser({required bool name,required String name2,required String name3,}) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc("74110");

    final json ={
      'BOOL' : name,
      'image1' : name2,
      'image2' : name3,
    };


    await docUser.set(json);
  }

  Future uploadFile() async {

    if(_imageFile != null && _imageFile2 != null) {

      final path = 'files/image1';
      final file = File(_imageFile!.path!);

      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);
      final snapshot = await uploadTask!.whenComplete(() {});

      final urlDownload = await snapshot.ref.getDownloadURL();

      final path2 = 'files/image2';
      final file2 = File(_imageFile2!.path!);

      final ref2 = FirebaseStorage.instance.ref().child(path2);
      uploadTask = ref2.putFile(file2);
      final snapshot2 = await uploadTask!.whenComplete(() {});

      final urlDownload2 = await snapshot2.ref.getDownloadURL();
      createUser(name: true,name2: "$urlDownload",name3: "$urlDownload2",);


    }

  }


  Future<int>  getDataFromFirestore() async {
    var documentReference = FirebaseFirestore.instance
        .collection("scores")
        .doc("84536");
    var doc = await documentReference.get();
    Map<String, dynamic>? myDictionary =doc.data();
    print(myDictionary!['marks']);
    int integer = myDictionary!['marks'].toInt();
    return integer;
  }


}

class ImagePickerExample extends StatefulWidget {
  const ImagePickerExample({super.key});

  @override
  _ImagePickerExampleState createState() => _ImagePickerExampleState();
}
class _ImagePickerExampleState extends State<ImagePickerExample> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text("OMR EVALUATOR"),
        backgroundColor: Colors.black45,
      ),
      body: ListView(
        children: <Widget>[
          ButtonBar(
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.photo_camera),
                onPressed: () async {
                  _pickImageFromCamera();
                } ,
                tooltip: 'Shoot picture',
              ),
              IconButton(
                icon: const Icon(Icons.photo),
                onPressed: () async {
                  _pickImageFromGallery();
                },
                tooltip: 'Pick from gallery',
              ),
            ],
          ),
          if (_imageFile == null)
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 175,
                    top: 65,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              ),
            )
          else
            Container(
              height: 600,
              padding: EdgeInsets.all(16.0),
              child: Image.file(_imageFile!),),
          GestureDetector(
              onTap: () async => _pickImageFromCamera(),
              child: Container(
                  height: 70,
                  width: 60,
                  padding: EdgeInsets.only(bottom: 5.0,top: 20, left: 100,right: 100),
                  alignment: AlignmentDirectional.center,
                  child:Container(
                    alignment: AlignmentDirectional.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white30,Colors.black54,Colors.white30],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "RETAKE",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ))
          ),
        ],
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }
}

class ImagePickerExample2 extends StatefulWidget {
  const ImagePickerExample2({super.key});

  @override
  _ImagePickerExampleState2 createState() => _ImagePickerExampleState2();
}
class _ImagePickerExampleState2 extends State<ImagePickerExample2> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text("OMR EVALUATOR"),
        backgroundColor: Colors.black45,
      ),
      body: ListView(
      children: <Widget>[
        ButtonBar(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.photo_camera),
              onPressed: () async => _pickImageFromCamera(),
              tooltip: 'Shoot picture',
            ),
            IconButton(
              icon: const Icon(Icons.photo),
              onPressed: () async => _pickImageFromGallery(),
              tooltip: 'Pick from gallery',
            ),
          ],
        ),
        if (_imageFile2 == null)
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 175,
                  top: 65,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              ],
            ),
          )
        else
          Container(
            height: 600,
            padding: EdgeInsets.all(16.0),
            child: Image.file(_imageFile2!),),
        GestureDetector(
            onTap: () async => _pickImageFromCamera(),
            child: Container(
                height: 70,
                width: 60,
                padding: EdgeInsets.only(bottom: 5.0,top: 20, left: 100,right: 100),
                alignment: AlignmentDirectional.center,
                child:Container(
                  alignment: AlignmentDirectional.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white30,Colors.black54,Colors.white30],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "RETAKE",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ))
        ),
      ],
    ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker2.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile2 = File(pickedFile.path));
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker2.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => _imageFile2 = File(pickedFile.path));
    }
  }
}

class uploder extends StatefulWidget {
  const uploder({super.key});

  @override
  uploderState2 createState() => uploderState2();
}
class uploderState2 extends State<uploder> {

  @override
  var disp = Container(
    height: 70,
      width: 60,
      padding: EdgeInsets.only(bottom: 5.0,top: 20, left: 100,right: 100),
      alignment: AlignmentDirectional.center,
    child:Container(
    alignment: AlignmentDirectional.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white30,Colors.black54,Colors.white30],
      ),
    ),
    child: Center(
      child: Text(
        "key",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    ),
  ));
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text("OMR RECOGNISATION"),
        backgroundColor: Colors.black45,
      ),
      body: ListView(
        children: <Widget>[
          disp,
          if (_imageFile == null)
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 175,
                    top: 65,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              ),
            )
          else
            Container(
              height: 600,
              padding: EdgeInsets.only(bottom: 20.0,top: 5),
              child: Image.file(_imageFile!),),
          disp,
          if (_imageFile2 == null)
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 175,
                    top: 65,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              ),
            )
          else
            Container(
              height: 600,
              padding: EdgeInsets.only(bottom: 20.0,top: 5,left: 0,right: 0),
              child: Image.file(_imageFile2!),),
        ],
      ),
    );
  }

}


class ResultsTable extends StatelessWidget {
  final int totalQuestions =5;

    int finalMarks=0 ;

  ResultsTable({
    required this.finalMarks,
  });
  final int wrongAnswers =7;
  @override
  Widget build(BuildContext context) {
    double k=(finalMarks/20);
    double l=5-k;
    double j=k*4-l;
    return Scaffold(
      backgroundColor: Colors.deepOrange[900],
        appBar: AppBar(
        title: Text("OMR EVALUATOR"),
    backgroundColor: Colors.black45,
    ),
      body: Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 5),
              blurRadius: 10,
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(20),
        child: Table(
          defaultColumnWidth: FlexColumnWidth(1.0),
          children: [
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Total Questions', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('$totalQuestions', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Correct Answers', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('$k', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Wrong Answers', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('$l', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ]),
            TableRow(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Final Marks', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('$j', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ]),
          ],
        ),
      ),
    ),
    );
  }
}
