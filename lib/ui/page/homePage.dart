import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:lottie/lottie.dart';
// import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:ndialog/ndialog.dart';
import 'package:nizvpn/core/provider/dataStream.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

// import '../../core/provider/adsProvider.dart';
import '../../core/provider/uiProvider.dart';
import '../../core/provider/vpnProvider.dart';
import '../../core/resources/environment.dart';
import '../../core/resources/nerdVpnIcons.dart';
import '../../core/resources/warna.dart';
import '../../core/utils/NizVPN.dart';
import '../../core/utils/preferences.dart';
import '../components/customDivider.dart';
import '../components/customImage.dart';
import '../screens/subscriptionDetailScreen.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

// import 'package:facebook_audience_network/facebook_audience_network.dart' as fb;

class BerandaPage extends StatefulWidget {
  @override
  _BerandaPageState createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  @override
  void didChangeDependencies() {
    VpnProvider.refreshInfoVPN(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  var fbBanner = null;
  bool allowDisconnect = true;
  bool loading = false;
  bool fbpopuploaded = false;
  bool fbpopuperrored = false;
  bool fbpopupwaiting = false;
  bool fbBannerError = false;

  bool letAlreadyDis = false;
  bool letAlreadyCon = false;

  bool canLoadInter = false;
  bool loadedInter = false;

  String ip = 'Checking IP...';
  bool canLoadBanner = false;
  bool loadedBanner = false;

  bool googleBannerLoaded = false;

  @override
  void initState() {
    super.initState();

    print('fb ad: starting');
    // loadGoogleBanner();
    loadAppoDeal();
    // fb.FacebookAudienceNetwork.init(
    //         // testingId: 'bb783c68-3722-4623-9373-5983c3301cec',

    //         )
    //     .then((value) => {
    //           print('fb ad: started'),
    //           renderFbBannerOrError(context),
    //           _loadInterstitialAd(),
    //         });
    //
    getCurrentIPandUpdateIP();
  }

  void getCurrentIPandUpdateIP() async {
    // get ip json from: https://api.ipify.org?format=json

    // send a get request to the url
    var response =
        await http.get(Uri.parse('https://api.ipify.org?format=json'));
    print('response.body');
    print(response.body);

    // convert the response to a json object
    var jsonResponse = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        ip = 'IP: ' + jsonResponse['ip'];
      });
    } else {
      setState(() {
        ip = 'IP: Uknown';
      });
    }
  }

  void loadAppoDeal() async {
    Appodeal.setInterstitialCallbacks(
        onInterstitialLoaded: (isPrecache) => {
              print('adodeal: interstitial loaded'),
              // show toast
              // Fluttertoast.showToast(
              //     msg: 'adodeal: interstitial loaded',
              //     toastLength: Toast.LENGTH_SHORT,
              //     gravity: ToastGravity.BOTTOM,
              //     timeInSecForIosWeb: 1,
              //     backgroundColor: Colors.black,
              //     textColor: Colors.white,
              //     fontSize: 16.0),
            },
        onInterstitialFailedToLoad: () => {
              print('adodeal: interstitial failed to load'),
              // Fluttertoast.showToast(
              //     msg: 'adodeal: interstitial failed to load',
              //     toastLength: Toast.LENGTH_SHORT,
              //     gravity: ToastGravity.BOTTOM,
              //     timeInSecForIosWeb: 1,
              //     backgroundColor: Colors.black,
              //     textColor: Colors.white,
              //     fontSize: 16.0),
            },
        onInterstitialShown: () => {
              print('adodeal: interstitial shown'),
              // Fluttertoast.showToast(
              //     msg: 'adodeal: interstitial shown',
              //     toastLength: Toast.LENGTH_SHORT,
              //     gravity: ToastGravity.BOTTOM,
              //     timeInSecForIosWeb: 1,
              //     backgroundColor: Colors.black,
              //     textColor: Colors.white,
              //     fontSize: 16.0),
            },
        onInterstitialShowFailed: () => {
              print('adodeal: interstitial show failed'),
              // Fluttertoast.showToast(
              //     msg: 'adodeal: interstitial show failed',
              //     toastLength: Toast.LENGTH_SHORT,
              //     gravity: ToastGravity.BOTTOM,
              //     timeInSecForIosWeb: 1,
              //     backgroundColor: Colors.black,
              //     textColor: Colors.white,
              //     fontSize: 16.0),
            },
        onInterstitialClicked: () => {
              print('adodeal: interstitial clicked'),
              // Fluttertoast.showToast(
              //     msg: 'adodeal: interstitial clicked',
              //     toastLength: Toast.LENGTH_SHORT,
              //     gravity: ToastGravity.BOTTOM,
              //     timeInSecForIosWeb: 1,
              //     backgroundColor: Colors.black,
              //     textColor: Colors.white,
              //     fontSize: 16.0),
            },
        onInterstitialClosed: () => {
              print('adodeal: interstitial closed'),
              // Fluttertoast.showToast(
              //     msg: 'adodeal: interstitial closed',
              //     toastLength: Toast.LENGTH_SHORT,
              //     gravity: ToastGravity.BOTTOM,
              //     timeInSecForIosWeb: 1,
              //     backgroundColor: Colors.black,
              //     textColor: Colors.white,
              //     fontSize: 16.0),
            },
        onInterstitialExpired: () => {
              print('adodeal: interstitial expired'),
              // Fluttertoast.showToast(
              //     msg: 'adodeal: interstitial expired',
              //     toastLength: Toast.LENGTH_SHORT,
              //     gravity: ToastGravity.BOTTOM,
              //     timeInSecForIosWeb: 1,
              //     backgroundColor: Colors.black,
              //     textColor: Colors.white,
              //     fontSize: 16.0),
            });

    Appodeal.setBannerCallbacks(
        onBannerLoaded: (isPrecache) => {
              print('adodeal: banner loaded'),
            },
        onBannerFailedToLoad: () => {
              print('adodeal: banner failed to load'),
            },
        onBannerShown: () => {
              print('adodeal: banner shown'),
            },
        onBannerShowFailed: () => {
              print('adodeal: banner show failed'),
            },
        onBannerClicked: () => {
              print('adodeal: banner clicked'),
            },
        onBannerExpired: () => {
              print('adodeal: banner expired'),
            });

    // Check that interstitial
    var isCanShow = await Appodeal.canShow(AppodealAdType.Interstitial);

    // canLoadInter = isCanShow;
    setState(() {
      canLoadInter = isCanShow;
    });
    // Check that interstitial is loaded
    var isLoaded = await Appodeal.isLoaded(AppodealAdType.Interstitial);
    // loadedInter = isLoaded;
    setState(() {
      loadedInter = isLoaded;
    });

    Appodeal.show(AppodealAdType.Banner);

    // show bottom banner
    var canBanner = await Appodeal.canShow(AppodealAdType.Banner);
    if (canBanner) {
      var bannerLoadd = await Appodeal.isLoaded(AppodealAdType.Banner);
      if (bannerLoadd) {
        Appodeal.show(AppodealAdType.Banner);
      }
    }
  }

  Future<bool> showInter(VpnProvider vpnProvider) async {
    if (!showAds) return false;
    if (vpnProvider.isPro) return false;

    bool didShow = await Appodeal.show(
        AppodealAdType.Interstitial, 'before/after connect');

    // if (!canLoadInter) {
    //   Fluttertoast.showToast(
    //       msg: 'canLoadInter',
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: Colors.black,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    // }
    // if (!loadedInter) {
    //   Fluttertoast.showToast(
    //       msg: 'loadedInter',
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: Colors.black,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    // }

    return didShow;

    if (canLoadInter && loadedInter) {
      bool didShow = await Appodeal.show(
          AppodealAdType.Interstitial, 'before/after connect');

      return didShow;
    } else {
      // Fluttertoast.showToast(
      //     msg: "can't show 2!",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
      return false;
    }
  }

  // void loadGoogleBanner() async {
  //   bool loaded = await AdsProvider.instance(context).loadAd2();
  //   setState(() {
  //     googleBannerLoaded = loaded;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _customAppBarWidget(),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Stack(
                    children: [
                      _body(allowDisconnect),
                      _loadingWidget(),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  // loading widget
  Widget _loadingWidget() {
    if (loading) {
      return Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // background color
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _body(allowDisconnect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ColumnDivider(space: 20),
        _topMessageWidget(),
        ColumnDivider(space: 20),
        SizedBox(height: 200, child: _connectButtonWidget(allowDisconnect)),
        ColumnDivider(space: 20),
        _currentLocationWidget(),
        Platform.isAndroid ? _connectionInfo() : SizedBox(),
        ColumnDivider(space: 90),
      ],
    );
  }

  Widget _connectionInfo() {
    return Container(
      height: 100,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Consumer<VpnProvider>(
        builder: (context, snapshot, child) {
          String byteIn = "0,0 kB - 0,0 kB/s";
          String byteOut = "0,0 kB - 0,0 kB/s";

          if (snapshot.vpnStatus != null) {
            byteIn = snapshot.vpnStatus!.byteIn!.trim().length == 0
                ? "0,0 kB - 0,0 kB/s"
                : snapshot.vpnStatus!.byteIn!.trim();
            byteOut = snapshot.vpnStatus!.byteOut!.trim().length == 0
                ? "0,0 kB - 0,0 kB/s"
                : snapshot.vpnStatus!.byteOut!.trim();
          }
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "download".tr(),
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      byteIn,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "upload".tr(),
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      byteOut,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _currentLocationWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            // justify content space between
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "current_location".tr(),
                style: TextStyle(fontSize: 12),
              ),
              Text(
                ip,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          ColumnDivider(
            space: 5,
          ),
          Consumer<VpnProvider>(
            builder: (context, value, child) => SizedBox(
              height: 50,
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: grey)))),
                child: Row(
                  children: [
                    value.vpnConfig?.flag == null
                        ? SizedBox.shrink()
                        : SizedBox(
                            height: 30,
                            width: 30,
                            child: (value.vpnConfig!.flag!
                                    .toLowerCase()
                                    .startsWith("http")
                                ? CustomImage(
                                    url: value.vpnConfig!.flag,
                                    fit: BoxFit.scaleDown,
                                  )
                                : Image.asset(
                                    "assets/icons/flags/${value.vpnConfig!.flag}.png",
                                    height: 30,
                                    width: 30,
                                  )),
                          ),
                    RowDivider(),
                    Expanded(
                        child:
                            Text(value.vpnConfig?.name ?? "Select server...")),
                    Consumer<VpnProvider>(
                      builder: (context, value, child) =>
                          Text(value.vpnConfig?.protocol?.toUpperCase() ?? ""),
                    ),
                  ],
                ),
                onPressed: _changeLocationClick,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _connectButtonWidget(allowDisconnect) {
    return Consumer<VpnProvider>(
      builder: (context, value, child) {
        Color buttonColor = greyLittleWhite;
        // Color focusColor = greyLittleWhite;

        // Fluttertoast.showToast(
        //     msg: 'stage: ' + value.vpnStage.toString(),
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.black,
        //     textColor: Colors.white,
        //     fontSize: 16.0);

        String stage = (value.vpnStage ?? NVPN.vpnDisconnected).toLowerCase();
        if (stage == NVPN.vpnConnected.toLowerCase()) {
          buttonColor = primaryColor;
        } else if (stage != NVPN.vpnDisconnected.toLowerCase() || stage == "") {
          buttonColor = Colors.orange;
        } else {
          buttonColor = greyLittleWhite;
        }
        print('stage: ' + stage);
        return Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black.withOpacity(.1),
                ),
              ],
              shape: BoxShape.circle,
            ),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(buttonColor),
                shape: MaterialStateProperty.all(CircleBorder()),
              ),
              onPressed: () => _connectVPNClick(value, allowDisconnect),
              child: Icon(
                NerdVPNIcon.power,
                size: 130,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _topMessageWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Consumer<VpnProvider>(
        builder: (context, value, child) {
          String tulisan = "unprotected".tr();
          Color color = Colors.red;

          String stage = (value.vpnStage ?? NVPN.vpnDisconnected).toLowerCase();
          print('stage: ' + stage);

          if (stage == NVPN.vpnConnected.toLowerCase()) {
            if (!letAlreadyCon) {
              getCurrentIPandUpdateIP();
              letAlreadyCon = true;
              letAlreadyDis = false;
              // setState(() {
              //   letAlreadyCon = true;
              //   letAlreadyDis = false;
              // });
            }
            tulisan = "protected".tr();
            color = Colors.green;
          } else if (stage != NVPN.vpnDisconnected.toLowerCase()) {
            tulisan = value.vpnStage!.replaceAll("_", " ");
            color = Colors.orange;
          } else {
            if (!letAlreadyDis) {
              getCurrentIPandUpdateIP();
              letAlreadyCon = false;
              letAlreadyDis = true;
              // setState(() {

              // });
            }
            tulisan = "unprotected".tr();
            color = Colors.red;
          }
          return RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: "${"welcome".tr()},\n",
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              TextSpan(
                  text: "${"your_connection".tr()} ",
                  style:
                      GoogleFonts.poppins(fontSize: 15, color: Colors.black)),
              TextSpan(
                  text: tulisan.toUpperCase(),
                  style: GoogleFonts.poppins(fontSize: 15, color: color)),
            ]),
          );
        },
      ),
    );
  }

  Widget _customAppBarWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                  text: "$appname ",
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
              TextSpan(
                  text: "VPN",
                  style: GoogleFonts.poppins(
                      color: primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
            ]),
          ),
          Consumer<VpnProvider>(
            builder: (context, value, child) {
              if (value.isPro) {
                return Positioned(
                  child: CupertinoButton(
                    padding: EdgeInsets.only(),
                    onPressed: () {},
                    child: Row(
                      children: [
                        LottieBuilder.asset(
                          "assets/animations/crown.json",
                          height: 50,
                          width: 50,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                  right: 0,
                );
              }
              return Positioned(
                child: CupertinoButton(
                  padding: EdgeInsets.only(),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SubscriptionDetailScreen()));
                  },
                  child: Row(
                    children: [
                      LottieBuilder.asset(
                        "assets/animations/crown_grey.json",
                        height: 50,
                        width: 50,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                right: 0,
              );
            },
          )
        ],
      ),
    );
  }

  // void _loadInterstitialAd() {
  //   print('fb ad: loading');
  //   fb.FacebookInterstitialAd.loadInterstitialAd(
  //     // placementId: "YOUR_PLACEMENT_ID" 394187569408638_394188742741854,
  //     placementId: "498984975335393_498997422000815",
  //     listener: (result, value) {
  //       print('fb ad: loaded');

  //       print('result-+++++++++++++--');

  //       print(result);
  //       print(value);
  //       print('result-+++++++++++++--');

  //       print(">> FAN > Interstitial Ad: $result --> $value");
  //       if (result == fb.InterstitialAdResult.LOADED) {
  //         fbpopuploaded = true;
  //       } else {
  //         fbpopuploaded = false;
  //       }

  //       /// Once an Interstitial Ad has been dismissed and becomes invalidated,
  //       /// load a fresh Ad by calling this function.
  //       if (result == fb.InterstitialAdResult.DISMISSED &&
  //           value["invalidated"] == true) {
  //         fbpopuploaded = false;
  //         _loadInterstitialAd();
  //       }
  //     },
  //   ).onError((error, stackTrace) {
  //     print('error---------------++--');
  //     print(error);
  //     print(stackTrace);
  //   });
  // }

  // _showInterstitialAd() {
  //   fb.FacebookInterstitialAd.showInterstitialAd(delay: 500)
  //       .then((value) => {});
  //   if (fbpopuploaded == true) {
  //     print('fb ad: shown');
  //   } else {
  //     print('fb ad: false');
  //     print("Interstial Ad not yet loaded!");
  //   }
  // }

  // Future<bool> tryGoogleAds() async {
  //   InterstitialAd? intersAdLocal;
  //   intersAdLocal = AdsProvider.instance(context).intersAd2;
  //   if ((intersAdLocal != null ?? false)) {
  //     if (intersAdLocal?.isAvailable ?? false) {
  //       await intersAdLocal?.show();
  //       return true;
  //     } else {
  //       setState(() {
  //         loading = true;
  //       });
  //       await intersAdLocal?.load();
  //       setState(() {
  //         loading = false;
  //       });
  //       await intersAdLocal?.show();
  //     }
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // Future<bool> handleAds(VpnProvider vpnProvider) async {
  //   if (!showAds) return false;
  //   if (vpnProvider.isPro) return false;

  //   setState(() {
  //     loading = true;
  //   });

  //   _showInterstitialAd();
  //   await Future.delayed(Duration(seconds: 2));

  //   if (fbpopuploaded) {
  //     // _showInterstitialAd();
  //     await Future.delayed(Duration(seconds: 3));

  //     setState(() {
  //       loading = true;
  //     });
  //   } else {
  //     setState(() {
  //       loading = true;
  //     });
  //     _loadInterstitialAd();

  //     // wait 3 seconds for ad to load
  //     await Future.delayed(Duration(seconds: 3));
  //     if (fbpopuploaded) {
  //       _showInterstitialAd();

  //       await Future.delayed(Duration(seconds: 3));
  //       setState(() {
  //         loading = false;
  //       });
  //     } else {
  //       setState(() {
  //         loading = false;
  //       });
  //       await tryGoogleAds();
  //     }
  //   }
  //   return true;
  // }

  // renderFbBannerOrError(context) {
  //   print("fb ad: banner loading");
  //   var bb = fb.FacebookNativeAd(
  //     placementId:
  //         "498984975335393_499349075298983", // 394187569408638_394285402732188
  //     adType: fb.NativeAdType.NATIVE_AD,
  //     bannerAdSize: fb.NativeBannerAdSize.HEIGHT_120,
  //     width: double.infinity,
  //     backgroundColor: Colors.blue,
  //     titleColor: Colors.white,
  //     descriptionColor: Colors.white,
  //     buttonColor: Colors.deepPurple,
  //     buttonTitleColor: Colors.white,
  //     buttonBorderColor: Colors.white,
  //     listener: (result, value) {
  //       print("fb ad: banner result");

  //       if (result == fb.NativeAdResult.ERROR) {
  //         print('native fallback tried');

  //         setState(() {
  //           fbBannerError = true;
  //         });
  //       } else {
  //         fbBannerError = false;
  //       }

  //       print("Native Banner Ad: $result --> $value");
  //     },
  //   );
  //   setState(() {
  //     fbBanner = bb;
  //   });
  // }

  // bannerAdd(context) {
  //   if (!fbBannerError) return fbBanner;
  //   print('native fallback happened');
  //   return AdsProvider.adWidget(
  //     context,
  //     bannerId: banner2,
  //     adSize: BannerSize(Size(320, 250)),
  //   );
  // }

  void _connectVPNClick(VpnProvider vpnProvider, allowDisconnect) async {
    await showInter(vpnProvider);
    // return;
    // await handleAds(vpnProvider);
    setState(() {
      loading = false;
    });
    // return;
    // delay to allow ads to load

    // listen to dataStream and if event is 'loaded' set showDisconnect to true
    try {
      dataStream.stream.listen((event) {
        print('listen to dataStream: $event');
        if (event == "loaded") {
          print('hahahahhahaahahahaha');

          setState(() {
            allowDisconnect = true;
          });
        }
      });
    } catch (e) {
      print('error: $e');
    }
    if (vpnProvider.vpnStage != NVPN.vpnDisconnected &&
        (vpnProvider.vpnStage?.length ?? 0) > 0) {
      if (vpnProvider.vpnStage == NVPN.vpnConnected) {
        var resp = await NAlertDialog(
          dialogStyle: DialogStyle(
              titleDivider: true, contentPadding: EdgeInsets.only()),
          title: Text("${"sure".tr()}?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // SizedBox(
              //   width: 300,
              //   height: 250,
              //   child: AppodealBanner(
              //       adSize: AppodealBannerSize.MEDIUM_RECTANGLE,
              //       placement: "disconnect_banner"),
              // ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text("disconnect_question".tr()),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text((!allowDisconnect ? "loading" : "disconnect").tr()),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)))),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: Text("cancel".tr()),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)))),
              onPressed: () {
                // if (!allowDisconnect) return;
                Navigator.pop(context, false);
              },
            ),
          ],
        ).show(context);

        // AdsProvider.instance(context).showAd2(context);
        if (resp ?? false) {
          NVPN.stopVpn();
        }
      } else {
        NVPN.stopVpn();
      }
    } else {
      if (vpnProvider.vpnConfig != null) {
        if (vpnProvider.vpnConfig!.status == 1 && !vpnProvider.isPro) {
          return VpnProvider.renewSubs(context);
        }
        if (vpnProvider.vpnConfig!.config == null &&
            vpnProvider.vpnConfig!.slug != null) {
          await CustomProgressDialog.future(
            context,
            future: vpnProvider.setConfig(context, vpnProvider.vpnConfig!.slug,
                vpnProvider.vpnConfig!.protocol),
            dismissable: false,
            loadingWidget: Center(
              child: Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          );
          return _connectVPNClick(vpnProvider, allowDisconnect);
        }
      } else {
        return NAlertDialog(
          title: Text("unknown_server".tr()),
          content: Text("select_a_server".tr()),
          actions: [
            TextButton(
              onPressed: () => UIProvider.instance(context)
                  .sheetController
                  .snapToPosition(SnappingPosition.factor(
                      positionFactor: .8,
                      grabbingContentOffset: GrabbingContentOffset.bottom)),
              child: Text("choose_server".tr()),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)))),
            )
          ],
        ).show(context);
      }

      Future.delayed(Duration(seconds: 5)).then((value) async {
        if ((await Preferences.init()).shared.getBool("show_dialog") ?? false)
          return;
        if (Random().nextBool()) {
          NAlertDialog(
            title: Text("rating_title".tr()),
            content: Text("rating_description".tr()),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("rating_done".tr())),
              TextButton(
                child: Text("rating_goto".tr()),
                onPressed: () {
                  InAppReview.instance.openStoreListing();
                  Navigator.pop(context);
                },
              ),
            ],
          ).show(context).then((value) async {
            Preferences.init().then((value) {
              value.shared.setBool("show_dialog", true);
            });
          });
        }
      });

      // AdsProvider.instance(context).showAd1(context);
      await NVPN.startVpn(vpnProvider.vpnConfig!);
    }
  }

  void _changeLocationClick() async {
    UIProvider.instance(context).sheetController.snapToPosition(
        SnappingPosition.factor(
            positionFactor: .8,
            grabbingContentOffset: GrabbingContentOffset.bottom));
  }
}
