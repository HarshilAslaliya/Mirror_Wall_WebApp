import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../modals/globals.dart';
import '../sceens/homepage.dart';
import 'educational.dart';

class OTTPlatformsWeb extends StatefulWidget {
  const OTTPlatformsWeb({Key? key}) : super(key: key);

  @override
  State<OTTPlatformsWeb> createState() => _OTTPlatformsWebState();
}

class _OTTPlatformsWebState extends State<OTTPlatformsWeb> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.13,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ottplatforms.length,
              padding: const EdgeInsets.all(15),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 30,
                crossAxisSpacing: 20,
              ),
              itemBuilder: (context, i) {
                return Neumorphic(
                  style: const NeumorphicStyle(shadowDarkColor: Colors.black),
                  child: GestureDetector(
                    onTap: () async {
                      await inAppWebViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: Uri.parse(
                            ottplatforms[i]['url'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage(
                            ottplatforms[i]['image'],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.646,
            width: MediaQuery.of(context).size.width * 1,
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: Uri.parse("https://google.com"),
              ),
              onWebViewCreated: (controller) {
                setState(() {
                  inAppWebViewController = controller;
                });
              },
              pullToRefreshController: pullToRefreshController,
              onLoadStop: (controller, url) async {
                await pullToRefreshController.endRefreshing();
              },
            ),
          ),
        ],
      ),
    );
  }
}
