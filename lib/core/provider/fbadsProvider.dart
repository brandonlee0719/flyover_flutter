// import 'dart:ffi';

// import 'package:flutter/material.dart';
// import 'package:native_admob_flutter/native_admob_flutter.dart';
// import 'package:nizvpn/core/provider/dataStream.dart';
// // import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:nizvpn/core/resources/environment.dart';
// import 'package:provider/provider.dart';
// import '../../core/provider/adsProvider.dart';

// import 'vpnProvider.dart';
// import 'package:facebook_audience_network/facebook_audience_network.dart' as fb;

// class FbadsProvider extends StatefulWidget {
//   @override
//   _FbadsProviderState createState() => _FbadsProviderState();
// }

// class _FbadsProviderState extends State<FbadsProvider> {
//   bool allowDisconnect = true;
//   bool loading = false;
//   bool fbpopuploaded = false;
//   bool fbpopuperrored = false;
//   bool fbpopupwaiting = false;
//   bool fbBannerError = false;

//   @override
//   void initState() {
//     super.initState();

//     print('fb ad:main starting');
//     fb.FacebookAudienceNetwork.init(
//             // testingId: 'bb783c68-3722-4623-9373-5983c3301cec',

//             )
//         .then((value) => {
//               print('fb ad:main started'),
//               _loadInterstitialAd(),
//             });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 5),
//       child: Container(),
//     );
//   }

//   // --------------------------------
//   void _loadInterstitialAd() {
//     print('fb ad:main loading');
//     fb.FacebookInterstitialAd.loadInterstitialAd(
//       // placementId: "YOUR_PLACEMENT_ID" 394187569408638_394188742741854,
//       placementId: "394187569408638_394188742741854",
//       listener: (result, value) {
//         print('fb ad:main loaded');

//         print('result-+++++++++++++--');

//         print(result);
//         print(value);
//         print('result-+++++++++++++--');

//         print(">> FAN > Interstitial Ad: $result --> $value");
//         if (result == fb.InterstitialAdResult.LOADED) {
//           fbpopuploaded = true;
//         } else {
//           fbpopuploaded = false;
//         }
//         VpnProvider provider = VpnProvider.instance(context);
//         handleAds(provider);

//         /// Once an Interstitial Ad has been dismissed and becomes invalidated,
//         /// load a fresh Ad by calling this function.
//         if (result == fb.InterstitialAdResult.DISMISSED &&
//             value["invalidated"] == true) {
//           fbpopuploaded = false;
//           _loadInterstitialAd();
//         }
//       },
//     ).onError((error, stackTrace) {
//       print('error---------------++--');
//       print(error);
//       print(stackTrace);
//     });
//   }

//   _showInterstitialAd() {
//     print('fb ad:main showing');

//     fb.FacebookInterstitialAd.showInterstitialAd(delay: 500).then((value) => {
//           print('fb ad:main showing value' + (value).toString()),
//         });
//     if (fbpopuploaded == true) {
//       print('fb ad:main shown');
//     } else {
//       print('fb ad:main false');
//       print("Interstial Ad not yet loaded!");
//     }
//   }

//   Future<bool> tryGoogleAds() async {
//     InterstitialAd? intersAdLocal;
//     intersAdLocal = AdsProvider.instance(context).intersAd2;
//     if ((intersAdLocal != null ?? false)) {
//       if (intersAdLocal?.isAvailable ?? false) {
//         await intersAdLocal?.show();
//         return true;
//       } else {
//         setState(() {
//           loading = true;
//         });
//         await intersAdLocal?.load();
//         setState(() {
//           loading = false;
//         });
//         await intersAdLocal?.show();
//       }
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future<bool> handleAds(VpnProvider vpnProvider) async {
//     if (!showAds) return false;
//     if (vpnProvider.isPro) return false;

//     print("fb ad:main tried to show");

//     // setState(() {
//     //   loading = true;
//     // });

//     _showInterstitialAd();
//     await Future.delayed(Duration(seconds: 2));

//     if (fbpopuploaded) {
//       // _showInterstitialAd();
//       await Future.delayed(Duration(seconds: 3));

//       // setState(() {
//       //   loading = true;
//       // });
//     } else {
//       // setState(() {
//       //   loading = true;
//       // });
//       _loadInterstitialAd();

//       // wait 3 seconds for ad to load
//       await Future.delayed(Duration(seconds: 3));
//       if (fbpopuploaded) {
//         _showInterstitialAd();

//         await Future.delayed(Duration(seconds: 3));
//         // setState(() {
//         //   loading = false;
//         // });
//       } else {
//         // setState(() {
//         //   loading = false;
//         // });
//         await tryGoogleAds();
//       }
//     }
//     return true;
//   }
//   // ***********************************

// }
