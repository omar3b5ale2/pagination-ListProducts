import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var products = [];
  int skip = 0;
  int limit = 20;
  ThemeMode? themeMode;
  bool isLoadMore = false;
  Widget? icon;
  var baseUrl =
      'https://dummyjson.com/products?limit=20&skip=0&select=title,description,thumbnail';
  ScrollController scrollController = ScrollController();
  fetchData() async {
    try {
      var url = Uri.parse(
          'https://dummyjson.com/products?limit=$limit&skip=$skip&select=title,description,thumbnail');
      http.Response response;
      response = await http.get(url);
      switch (response.statusCode) {
        case 200:
          final data = jsonDecode(response.body)['products'] as List;
          setState(() {
            products.addAll(data);
          });
        default:
          throw Exception(response.reasonPhrase);
      }
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  void initState() {
    fetchData();
    scrollController.addListener(() async {
      if (isLoadMore) return;
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoadMore = true;
        });
        skip = skip + limit;
        //0+20 = 20 => first loop && 40 second and so on every time skip will increase with 20 item.
        await fetchData();
        setState(() {
          isLoadMore = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.indigo,
        appBar: AppBar(
          backgroundColor: Colors.indigo[500],
          title: Center(
            child: Text(
              'ProductsList',
              style: GoogleFonts.aBeeZee(),
            ),
          ),
        ),
        drawer: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/back.jpg'),
            fit: BoxFit.contain,
          )),
          child: Drawer(
            width: screenSize.width,
            shadowColor: Colors.black12,
          ),
        ),
        drawerScrimColor: Colors.blueGrey,
        body: SafeArea(
          child: products.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Colors.amber,
                  strokeAlign: 10.0,
                  backgroundColor: Colors.deepOrangeAccent,
                ))
              : Container(
                  width: screenSize.width,
                  height: screenSize.height,
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount:
                        isLoadMore ? products.length + 1 : products.length,
                    itemBuilder: (context, index) {
                      return (index >= products.length)
                          ? const Center(child: CircularProgressIndicator())
                          : Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      products[index]['thumbnail']),
                                ),
                                title: Text(
                                  products[index]['title'],
                                  style: GoogleFonts.aBeeZee(),
                                ),
                                subtitle: Text(products[index]['description'],
                                    style: GoogleFonts.aBeeZee()),
                              ),
                            );
                    },
                  ),
                ),
        ));
  }
}
