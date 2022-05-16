// import 'package:campus/app_large_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'app_large_text.dart';

class Details_page1 extends StatefulWidget {
  final String id;
  const Details_page1({Key? key, required this.id}) : super(key: key);

  @override
  State<Details_page1> createState() => _Details_page1State();
}

CollectionReference place = FirebaseFirestore.instance.collection('Place');
late String firstHalf;
late String secondHalf;
bool hiddenText = true;

Future<void> dataPlace(
  id,
  Name,
  description,
) {
  return place
      .doc(id)
      .update({
        'name': Name,
        'description': description,
      })
      .then((value) => print("User Updated"))
      .catchError((error) => print("Failed to update user: $error"));
}

class _Details_page1State extends State<Details_page1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('Place')
              .doc(widget.id)
              .get(),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              print('Something Went Wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            var data = snapshot.data!.data();
            var Name = data!['name'];
            var description = data['description'];
            var imageUrl = data['image'];

            return Container(
              child: Stack(
                children: [
                  //Positioned(
                  //left: 0,
                  //right: 0,
                  Container(
                    width: double.maxFinite,
                    height: 350,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(imageUrl), fit: BoxFit.fill),
                    ),
                  ),
                  //),
                  Positioned(
                    left: 20,
                    top: 50,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white70,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back),
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 320,
                    child: Container(
                      padding:
                          EdgeInsets.only(left: 20.0, right: 20.0, top: 30),
                      width: MediaQuery.of(context).size.width,
                      height: 450,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15.0),
                          topLeft: Radius.circular(15.0),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Align(
                              child: Container(
                                width: 150,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppLargeText(
                                  text: Name,
                                  color: Colors.black54.withOpacity(0.8),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                AppLargeText(
                                  text: "About Us ",
                                  color: Colors.black.withOpacity(0.8),
                                  size: 20,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Column(
                              children: [
                                Text(
                                  description,
                                  style: TextStyle(
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
