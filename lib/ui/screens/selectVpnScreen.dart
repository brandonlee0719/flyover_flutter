import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:line_icons/line_icons.dart';
// import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:ndialog/ndialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import '../../core/https/vpnServerHttp.dart';
import '../../core/models/vpnConfig.dart';
import '../../core/models/vpnServer.dart';
// import '../../core/provider/adsProvider.dart';
import '../../core/provider/uiProvider.dart';
import '../../core/provider/vpnProvider.dart';
import '../../core/resources/environment.dart';
import '../../core/resources/warna.dart';
import '../../core/utils/NizVPN.dart';
import '../components/customCard.dart';
import '../components/customDivider.dart';
import '../components/customImage.dart';
import 'subscriptionDetailScreen.dart';

// import 'package:facebook_audience_network/facebook_audience_network.dart' as fb;

import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

class SelectVpnScreen extends StatefulWidget {
  final ScrollController? scrollController;

  const SelectVpnScreen({Key? key, @required this.scrollController})
      : super(key: key);
  @override
  _SelectVpnScreenState createState() => _SelectVpnScreenState();
}

class _SelectVpnScreenState extends State<SelectVpnScreen>
    with AutomaticKeepAliveClientMixin {
  int _page = 0;
  final PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NestedScrollView(
      controller: widget.scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverToBoxAdapter(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 20),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      pageController.animateToPage(0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                      setState(() {
                        _page = 0;
                      });
                    },
                    child: ClipPath(
                      clipper: LeftButtonShape(),
                      child: Container(
                        height: 40,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: _page == 0
                              ? Colors.white
                              : Colors.black.withOpacity(.1),
                          gradient: _page == 0
                              ? LinearGradient(
                                  colors: [primaryColor, accentColor])
                              : null,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: FittedBox(
                            child: Text("free_server".tr(),
                                style: TextStyle(
                                    color: _page == 0
                                        ? Colors.white
                                        : Colors.black))),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      pageController.animateToPage(1,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                      setState(() {
                        _page = 1;
                      });
                    },
                    child: ClipPath(
                      clipper: RightButtonShape(),
                      child: InkWell(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: _page == 1
                                ? Colors.white
                                : Colors.black.withOpacity(.1),
                            gradient: _page == 1
                                ? LinearGradient(
                                    colors: [primaryColor, accentColor])
                                : null,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: FittedBox(
                              child: Text("pro_server".tr(),
                                  style: TextStyle(
                                      color: _page == 1
                                          ? Colors.white
                                          : Colors.black))),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (value) {
                setState(() {
                  _page = value;
                });
              },
              children: [
                ServersWidget(
                    type: 0,
                    key: Key("free"),
                    scrollController: widget.scrollController),
                ServersWidget(
                    type: 1,
                    key: Key("pro"),
                    scrollController: widget.scrollController),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void updateKeepAlive() {}

  @override
  bool get wantKeepAlive => true;
}

class ServersWidget extends StatefulWidget {
  final int? type;
  final ScrollController? scrollController;
  const ServersWidget({
    Key? key,
    this.type,
    this.scrollController,
  }) : super(key: key);

  @override
  _ServersWidgetState createState() => _ServersWidgetState();
}

class _ServersWidgetState extends State<ServersWidget>
    with KeepAliveParentDataMixin {
  int page = 1;
  List<VpnServer> listItem = [];

  bool _ready = false;

  RefreshController refreshController = RefreshController(initialRefresh: true);

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: refreshController,
      enablePullUp: true,
      onRefresh: () {
        loadData(reset: true);
        refreshController.refreshCompleted();
        setState(() {
          _ready = false;
        });
      },
      onLoading: () {
        loadData(reset: false);
      },
      child: listServerWidget(),
    );
  }

  Widget listServerWidget() {
    Map<String?, List<VpnServer>> data = {};
    for (var item in listItem) {
      if (data[item.country] != null) {
        data[item.country]!.add(item);
      } else {
        data[item.country] = [item];
      }
    }
    if (_ready) {
      if (data.length == 0) {
        return Container(
          height: 300,
          alignment: Alignment.center,
          child: Text("no_server_available".tr(), textAlign: TextAlign.center),
        );
      } else {
        return groupCountries
            ? _groupedCountriesWidget(data)
            : _countriesWidget();
      }
    } else {
      return Container(
        height: 300,
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
    }
  }

  ListView _countriesWidget() {
    return ListView.builder(
      itemCount: listItem.length,
      padding: EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (context, index) =>
          VpnServerButton(vpnServer: listItem[index]),
    );
  }

  ListView _groupedCountriesWidget(Map<String?, List<VpnServer>> data) {
    return ListView.builder(
      itemCount: data.keys.length,
      controller: widget.scrollController,
      padding: EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (context, index) {
        var item = data[data.keys.toList()[index]]!;
        bool isSelected = item
            .map((e) => e.id)
            .contains(VpnProvider.instance(context).vpnConfig?.id ?? 0);
        return Theme(
          data: ThemeData(dividerColor: Colors.transparent),
          child: CustomCard(
            margin: EdgeInsets.only(bottom: 10),
            child: ExpansionTile(
              title: Row(
                children: [
                  Expanded(
                      child: Text(item.first.country!.replaceAll("_", " "))),
                ],
              ),
              initiallyExpanded: isSelected,
              leading: Stack(
                children: [
                  CustomImage(
                    url: item.first.flag,
                    width: 30,
                    height: 30,
                  ),
                  isSelected
                      ? Positioned(
                          bottom: 0,
                          right: 0,
                          child: SizedBox(
                            height: 15,
                            width: 15,
                            child: CircleAvatar(
                              backgroundColor: primaryColor,
                              child: Icon(LineIcons.check,
                                  color: Colors.white, size: 12),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
              children: item
                  .map((e) => VpnServerButton(
                        vpnServer: e,
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  void loadData({bool reset = false}) async {
    if (reset) {
      if (mounted)
        setState(() {
          listItem.clear();
          page = 1;
          refreshController.resetNoData();
        });
    } else {
      page++;
    }
    var resp = await (widget.type == 0
        ? VpnServerHttp(context)
            .allFreeServer(page: showAllCountries ? null : page)
        : VpnServerHttp(context)
            .allProServer(page: showAllCountries ? null : page));
    refreshController.refreshCompleted();
    refreshController.loadComplete();

    if (resp == null || resp.length == 0) {
      return refreshController.loadNoData();
    }

    if (mounted)
      setState(() {
        _ready = true;
        listItem.addAll(resp);
      });

    if (showAllCountries) {
      refreshController.loadNoData();
    }
  }

  @override
  void detach() {}

  @override
  bool get keptAlive => true;
}

class VpnServerButton extends StatefulWidget {
  final VpnServer? vpnServer;

  VpnServerButton({Key? key, this.vpnServer}) : super(key: key);

  @override
  _VpnServerButtonState createState() => _VpnServerButtonState();
}

class _VpnServerButtonState extends State<VpnServerButton> {
  bool allowDisconnect = true;
  bool loading = false;
  bool fbpopuploaded = false;
  bool fbpopuperrored = false;
  bool fbpopupwaiting = false;
  bool fbBannerError = false;

  @override
  void initState() {
    super.initState();

    // print('fb ad:main starting');
    // fb.FacebookAudienceNetwork.init(
    //         // testingId: 'bb783c68-3722-4623-9373-5983c3301cec',

    //         )
    //     .then((value) => {
    //           print('fb ad:main started'),
    //           _loadInterstitialAd(),
    //         });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: _vpnButtonWidget(context),
    );
  }

  Widget _vpnButtonWidget(BuildContext context) {
    bool active = ((VpnProvider.instance(context).vpnConfig?.id ?? 0) ==
        widget.vpnServer!.id);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: TextButton(
        onPressed: () => _vpnSelectClick(context),
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(primaryColor.withOpacity(.4)),
          padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(vertical: 10, horizontal: 15)),
          backgroundColor: MaterialStateProperty.all(
              active ? primaryColor.withOpacity(.2) : Colors.transparent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                  color: active ? Colors.transparent : Colors.grey.shade200),
            ),
          ),
        ),
        child: Row(
          children: [
            widget.vpnServer?.flag == null
                ? SizedBox.shrink()
                : SizedBox(
                    height: 30,
                    width: 30,
                    child: (widget.vpnServer!.flag!
                            .toLowerCase()
                            .startsWith("http")
                        ? CustomImage(
                            url: widget.vpnServer!.flag,
                            fit: BoxFit.scaleDown,
                          )
                        : Image.asset(
                            "assets/icons/flags/${widget.vpnServer!.flag}.png",
                          )),
                  ),
            RowDivider(),
            Expanded(child: Text(widget.vpnServer?.name ?? "Select server...")),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: primaryColor,
              ),
              child: Text(
                (widget.vpnServer?.protocol ?? "UDP").toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            widget.vpnServer!.status == 1
                ? Container(
                    child: Image.asset(
                      "assets/icons/crown.png",
                      height: 30,
                      width: 30,
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  // --------------------------------
  // void _loadInterstitialAd() {
  //   print('fb ad:main loading');
  //   fb.FacebookInterstitialAd.loadInterstitialAd(
  //     // placementId: "YOUR_PLACEMENT_ID" 394187569408638_394188742741854,
  //     placementId: "498984975335393_498997422000815",
  //     listener: (result, value) {
  //       print('fb ad:main loaded');

  //       print('result-+++++++++++++--');

  //       print(result);
  //       print(value);
  //       print('result-+++++++++++++--');

  //       print(">>2 FAN > Interstitial Ad: $result --> $value");
  //       if (result == fb.InterstitialAdResult.LOADED) {
  //         fbpopuploaded = true;
  //       } else {
  //         fbpopuploaded = false;
  //       }

  //       if (result == fb.InterstitialAdResult.ERROR) {
  //         print('fb ad:main errored' + value.toString());

  //         fbpopuperrored = true;
  //       } else {
  //         fbpopuperrored = false;
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
  //   print('fb ad:main showing');

  //   fb.FacebookInterstitialAd.showInterstitialAd(delay: 500).then((value) => {
  //         print('fb ad:main showing value' + (value).toString()),
  //       });
  //   if (fbpopuploaded == true) {
  //     print('fb ad:main shown');
  //   } else {
  //     print('fb ad:main false');
  //     print("Interstial Ad not yet loaded!");
  //   }
  // }

  // Future<bool> tryGoogleAds() async {
  //   print('fb ad:main trying google now');
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

  //   if (fbpopuperrored) {
  //     tryGoogleAds();
  //     _loadInterstitialAd();
  //     return false;
  //   }

  //   print("fb ad:main tried to show");

  //   // setState(() {
  //   //   loading = true;
  //   // });

  //   _showInterstitialAd();
  //   await Future.delayed(Duration(seconds: 2));

  //   if (fbpopuploaded) {
  //     // _showInterstitialAd();
  //     await Future.delayed(Duration(seconds: 3));

  //     // setState(() {
  //     //   loading = true;
  //     // });
  //   } else {
  //     // setState(() {
  //     //   loading = true;
  //     // });
  //     _loadInterstitialAd();

  //     // wait 3 seconds for ad to load
  //     await Future.delayed(Duration(seconds: 3));
  //     if (fbpopuploaded) {
  //       _showInterstitialAd();

  //       await Future.delayed(Duration(seconds: 3));
  //       // setState(() {
  //       //   loading = false;
  //       // });
  //     } else {
  //       // setState(() {
  //       //   loading = false;
  //       // });
  //       await tryGoogleAds();
  //     }
  //   }
  //   return true;
  // }
  // ***********************************

  Future<bool> showInter(VpnProvider vpnProvider) async {
    if (!showAds) return false;
    if (vpnProvider.isPro) return false;

    var canLoadInter = await Appodeal.canShow(AppodealAdType.Interstitial);
    var loadedInter = await Appodeal.isLoaded(AppodealAdType.Interstitial);

    if (canLoadInter && loadedInter) {
      bool didShow =
          await Appodeal.show(AppodealAdType.Interstitial, 'servers list');

      return didShow;
    } else {
      return false;
    }
  }

  void _vpnSelectClick(BuildContext context, {bool force = false}) async {
    VpnProvider provider = VpnProvider.instance(context);
    // AdsProvider.instance(context).showAd3(context);

    await showInter(provider);

    if (widget.vpnServer!.status == 1 && !provider.isPro && !force) {
      return NAlertDialog(
        title: Text("not_allowed".tr()),
        content: Text("not_allowed_desc".tr()),
        actions: [
          TextButton(
            child: Text("go_premium".tr()),
            style: ButtonStyle(
                shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            )),
            onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => SubscriptionDetailScreen())),
          ),
        ],
      ).show(context);
    }
    VpnConfig? resp = await CustomProgressDialog.future(
      context,
      future: VpnServerHttp(context).detailVpn(widget.vpnServer!),
      dismissable: false,
      loadingWidget: Center(
        child: Container(
          height: 100,
          width: 100,
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
        ),
      ),
    );

    if (resp != null) {
      provider.vpnConfig = resp;
      if (provider.isConnected ?? false) NVPN.stopVpn();
      UIProvider.instance(context).sheetController.snapToPosition(
          SnappingPosition.factor(
              positionFactor: .13,
              grabbingContentOffset: GrabbingContentOffset.bottom));
    } else {
      NAlertDialog(
        title: Text("protocol_not_available_title".tr()),
        content: Text("protocol_not_available".tr()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _vpnSelectClick(context);
            },
            child: Text("force".tr()),
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("understand".tr()),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0))),
            ),
          )
        ],
      ).show(context);
    }
  }
}

class LeftButtonShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width - 30, size.height);
    path.lineTo(0, size.height);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class RightButtonShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(30, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
