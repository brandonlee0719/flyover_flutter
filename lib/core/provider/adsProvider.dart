// import 'dart:ffi';

// import 'package:flutter/material.dart';
// import 'package:native_admob_flutter/native_admob_flutter.dart';
// import 'package:nizvpn/core/provider/dataStream.dart';
// // import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:nizvpn/core/resources/environment.dart';
// import 'package:provider/provider.dart';

// import 'vpnProvider.dart';

// class AdsProvider extends ChangeNotifier {
//   InterstitialAd? intersAd1;
//   InterstitialAd? intersAd2;
//   InterstitialAd? intersAd3;

//   bool _footerBannerShow = false;
//   dynamic _bannerAd;

//   set footBannerShow(bool value) {
//     _footerBannerShow = value;
//     notifyListeners();
//   }

//   bool get footBannerShow => !showAds ? false : _footerBannerShow;

//   get bannerIsAvailable => _bannerAd != null;

//   InterstitialAd _intersAd1Create() => InterstitialAd(
//         unitId: inters1,
//         loadTimeout: Duration(seconds: 8),
//       )..onEvent.listen(
//           (event) {
//             switch (event.keys.first) {
//               case FullScreenAdEvent.closed:
//                 intersAd1!.dispose();
//                 intersAd1 = _intersAd1Create();
//                 intersAd1!.load();
//                 break;
//               default:
//             }
//           },
//         );
//   InterstitialAd _intersAd2Create() => InterstitialAd(
//         unitId: inters2,
//         loadTimeout: Duration(seconds: 8),
//       )..onEvent.listen((event) {
//           switch (event.keys.first) {
//             case FullScreenAdEvent.closed:
//               intersAd2!.dispose();
//               intersAd2 = _intersAd1Create();
//               intersAd2!.load();
//               break;
//             default:
//           }
//         });
//   InterstitialAd _intersAd3Create() => InterstitialAd(
//         unitId: inters3,
//         loadTimeout: Duration(seconds: 8),
//       )..onEvent.listen((event) {
//           switch (event.keys.first) {
//             case FullScreenAdEvent.closed:
//               intersAd3!.dispose();
//               intersAd3 = _intersAd1Create();
//               intersAd3!.load();
//               break;
//             default:
//           }
//         });
//   Future<bool> loadAd2() {
//     // wait 1 sec
//     return Future.delayed(Duration(microseconds: 5), () {
//       if (!showAds) return false;
//       intersAd2 = _intersAd2Create();
//       return intersAd2!.load().then((value) {
//         return value;
//       });
//     });
//   }

//   static void initAds(BuildContext context) {
//     if (!showAds) return;
//     AdsProvider adsProvider = AdsProvider.instance(context);

//     adsProvider.intersAd1 = adsProvider._intersAd1Create();
//     adsProvider.intersAd2 = adsProvider._intersAd2Create();
//     adsProvider.intersAd3 = adsProvider._intersAd3Create();

//     adsProvider.intersAd1?.load();
//     adsProvider.intersAd2?.load();
//     adsProvider.intersAd3?.load();
//   }

//   void showAd1(BuildContext context) async {
//     if (!showAds) return;
//     VpnProvider vpnProvider = VpnProvider.instance(context);
//     if (vpnProvider.isPro) return;
//     if ((intersAd1?.isAvailable) ?? false) {
//       intersAd1?.show();
//       intersAd1?.load();
//     } else {
//       intersAd1?.load();
//       intersAd1?.show();
//     }
//   }

//   Future<bool> showAd2(BuildContext context) async {
//     print('addddddddddddddddddddddddd::::::::::::::::: was here');
//     if (!showAds) return false;
//     print('addddddddddddddddddddddddd::::::::::::::::: was here 2');

//     VpnProvider vpnProvider = VpnProvider.instance(context);
//     print('addddddddddddddddddddddddd::::::::::::::::: was here 3');

//     if (vpnProvider.isPro) return false;
//     print('addddddddddddddddddddddddd::::::::::::::::: was here 4');

//     if ((intersAd2?.isAvailable) ?? false) {
//       print('addddddddddddddddddddddddd::::::::::::::::: was here 5');

//       intersAd2?.show();
//       intersAd2?.load();

//       return true;
//     } else {
//       print('addddddddddddddddddddddddd::::::::::::::::: was here 6');

//       intersAd2?.load();
//       return false;
//     }
//   }

//   void showAd3(BuildContext context) async {
//     if (!showAds) return;
//     VpnProvider vpnProvider = VpnProvider.instance(context);
//     if (vpnProvider.isPro) return;
//     if ((intersAd3?.isAvailable) ?? false) {
//       intersAd3?.show();
//     } else {
//       intersAd3?.load();
//     }
//   }

//   static Widget adWidget(BuildContext context,
//       {String? bannerId, BannerSize? adSize}) {
//     if (!showAds) return SizedBox.shrink();
//     VpnProvider vpnProvider = VpnProvider.instance(context);
//     // make a controller to show ads
//     final controller = BannerAdController();
//     if (vpnProvider.isPro) {
//       return SizedBox.shrink();
//     } else {
//       controller.onEvent.listen((e) async {
//         final event = e.keys.first;
//         final info = e.values.first;
//         switch (event) {
//           case BannerAdEvent.loading:
//             print('ad:::::::::::::::::::::::: load loading');

//             break;
//           case BannerAdEvent.loadFailed:
//             print('ad:::::::::::::::::::::::: load failed');
//             print(info);
//             break;
//           case BannerAdEvent.loaded:
//             print('ad:::::::::::::::::::::::: load loaded');
//             dataStream.sink.add('loaded');
//             break;
//           case BannerAdEvent.impression:
//             print('ad:::::::::::::::::::::::: load impression');
//             break;
//           default:
//             break;
//         }
//       });
//       // return SizedBox.shrink();
//       return BannerAd(
//         controller: controller,
//         unitId: bannerId ?? banner1,
//         size: adSize ?? BannerSize.ADAPTIVE,
//         loading: Center(child: CircularProgressIndicator()),
//       );
//       // return BannerAd(adUnitId: bannerId ?? banner1, adSize: adsize);
//     }
//   }

//   static Widget adbottomSpace() {
//     if (!showAds) return SizedBox.shrink();
//     return Consumer<AdsProvider>(
//       builder: (context, value, child) =>
//           value.footBannerShow ? SizedBox(height: 60) : SizedBox.shrink(),
//     );
//   }

//   void removeBanner() {
//     if (!showAds) return;
//     footBannerShow = false;
//     _bannerAd.dispose();
//     _bannerAd = null;
//   }

//   static AdsProvider instance(BuildContext context) =>
//       Provider.of(context, listen: false);
// }
