// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pr3_1/views/components/educational.dart';
import 'package:pr3_1/views/components/ottplatforms.dart';

List<String> allBookmarks = [];

late PullToRefreshController pullToRefreshController;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  TextEditingController textEditingController = TextEditingController();

  String url = "https://www.google.com/";

  PageController pageController = PageController();

  int current = 0;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);

    pullToRefreshController=PullToRefreshController(
      options: PullToRefreshOptions(color: Colors.blue),
      onRefresh: ()async{
        await inAppWebViewController?.reload();
      }
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: textEditingController,
          onSaved: (val) async{
            setState(() {
              url = val!;
            });
           await inAppWebViewController?.loadUrl(
              urlRequest: URLRequest(
                url: Uri.parse(val!),
              ),
            );
          },
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () async {
                // await inAppWebViewController?.stopLoading();
              },
              icon: const Icon(Icons.close, color: Colors.white, size: 25),
            ),
            focusedBorder: InputBorder.none,
            prefixIcon: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Center(
                      child: Text('Bookmarks'),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...allBookmarks
                            .map(
                              (e) => GestureDetector(
                                onTap: () async {
                                  Navigator.pop(context);

                                  await inAppWebViewController?.loadUrl(
                                    urlRequest: URLRequest(
                                      url: Uri.parse(e),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Text(e,style: const TextStyle(color: Colors.blue),),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.bookmarks, color: Colors.white, size: 25),
            ),
            hintText: ' Search a content',
            border: InputBorder.none,
            hintStyle: const TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.label,
          onTap: (current) {
            pageController.animateToPage(current,
                duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
          },
          controller: tabController,
          tabs: const [
            Tab(
              text: 'Educational',
            ),
            Tab(
              text: 'OTT Platforms',
            ),
          ],
        ),
      ),
      body: PageView(
        onPageChanged: (current) {
          tabController.animateTo(current);
        },
        controller: pageController,
        children: const [
          EducationalWeb(),
          OTTPlatformsWeb(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Uri? uri = await inAppWebViewController?.getUrl();

          String url = uri.toString();

          allBookmarks.add(url);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('website added in bookmark list!'),
            ),
          );
        },
        child: const Icon(Icons.bookmark_add_outlined),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.07,
        color: const Color(0xff4b4e6d),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () async {
                await inAppWebViewController?.goBack();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 30,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () async {
                await inAppWebViewController?.loadUrl(
                  urlRequest: URLRequest(
                    url: Uri.parse(url),
                  ),
                );
              },
              icon: const Icon(
                Icons.home,
                size: 30,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () async {
                await inAppWebViewController?.goForward();
              },
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 30,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () async {
                await inAppWebViewController?.reload();
              },
              icon: const Icon(
                Icons.refresh,
                size: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
