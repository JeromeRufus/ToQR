import 'package:campus/app_large_text.dart';
import 'package:campus/detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'package:homedesign/app_large_text.dart';

class Search_Page extends StatefulWidget {
  const Search_Page({Key? key}) : super(key: key);

  @override
  State<Search_Page> createState() => _Search_PageState();
}

final Stream<QuerySnapshot> placeStream =
    FirebaseFirestore.instance.collection('Place').snapshots();
final List storedocs = [];

TextEditingController textEditingController = TextEditingController();
String? searchString = "";

class _Search_PageState extends State<Search_Page> {
  get text => null;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  AppLargeText(
                    text: "Search",
                    //size: 25,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 380,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: TextField(
                  onChanged: (val) {
                    setState(() {
                      searchString = val.toLowerCase();
                    });
                  },
                  controller: textEditingController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          textEditingController.clear();
                        },
                      ),
                      hintText: 'Search Places...',
                      border: InputBorder.none),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: (searchString == null || searchString!.trim() == '')
                    ? FirebaseFirestore.instance.collection('Place').snapshots()
                    : FirebaseFirestore.instance
                        .collection('Place')
                        .where('searchkey', arrayContains: searchString)
                        .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("We got an error");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final List storedocs = [];
                  snapshot.data?.docs.map((DocumentSnapshot document) {
                    Map a = document.data() as Map<String, dynamic>;
                    storedocs.add(a);
                    a['id'] = document.id;
                  }).toList();
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      String name = storedocs[index]['name'];
                      return Padding(
                        padding: EdgeInsets.all(4.0),
                        child: GestureDetector(
                          onTap: (() {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    Details_page1(id: storedocs[index]['id']),
                              ),
                            );
                          }),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Stack(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            storedocs[index]['image']),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                Container(
                                  child: Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      color: Colors.white54,
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline1!
                                                    .copyWith(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 5,
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
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            /*SizedBox(
              height: 10.0,
            ),
            GridView.count(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
                primary: false,
                shrinkWrap: true,
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  Map a = document.data() as Map<String, dynamic>;
                  storedocs.add(a);
                  a['id'] = document.id;

                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    elevation: 10.0,
                    child: Container(
                      child: Center(
                        child: Text(
                          document['name'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList()),*/
          ],
        ),
      ),
    );
  }
}
