import 'dart:io';

//if you got problems with your endpoint, read FAQ in the docs
const String endpoint =
    "https://flyovervpn.com/mobileadmin/public"; //<= Replace with yours

const String appname = "FlyOver";

const String defaultVpnUsername = "";
const String defaultVpnPassword = "";

const bool showAds = true;
const bool groupCountries = false;
const bool showAllCountries = true;

//IOS AppstoreID
//Do not change this without read the instructions
const String vpnExtensionIdentifier = "com.flyovervpn.app.VPNExtensions";
const String groupIdentifier = "group.com.flyovervpn.app";
const String appstoreId = "";

const String androidAdmobAppId = "ca-app-pub-2818856964974442~6158241940";
const String iosAdmobAppId = "ca-app-pub-2818856964974442~5851760810";

const String banner1Android =
    "ca-app-pub-2818856964974442/9603303569"; //BOTTOM_BANNER
const String banner2Android =
    "ca-app-pub-2818856964974442/9603303569"; //DIALOG_BANNER
const String inters1Android =
    "ca-app-pub-2818856964974442/8098650201"; //CONNECT_VPN
const String inters2Android =
    "ca-app-pub-2818856964974442/4183455927"; //DISCONNECT_VPN
const String inters3Android =
    "ca-app-pub-2818856964974442/6131568936"; //SELECT_SERVER

const String banner1IOS =
    "ca-app-pub-2818856964974442/6402425157"; //BOTTOM_BANNER
const String banner2IOS =
    "ca-app-pub-2818856964974442/9407862443"; //DIALOG_BANNER
const String inters1IOS =
    "ca-app-pub-2818856964974442/8837016804"; //CONNECT_VPN
const String inters2IOS =
    "ca-app-pub-2818856964974442/9024719061"; //DISCONNECT_VPN
const String inters3IOS =
    "ca-app-pub-2818856964974442/4870577984"; //SELECT_SERVER

// // test ids?
// const String banner1Android =
//     "ca-app-pub-3940256099942544/6300978111"; //BOTTOM_BANNER
// const String banner2Android =
//     "ca-app-pub-3940256099942544/6300978111"; //DIALOG_BANNER
// const String inters1Android =
//     "ca-app-pub-3940256099942544/1033173712"; //CONNECT_VPN
// const String inters2Android =
//     "ca-app-pub-3940256099942544/1033173712"; //DISCONNECT_VPN
// const String inters3Android =
//     "ca-app-pub-3940256099942544/1033173712"; //SELECT_SERVER

// const String banner1IOS =
//     "ca-app-pub-3940256099942544/6300978111"; //BOTTOM_BANNER
// const String banner2IOS =
//     "ca-app-pub-3940256099942544/6300978111"; //DIALOG_BANNER
// const String inters1IOS =
//     "ca-app-pub-3940256099942544/1033173712"; //CONNECT_VPN
// const String inters2IOS =
//     "ca-app-pub-3940256099942544/1033173712"; //DISCONNECT_VPN
// const String inters3IOS =
//     "ca-app-pub-3940256099942544/1033173712"; //SELECT_SERVER

//Do not touch section ===================================================================
const String api = "$endpoint/api/";

String get banner1 => Platform.isIOS ? banner1IOS : banner1Android;
String get banner2 => Platform.isIOS ? banner2IOS : banner2Android;
String get inters1 => Platform.isIOS ? inters1IOS : inters1Android;
String get inters2 => Platform.isIOS ? inters2IOS : inters2Android;
String get inters3 => Platform.isIOS ? inters3IOS : inters3Android;
