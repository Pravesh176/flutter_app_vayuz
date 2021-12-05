import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_vayuz/screens/secondscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {

   Map data;
   String imgurl1 = "";


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
          prefs.setString("imgurl1", data['message']);
          imgurl1=data['message'];
          print("internet available");
        });
      } else {
        // I am connected to a any network.
        setState(() {
          imgurl1 = prefs.getString("imgurl1");
          print("internet not available");
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("First Screen"),
        ),
        body: Center(
           child: Container(
             height: 350,
             width: 150,
             child: imgurl1!=""?Image.network(imgurl1):Image.network("https://images.dog.ceo/breeds/germanshepherd/n02106662_12906.jpg"),
           ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondScreen()),
            );

          },
          child: const Icon(Icons.navigation),
          backgroundColor: Colors.blue,
        ),
    );
  }

}
