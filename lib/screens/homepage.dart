import 'package:ecommerce_app/model/categoryicon.dart';
import 'package:ecommerce_app/model/usermodel.dart';
import 'package:ecommerce_app/provider/category_provider.dart';
import 'package:ecommerce_app/provider/product_provider.dart';
import 'package:ecommerce_app/screens/aboutus.dart';
import 'package:ecommerce_app/screens/cartscreen.dart';
import 'package:ecommerce_app/screens/contactus.dart';
import 'package:ecommerce_app/screens/detailscreen.dart';
import 'package:ecommerce_app/screens/listproduct.dart';
import 'package:ecommerce_app/screens/login.dart';
import 'package:ecommerce_app/screens/profilescreen.dart';
import 'package:ecommerce_app/screens/singleproduct.dart';
import 'package:ecommerce_app/widget/notification_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../model/product.dart';
import 'favouritescreen.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

late Product menData;
late Product monitorData;
double height = 0.0;
var featuredsnapshot;
var newarchivessnapshot;
var shirtSnapshot;
late CategoryProvider categoryprovider;
late ProductProvider productprovider;

class _HomepageState extends State<Homepage> {
  bool homeColor = true;
  bool cartColor = false;
  bool aboutColor = false;
  bool profileColor = false;
  bool contactColor = false;
  bool favColor = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  User? user;
  Widget _buildUserAccountsDrawerHeader() {
    if (user != null) {
      List<UserModel> userModel = productprovider.getUserModelList;
      return Column(
          children: userModel.map((e) {
        return UserAccountsDrawerHeader(
          decoration: BoxDecoration(color: Colors.indigo),
          accountName: Text(
            e.UserName,
            style: TextStyle(fontSize: 20),
          ),
          currentAccountPicture: CircleAvatar(
            child: ClipOval(
              child: e.UserImage == ""
                  ? Image.asset("assets/UserImage.png")
                  : Image.network(
                      "${e.UserImage}",
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                    ),
            ),
          ),
          accountEmail: Text(
            e.UserEmail,
            style: TextStyle(fontSize: 17),
          ),
        );
      }).toList());
    } else {
      return Container(
        height: MediaQuery.of(context).size.height * 0.2,
        color: Colors.indigo,
        child: UserAccountsDrawerHeader(
          decoration: BoxDecoration(color: Colors.indigo),
          accountName: MaterialButton(
            child: Text(
              "Sign In",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => login(),
                ),
              );
            },
          ),
          currentAccountPicture: CircleAvatar(
            child: ClipOval(child: Image.asset("assets/UserImage.png")),
          ),
          accountEmail: null,
        ),
      );
    }
  }

  Widget buildMyDrawer() {
    return Drawer(
      child: ListView(
        children: [
          _buildUserAccountsDrawerHeader(),
          ListTile(
            selected: homeColor,
            onTap: () {
              setState(() {
                homeColor = true;
                cartColor = false;
                aboutColor = false;
                profileColor = false;

                contactColor = false;
                favColor = false;
              });
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Homepage(),
                ),
              );
            },
            leading: Icon(
              Icons.home,
              size: 35,
            ),
            title: Text(
              "Home",
              style: TextStyle(fontSize: 17),
            ),
          ),
          ListTile(
            selected: profileColor,
            onTap: () {
              setState(() {
                homeColor = false;
                cartColor = false;
                aboutColor = false;
                profileColor = true;
                contactColor = false;
                favColor = false;
              });
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                ),
              );
            },
            leading: Icon(
              Icons.person,
              size: 35,
            ),
            title: Text(
              "Profile",
              style: TextStyle(fontSize: 17),
            ),
          ),
          ListTile(
            selected: cartColor,
            onTap: () {
              setState(() {
                homeColor = false;
                cartColor = true;
                aboutColor = false;
                profileColor = false;
                favColor = false;
                contactColor = false;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => CartScreen(),
                  ),
                );
              });
            },
            leading: Icon(
              Icons.shopping_cart,
              size: 35,
            ),
            title: Text(
              "Cart",
              style: TextStyle(fontSize: 17),
            ),
          ),
          ListTile(
            selected: cartColor,
            onTap: () {
              setState(() {
                homeColor = false;
                cartColor = false;
                aboutColor = false;
                profileColor = false;
                favColor = true;
                contactColor = false;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => FavouriteScreen(),
                  ),
                );
              });
            },
            leading: Icon(
              Icons.favorite,
              size: 35,
            ),
            title: Text(
              "Favourites",
              style: TextStyle(fontSize: 17),
            ),
          ),
          ListTile(
            selected: aboutColor,
            onTap: () {
              setState(() {
                homeColor = false;
                cartColor = false;
                aboutColor = true;
                profileColor = false;
                favColor = false;
                contactColor = false;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => AboutUs(),
                  ),
                );
              });
            },
            leading: Icon(
              Icons.info,
              size: 35,
            ),
            title: Text(
              "About",
              style: TextStyle(fontSize: 17),
            ),
          ),
          ListTile(
            selected: contactColor,
            onTap: () {
              setState(() {
                homeColor = false;
                cartColor = false;
                aboutColor = false;
                profileColor = false;
                contactColor = true;
                favColor = false;
              });
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => Contactus(),
                ),
              );
            },
            leading: Icon(
              Icons.phone,
              size: 35,
            ),
            title: Text(
              "Contact Us",
              style: TextStyle(fontSize: 17),
            ),
          ),
          ListTile(
            enabled: true,
            onTap: () {
              if (user != null) {
                FirebaseAuth.instance.signOut();
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(
                //     builder: (context) => login(),
                //   ),
                // );
              }
            },
            leading: Icon(
              Icons.exit_to_app,
              size: 35,
            ),
            title: Text(
              "Log Out",
              style: TextStyle(fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategory() {
    List<Product> pants = categoryprovider.getPantList();
    List<Product> shirts = categoryprovider.getShirtList();
    List<Product> dresses = categoryprovider.getDressList();
    List<Product> shoes = categoryprovider.getShoeList();
    List<Product> tv = categoryprovider.getTieList();
    List<CategoryIcon> categoryIcon = categoryprovider.getCategoryIconList();
    List category = [
      dresses,
      pants,
      tv,
      shoes,
      shirts,
    ];

    List colors = [
      0xff33dcfd,
      0xfff38cdd,
      0xff4ff2af,
      0xff74acf7,
      0xfffc6c8d,
    ];

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          height: 40,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Categories",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            scrollDirection: Axis.horizontal,
            children: List.generate(
              categoryIcon.length,
              (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => ListProduct(
                          isCategory: true,
                          name: "${categoryIcon[index].name}",
                          snapshot: category[index],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    // color: Colors.green,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: CircleAvatar(
                            backgroundColor: Color(colors[index]),
                            maxRadius: height * 0.1 / 2.1,
                            child: Container(
                              height: 40,
                              width: double.infinity,
                              child: Image(
                                color: Colors.white,
                                image: NetworkImage(
                                  "${categoryIcon[index].image}",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            //
          ),
        ),
      ],
    );
  }

  Widget buildFeature() {
    List<Product> features = productprovider.getFeatureList();
    List<Product> homeFeatures = productprovider.getHomeFeatureList();

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          height: 40,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Featured",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ListProduct(
                        isCategory: false,
                        name: 'Featured',
                        snapshot: features,
                      ),
                    ),
                  );
                },
                child: Text(
                  "View All",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 180,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.purple, Colors.blue])),
          child: Container(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              scrollDirection: Axis.horizontal,
              itemCount: homeFeatures.length,
              itemBuilder: (context, int index) => Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 15),
                      width: 140,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                            offset: Offset(
                                1.0, 1.0), // shadow direction: bottom right
                          )
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => DetailScreen(
                                image: homeFeatures[index].image,
                                name: homeFeatures[index].name,
                                price: homeFeatures[index].price,
                                description: homeFeatures[index].description,
                                isColor: false,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  topLeft: Radius.circular(15),
                                ),
                              ),
                              width: double.infinity,
                              height: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                ),
                                child: Image(
                                  image:
                                      NetworkImage(homeFeatures[index].image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "${homeFeatures[index].name}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Rs. ${homeFeatures[index].price}",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildNewArchives() {
    List<Product> newarchives = productprovider.getNewarchivesList();
    List<Product> homeNewarchives = productprovider.getHomeNewarchivesList();

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          height: 40,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "New Archives",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ListProduct(
                        isCategory: false,
                        name: "New Archives",
                        snapshot: newarchives,
                      ),
                    ),
                  );
                },
                child: Text(
                  "View All",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
          child: GridView.count(
            crossAxisCount: 2,
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 10,
            shrinkWrap: true,
            childAspectRatio: 0.95,
            children: List.generate(
              homeNewarchives.length,
              (index) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => DetailScreen(
                            image: homeNewarchives[index].image,
                            name: homeNewarchives[index].name,
                            price: homeNewarchives[index].price,
                            description: homeNewarchives[index].description,
                            isColor: false,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(),
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.14,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                              ),
                              child: Image(
                                image:
                                    NetworkImage(homeNewarchives[index].image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.08,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "${homeNewarchives[index].name}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Rs. ${homeNewarchives[index].price}",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  var slider = [
    {
      "name": " iphone14",
      "image":
          "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-12-finish-select-202207-product-red?wid=2560&hei=1440&fmt=jpeg&qlt=95&.v=1662150081176",
      "price": 399.99
    },
    {
      "name": "apple watch",
      "image":
          "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MQE23ref_VW_34FR+watch-49-titanium-ultra_VW_34FR_WF_CO+watch-face-49-alpine-ultra_VW_34FR_WF_CO_GEO_IN?wid=750&hei=712&trim=1%2C0&fmt=p-jpg&qlt=95&.v=1660713657930%2C1660927566964%2C1661371890735",
      "price": 899.99
    },
    {
      "name": "headphones",
      "image":
          "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/airpods-max-select-pink-202011_FV1_FMT_WHH?wid=940&hei=800&fmt=jpeg&qlt=90&.v=1604776024000",
      "price": 488.1
    },
    {
      "name": "airpods",
      "image":
          "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/MME73?wid=890&hei=890&fmt=jpeg&qlt=90&.v=1632861342000",
      "price": 50.49
    },
    {
      "name": "MacBook",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhVMJIzAYNAi14IwmV1fTT4076gmjTLQw_0N8qx_Y7jxCzU1U2rgUi2RAh&s=10",
      "price": 399.99
    },
  ];

  late String name, image;
  late double price;
  @override
  Widget build(BuildContext context) {
    categoryprovider = Provider.of<CategoryProvider>(context);
    categoryprovider.getPantData();
    categoryprovider.getShirtData();
    categoryprovider.getDressData();
    categoryprovider.getShoeData();
    categoryprovider.getTieData();
    categoryprovider.getCategoryIconData();

    productprovider = Provider.of<ProductProvider>(context, listen: true);
    productprovider.getFeatureData();
    productprovider.getNewarchivesData();
    productprovider.getHomeFeatureData();
    productprovider.getHomeNewarchivesData();

    height = MediaQuery.of(context).size.height;
    print("This is Max Radius${height * 0.1 / 2.1}");
    try {
      user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        productprovider.getUserData();
      }
    } catch (e) {
      print("No User Logged In");
    }
    return Scaffold(
      key: _key,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _key.currentState!.openDrawer();
          },
          icon: Icon(Icons.menu),
        ),
        title: Text("HI-TECH"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              List<Product> features = productprovider.getFeatureList();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ListProduct(
                    isCategory: false,
                    name: 'Featured',
                    snapshot: features,
                  ),
                ),
              );
            },
          ),
          NotificationButton(),
        ],
      ),
      drawer: buildMyDrawer(),

      //

      body: SafeArea(
        child: Container(
          color: Colors.grey[290],
          height: double.infinity,
          width: double.infinity,
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                // color: Colors.green,
                child: CarouselSlider.builder(
                    itemCount: slider.length,
                    options: CarouselOptions(
                      height: 200.0,
                      enlargeCenterPage: true,
                      viewportFraction: 1.05,
                      autoPlay: true,
                    ),
                    itemBuilder: (BuildContext context, int itemIndex,
                        int pageViewIndex) {
                      name = slider[itemIndex]["name"].toString();
                      image = slider[itemIndex]["image"].toString();
                      price = slider[itemIndex]["price"] as double;
                      return Container(
                        child: SingleProduct(
                          name: slider[itemIndex]["name"].toString(),
                          image: "${slider[itemIndex]["image"].toString()}",
                          price: slider[itemIndex]["price"] as double,
                          description:
                              "The Macintosh (often called the Mac) was the first widely-sold personal computer with a graphical user interface (GUI) and a mouse. Apple Computer introduced the Macintosh in an ad during Super Bowl XVIII, on January 22, 1984, and offered it for sale two days later.",
                        ),
                      );
                    }),
              ),
              buildCategory(),
              buildFeature(),
              buildNewArchives(),
            ],
          ),
        ),
      ),
    );
  }
}
