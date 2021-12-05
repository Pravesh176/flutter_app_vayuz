import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_vayuz/screens/firstscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {

  Map data;
  String imgurl2 = "";

  @override
  void initState() {
    initPlatformState();
    // TODO: implement initState
    super.initState();
  }

  void initPlatformState() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var connectivityResult = await (Connectivity().checkConnectivity());

      if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a mobile or wifi network.
        Response response;
        Dio dio = new Dio();
        response = await dio.get('https://dog.ceo/api/breeds/image/random');
        setState(() {
          data = response.data;
          prefs.setString("imgurl2", data['message']);
          imgurl2=data['message'];
          print("internet available");
        });
      } else {
        // I am connected to a any network.
        setState(() {
          imgurl2 = prefs.getString("imgurl2");
          print("internet not available");
        });
      }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Second Screen"),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                FirstScreen()), (Route<dynamic> route) => false);
          },
          child:const Icon(
            Icons.arrow_back,  // add custom icons also
          ),
        ),
      ),
      body: Center(
        child: Container(
          height: 350,
          width: 150,
          child: imgurl2!=""?Image.network(imgurl2):Image.network("https://images.dog.ceo/breeds/germanshepherd/n02106662_12906.jpg"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!

        },
        child: const Icon(Icons.navigation),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
