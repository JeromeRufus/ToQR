import 'package:campus/FeedBack/FeedBackForm.dart';
import 'package:campus/Scan.dart';
import 'package:campus/app_large_text.dart';
import 'package:campus/detail_page.dart';
import 'package:campus/feedback_page.dart';
import 'package:campus/navigationbar/Direction.dart';
import 'package:campus/navigationbar/direction_page.dart';
import 'package:campus/navigationbar/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'Admin/LoginPage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyHomePage extends StatefulWidget {
  //const MyHomePage({Key? key, required this.title}) : super(key: key);

  // final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Stream<QuerySnapshot> placeStream =
      FirebaseFirestore.instance.collection('Place').snapshots();

  int _current = 0;

  final CarouselController _controller = CarouselController();
  final List<String> imgList = [
    'https://www.sjctni.edu/img/slider/T1/1_12012022.jpg',
    'https://www.sjctni.edu/img/slider/T1/8.jpg',
    'https://www.sjctni.edu/img/slider/T1/5_03032022.jpg',
    'https://www.sjctni.edu/img/slider/T1/2_03032022.jpg'
  ];

  @override
  void initState() {
    super.initState();
  }

  List data = [
    {"color": Color(0xffff6968)},
    {"color": Color(0xff7a54ff)},
    {"color": Color(0xffff8f61)},
    {"color": Color(0xff2ac3ff)},
    {"color": Color(0xff5a65ff)},
    {"color": Color(0xff96da45)},
    {"color": Color(0xffff6968)},
    {"color": Color(0xff7a54ff)},
    {"color": Color(0xffff8f61)},
    {"color": Color(0xff2ac3ff)},
    {"color": Color(0xff5a65ff)},
    {"color": Color(0xff96da45)},
  ];

  String greetingMessage() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  void SelectedItem(BuildContext context, item) {
    Navigator.of(context).pop();
    switch (item) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: ((context) => LoginPage())));
        break;
      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: ((context) => Search_Page())));
        break;
      case 2:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: ((context) => FeedbackForm())));
        break;
    }
  }

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final padding = EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 19.0,
            ),
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  Divider(
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            // const DrawerHeader(
            //   child: Text(
            //     'Virtual Tour',
            //     style: TextStyle(
            //       color: Colors.black,
            //       fontSize: 20.0,
            //     ),
            //   ),
            //   decoration: BoxDecoration(
            //     //color: Colors.blue,
            //     image: DecorationImage(
            //         image: AssetImage("assets/images/virtual2.png"),
            //         fit: BoxFit.cover),
            //   ),
            // ),
            createDrawerHeader(),
            SizedBox(
              height: 24,
            ),
            buildMenuItem(
              text: 'Admin',
              icon: Icons.account_circle,
              onClicked: () => SelectedItem(context, 0),
            ),
            buildMenuItem(
              text: 'Search',
              icon: Icons.search,
              onClicked: () => SelectedItem(context, 1),
            ),
            buildMenuItem(
              text: 'FeedBack',
              icon: Icons.feedback_rounded,
              onClicked: () => SelectedItem(context, 2),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10, left: 15),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[400],
                      child: IconButton(
                        onPressed: () => _globalKey.currentState!.openDrawer(),
                        icon: Icon(Icons.menu_rounded),
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    AppLargeText(
                      text: greetingMessage(),
                      //size: 25,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                CarouselSlider(
                  options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 2.0,
                      viewportFraction: 1,
                      enlargeCenterPage: true,
                      onPageChanged: (index, carouselReason) {
                        print(index);
                        setState(() {
                          _current = index;
                        });
                      }),
                  items: imgList
                      .map(
                        (item) => Container(
                          child: Container(
                            margin: EdgeInsets.all(5.0),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              child: Stack(
                                children: <Widget>[
                                  Image.network(
                                    item,
                                    fit: BoxFit.fill,
                                    width: 800.0,
                                    height: 400,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgList.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                (Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black)
                                    .withOpacity(
                                        _current == entry.key ? 0.9 : 0.4)),
                      ),
                    );
                  }).toList(),
                ),
              ]),
              Container(
                padding: const EdgeInsets.only(top: 5, left: 20, right: 10),
                child: Row(
                  children: [
                    Text(
                      "Places",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    Expanded(child: Container()),
                    // Text("See more",style: TextStyle(fontSize: 19,color: Colors.blue),),
                    //Icon(Icons.arrow_forward,size: 19,color: Colors.blue,),

                    IconButton(
                        icon: Icon(Icons.arrow_forward),
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Search_Page()));
                        }),
                  ],
                ),
              ),
              Container(
                child: _buildListview(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        child: Icon(Icons.qr_code_scanner_rounded, color: Colors.white),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Scanner(),
            ),
          );
        },
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.black87;
    final hoverColor = Colors.blueGrey;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  Widget createDrawerHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/virtual2.png'),
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 12.0,
            left: 16.0,
            child: Text(
              "Welcome to Sjc campus",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListview() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: placeStream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              print("Something went wrong");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final List storedocs = [];
            snapshot.data!.docs.map((DocumentSnapshot document) {
              Map a = document.data() as Map<String, dynamic>;
              storedocs.add(a);
              a['id'] = document.id;
            }).toList();
            return Container(
              padding: EdgeInsets.only(left: 20),
              height: 300,
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: ((context, index) {
                  String name = storedocs[index]['name'];
                  String imageUrl = storedocs[index]['image'];
                  //print(imageUrl);
                  return Container(
                    margin: EdgeInsets.only(right: 15, top: 10),
                    width: 200,
                    height: 300,
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
                                    image:
                                        NetworkImage(storedocs[index]['image']),
                                    fit: BoxFit.fill),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                color: Colors.white54,
                                padding: EdgeInsets.all(5.0),
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
                                                  fontWeight: FontWeight.bold),
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
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
    );
  }

  Widget _listGrid() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: placeStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final List storedocs = [];
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            storedocs.add(a);
            a['id'] = document.id;
          }).toList();
          return Container(
            padding: EdgeInsets.only(left: 20),
            height: 300,
            width: double.maxFinite,
            child: ListView.separated(
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        Details_page1(id: storedocs[index]['id']),
                  ));
                },
                child: Container(
                  width: 230,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(storedocs[index]['image']),
                                fit: BoxFit.cover)),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          //color: Colors.white54,
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    storedocs[index]['name'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
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
                    ],
                  ),
                ),
              ),
              separatorBuilder: (_, index) => SizedBox(
                width: 20,
              ),
              itemCount: snapshot.data!.docs.length,
            ),
          );
        },
      ),
    );
  }
}
