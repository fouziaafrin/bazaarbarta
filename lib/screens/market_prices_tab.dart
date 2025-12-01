import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';
import '../services/firestore_service.dart';
import '../services/cache_service.dart';
import '../services/network_service.dart';
import '../screens/marketplace_screen.dart';
import '../widgets/crop_card.dart';

class MarketPricesTab extends StatefulWidget {
  const MarketPricesTab({super.key});

  @override
  State<MarketPricesTab> createState() => _MarketPricesTabState();
}

class _MarketPricesTabState extends State<MarketPricesTab> {
  List<Map<String, dynamic>>? cachedData;
  bool offline = false;
  int? lastUpdated;

  @override
  void initState() {
    super.initState();
    loadCached();
    loadOnlineData();
  }

  Future<void> loadCached() async {
    cachedData = await CacheService().loadCrops();
    lastUpdated = await CacheService().getLastUpdated();
    setState(() {});
  }

  Future<void> manualRefresh() async {
    final online = await NetworkService.isOnline();
    if (!online) {
      offline = true;
      setState(() {});
      return;
    }
    final crops = await FirestoreService().getLatestCrops();
    await CacheService().saveCrops(crops);
    cachedData = crops;
    offline = false;
    lastUpdated = DateTime.now().millisecondsSinceEpoch;
    setState(() {});
  }

  Future<void> loadOnlineData() async {
    final online = await NetworkService.isOnline();
    if (!online) {
      offline = true;
      setState(() {});
      return;
    }

    FirestoreService().getCropsStream().listen((crops) async {
      await CacheService().saveCrops(crops);
      cachedData = crops;
      offline = false;
      lastUpdated = DateTime.now().millisecondsSinceEpoch;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageService>().lang;
    final t = context.watch<LanguageService>().text;

    return Scaffold(
      appBar: AppBar(
        title: Text(t['marketPrices']!),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) => context.read<LanguageService>().switchLang(v),
            itemBuilder: (context) => [
              PopupMenuItem(value: "en", child: Text(t['english']!)),
              PopupMenuItem(value: "bn", child: Text(t['bangla']!)),
            ],
          ),
        ],
      ),
      body: cachedData == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (offline)
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.red.shade300,
                    child: Text(t['offlineMode']!, style: const TextStyle(color: Colors.white)),
                  ),
                if (lastUpdated != null)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text("${t['lastUpdated']}: ${DateTime.fromMillisecondsSinceEpoch(lastUpdated!).toLocal()}"),
                  ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: manualRefresh,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: cachedData!.length,
                      itemBuilder: (_, i) {
                        final c = cachedData![i];
                        return CropCard(
                          name: lang == "en" ? c['name_en'] : c['name_bn'],
                          price: "${c['price']} ৳",
                          unit: "per ${c['unit']}",
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
