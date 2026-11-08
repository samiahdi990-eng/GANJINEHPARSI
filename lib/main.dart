import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const dark = Color(0xFF102D2A);
const green = Color(0xFF24534A);
const gold = Color(0xFFD6B46A);
const cream = Color(0xFFF6F1E7);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadSavedPoets();
  runApp(const GanjinehApp());
}

class LiteraryItem {
  final String id;
  final String title;
  final String type;
  final String body;

  const LiteraryItem(this.id, this.title, this.type, this.body);
}

class Poet {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final String biography;
  final List<LiteraryItem> items;

  const Poet(
    this.id,
    this.name,
    this.description,
    this.emoji,
    this.biography,
    this.items,
  );
}

List<Poet> poets = <Poet>[
  Poet(
    'saadi',
    'سعدی شیرازی',
    'گلستان، بوستان و غزلیات',
    '🌹',
    'ابومحمد مصلح‌الدین سعدی شیرازی، از بزرگ‌ترین شاعران و نویسندگان زبان فارسی است. او در شیراز زاده شد و آثار ارزشمندی چون گلستان و بوستان از خود به یادگار گذاشت. آثار او سرشار از حکمت، اخلاق، تجربه زندگی و سخنان آموزنده است.',
    [
      LiteraryItem('s1', 'بنی‌آدم', 'شعر',
          'بنی‌آدم اعضای یک پیکرند\nکه در آفرینش ز یک گوهرند\n\nچو عضوی به درد آورد روزگار\nدگر عضوها را نماند قرار'),
      LiteraryItem('s2', 'درخت دوستی', 'شعر',
          'درخت دوستی بنشان که کام دل به بار آرد\nنهال دشمنی برکن که رنج بی‌شمار آرد'),
      LiteraryItem('s3', 'حکایت پادشاه و اسیر', 'داستان',
          'در گلستان سعدی حکایتی درباره پادشاهی آمده است که اسیری را به کشتن محکوم کرد. اسیر از شدت خشم سخنی تند گفت. وزیر مهربان، سخن او را به نیکی تعبیر کرد و پادشاه از کشتن او گذشت.\n\nپیام حکایت: مهربانی و خوش‌زبانی می‌تواند جان انسانی را نجات دهد.'),
      LiteraryItem('s4', 'گلستان', 'کتاب',
          'گلستان سعدی اثری منثور و منظوم است که در هشت باب تنظیم شده است؛ از سیرت پادشاهان تا آداب صحبت و تربیت.'),
      LiteraryItem('s5', 'بوستان', 'کتاب',
          'بوستان سعدی منظومه‌ای اخلاقی و تعلیمی است که درباره عدالت، احسان، عشق، تواضع و قناعت سخن می‌گوید.'),
      LiteraryItem('s6', 'حکمت سعدی', 'سخن',
          'تن آدمی شریف است به جان آدمیت\nنه همین لباس زیباست نشان آدمیت'),
    ],
  ),
  Poet(
    'rumi',
    'مولانا',
    'مثنوی معنوی و دیوان شمس',
    '🕊️',
    'جلال‌الدین محمد بلخی، مشهور به مولانا، شاعر و عارف بزرگ فارسی‌زبان است. او در بلخ زاده شد و بخش بزرگی از زندگی خود را در قونیه گذراند. مثنوی معنوی و دیوان شمس از مهم‌ترین آثار او هستند.',
    [
      LiteraryItem('r1', 'نی‌نامه', 'شعر',
          'بشنو از نی چون حکایت می‌کند\nوز جدایی‌ها شکایت می‌کند\n\nکز نیستان تا مرا ببریده‌اند\nاز نفیرم مرد و زن نالیده‌اند'),
      LiteraryItem('r2', 'این همه آوازها', 'شعر',
          'این همه آوازها از شه بود\nگرچه از حلقوم عبدالله بود'),
      LiteraryItem('r3', 'فیل در خانه تاریک', 'داستان',
          'در حکایتی از مثنوی، مردمی در اتاقی تاریک با فیلی روبه‌رو می‌شوند. هر کس با لمس بخشی از بدن فیل، تصور متفاوتی پیدا می‌کند؛ یکی آن را ستون و دیگری بادبزن می‌پندارد.\n\nپیام حکایت: شناخت محدود ما همیشه تمام حقیقت را نشان نمی‌دهد.'),
      LiteraryItem('r4', 'مثنوی معنوی', 'کتاب',
          'مثنوی معنوی مجموعه‌ای از شش دفتر شعر تعلیمی و عرفانی است که داستان‌ها، تمثیل‌ها و آموزه‌های اخلاقی و معنوی را در بر دارد.'),
      LiteraryItem('r5', 'دیوان شمس', 'کتاب',
          'دیوان شمس مجموعه غزل‌ها و رباعیات مولاناست که شور عشق، عرفان و تجربه‌های درونی را بیان می‌کند.'),
      LiteraryItem('r6', 'سخن مولانا', 'سخن',
          'دیروز عاقل بودم و می‌خواستم دنیا را تغییر دهم؛ امروز دانا شده‌ام و خودم را تغییر می‌دهم.'),
    ],
  ),
  Poet(
    'hafez',
    'حافظ شیرازی',
    'غزلیات و فال حافظ',
    '🌙',
    'خواجه شمس‌الدین محمد حافظ شیرازی، غزل‌سرای نامدار فارسی است. دیوان او از برجسته‌ترین آثار غنایی ادبیات فارسی به شمار می‌رود. شعر حافظ از عشق، عرفان، رندی، امید و نقد ریا سخن می‌گوید.',
    [
      LiteraryItem('h1', 'الا یا ایها الساقی', 'شعر',
          'الا یا ایها الساقی ادر کأساً و ناولها\nکه عشق آسان نمود اول ولی افتاد مشکل‌ها\n\nبه بوی نافه‌ای کآخر صبا زان طره بگشاید\nز تاب جعد مشکینش چه خون افتاد در دل‌ها'),
      LiteraryItem('h2', 'اگر آن ترک شیرازی', 'شعر',
          'اگر آن ترک شیرازی به دست آرد دل ما را\nبه خال هندویش بخشم سمرقند و بخارا را'),
      LiteraryItem('h3', 'حافظ و غزل', 'داستان',
          'غزل‌های حافظ در طول قرن‌ها در میان مردم فارسی‌زبان خوانده شده‌اند. دیوان او در بسیاری از خانه‌ها جایگاه ویژه‌ای دارد و مردم برای تفأل و یافتن آرامش به آن رجوع می‌کنند.\n\nنکته: روایت‌های عامیانه درباره زندگی حافظ همیشه سند تاریخی قطعی ندارند.'),
      LiteraryItem('h4', 'دیوان حافظ', 'کتاب',
          'دیوان حافظ شامل غزل‌ها و دیگر قالب‌های شعری منسوب به اوست. نسخه‌ها و ترتیب غزل‌ها در چاپ‌های مختلف تفاوت‌هایی دارند.'),
      LiteraryItem('h5', 'سخن حافظ', 'سخن',
          'آسایش دو گیتی تفسیر این دو حرف است\nبا دوستان مروت با دشمنان مدارا'),
    ],
  ),
  Poet(
    'ferdowsi',
    'فردوسی',
    'شاهنامه و داستان‌های حماسی',
    '⚔️',
    'ابوالقاسم فردوسی توسی، شاعر بزرگ حماسه‌سرای فارسی است. شاهنامه اثر ماندگار اوست که تاریخ اسطوره‌ای و پهلوانی ایران را در قالب شعر روایت می‌کند. فردوسی نقش بزرگی در پاسداری از زبان فارسی داشته است.',
    [
      LiteraryItem('f1', 'آغاز شاهنامه', 'شعر',
          'به نام خداوند جان و خرد\nکزین برتر اندیشه برنگذرد\n\nخداوند نام و خداوند جای\nخداوند روزی‌ده رهنمای'),
      LiteraryItem('f2', 'توانا بود هر که دانا بود', 'شعر',
          'توانا بود هر که دانا بود\nز دانش دل پیر برنا بود'),
      LiteraryItem('f3', 'رستم و سهراب', 'داستان',
          'رستم و سهراب از مشهورترین داستان‌های شاهنامه است. رستم بدون آنکه بداند، در میدان نبرد با پسر خود سهراب روبه‌رو می‌شود. سرانجام سهراب زخمی می‌شود و حقیقت دیر آشکار می‌گردد.\n\nپیام داستان: ناآگاهی، شتاب و جنگ می‌تواند فاجعه‌ای جبران‌ناپذیر بیافریند.'),
      LiteraryItem('f4', 'داستان سیاوش', 'داستان',
          'سیاوش، شاهزاده‌ای پاک‌دامن، برای اثبات بی‌گناهی خود از میان آتش می‌گذرد. پس از آن به توران می‌رود، اما سرانجام قربانی دسیسه و بدگمانی می‌شود.\n\nپیام داستان: پاک‌دامنی همیشه از آسیب بدخواهان در امان نیست.'),
      LiteraryItem('f5', 'داستان ضحاک', 'داستان',
          'ضحاک با فریب اهریمن به پادشاهی ستمگر تبدیل می‌شود. کاوه آهنگر در برابر بیداد او قیام می‌کند و فریدون با یاری مردم بر ضحاک پیروز می‌شود.\n\nپیام داستان: اتحاد مردم در برابر ستم اهمیت دارد.'),
      LiteraryItem('f6', 'شاهنامه', 'کتاب',
          'شاهنامه منظومه‌ای بزرگ درباره پادشاهان، پهلوانان، اسطوره‌ها و تاریخ روایی ایران است. این اثر از سه بخش اسطوره‌ای، پهلوانی و تاریخی تشکیل می‌شود.'),
    ],
  ),
  Poet(
    'khayyam',
    'خیام نیشابوری',
    'رباعیات و اندیشه‌ها',
    '📜',
    'عمر خیام نیشابوری، دانشمند، ریاضی‌دان، ستاره‌شناس و شاعر ایرانی بود. رباعیات منسوب به او درباره گذر عمر، راز هستی، شادی، پرسش‌های فلسفی و ناپایداری جهان سخن می‌گویند. درباره انتساب برخی رباعیات اختلاف نظر وجود دارد.',
    [
      LiteraryItem('k1', 'ابر آمد و باز', 'شعر',
          'ابر آمد و باز بر سر سبزه گریست\nبی باده گلرنگ نمی‌باید زیست\n\nاین سبزه که امروز تماشاگه ماست\nتا سبزه خاک ما تماشاگه کیست'),
      LiteraryItem('k2', 'اسرار ازل', 'شعر',
          'اسرار ازل را نه تو دانی و نه من\nوین حرف معما نه تو خوانی و نه من\n\nهست از پس پرده گفت‌وگوی من و تو\nچون پرده برافتد نه تو مانی و نه من'),
      LiteraryItem('k3', 'اندیشه درباره زمان', 'داستان',
          'رباعیات خیام بارها خواننده را به اندیشیدن درباره کوتاهی عمر و ارزش لحظه‌های زندگی دعوت می‌کنند. در این نگاه، انسان باید قدر فرصت زندگی را بداند.\n\nاین بخش توضیحی درباره اندیشه‌های شعر اوست، نه یک حکایت تاریخی مستند.'),
      LiteraryItem('k4', 'رباعیات خیام', 'کتاب',
          'رباعیات منسوب به خیام در نسخه‌ها و گردآوری‌های مختلف تعداد و ترتیب یکسانی ندارند. برای شناخت دقیق‌تر باید به تصحیح‌های معتبر مراجعه کرد.'),
      LiteraryItem('k5', 'سخن خیام', 'سخن',
          'چون عاقبت کار جهان نیستی است\nانگار که نیستی، چو هستی خوش باش'),
    ],
  ),
];

class GanjinehApp extends StatelessWidget {
  const GanjinehApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'گنجینه پارسی',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(seedColor: dark),
        appBarTheme: const AppBarTheme(
          backgroundColor: dark,
          foregroundColor: gold,
          centerTitle: true,
        ),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int tab = 0;
  int refreshNumber = 0;

  final titles = ['گنجینه پارسی', 'جست‌وجو', 'علاقه‌مندی‌ها'];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(titles[tab],
              style: const TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              tooltip: 'پنل مدیریت خصوصی',
              icon: const Icon(Icons.admin_panel_settings),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminLoginScreen(),
                  ),
                );
                if (mounted) {
                  setState(() => refreshNumber++);
                }
              },
            ),
          ],
        ),
        body: IndexedStack(
          index: tab,
          children: [
            HomeScreen(key: ValueKey('home-$refreshNumber')),
            SearchScreen(key: ValueKey('search-$refreshNumber')),
            FavoritesScreen(key: ValueKey('fav-$refreshNumber')),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          backgroundColor: dark,
          indicatorColor: gold.withValues(alpha: 0.2),
          selectedIndex: tab,
          onDestinationSelected: (v) => setState(() => tab = v),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Colors.white70),
              selectedIcon: Icon(Icons.home, color: gold),
              label: 'خانه',
            ),
            NavigationDestination(
              icon: Icon(Icons.search, color: Colors.white70),
              selectedIcon: Icon(Icons.search, color: gold),
              label: 'جست‌وجو',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border, color: Colors.white70),
              selectedIcon: Icon(Icons.favorite, color: gold),
              label: 'علاقه‌ها',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [dark, green]),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: gold, width: 1.5),
          ),
          child: const Column(
            children: [
              Text('📚', style: TextStyle(fontSize: 48)),
              SizedBox(height: 12),
              Text('به گنجینه پارسی خوش آمدید',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: gold, fontSize: 22,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('خانه شعر، ادب، حکمت و داستان‌های فارسی',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Text('شهر شاعران پارسی',
            style: TextStyle(
                color: dark, fontSize: 21, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...poets.map((poet) => Card(
              color: Colors.white,
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(14),
                leading: CircleAvatar(
                  radius: 29,
                  backgroundColor: dark,
                  child: Text(poet.emoji,
                      style: const TextStyle(fontSize: 26)),
                ),
                title: Text(poet.name,
                    style: const TextStyle(
                        color: dark, fontWeight: FontWeight.bold)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(poet.description),
                ),
                trailing: const Icon(Icons.chevron_left, color: gold),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PoetScreen(poet: poet)),
                ),
              ),
            )),
        Card(
          color: const Color(0xFFFFF8E8),
          child: ListTile(
            leading: const Text('🌙', style: TextStyle(fontSize: 30)),
            title: const Text('فال حافظ',
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('یک غزل از حافظ به نیت خود انتخاب کن'),
            trailing: const Icon(Icons.arrow_back, color: dark),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FortuneScreen()),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Center(
          child: Text('شعر • ادب • حکمت • فرهنگ',
              style: TextStyle(color: dark, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

class PoetScreen extends StatelessWidget {
  final Poet poet;
  const PoetScreen({super.key, required this.poet});

  @override
  Widget build(BuildContext context) {
    final types = poet.items.map((e) => e.type).toSet().toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(poet.name)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: dark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: gold),
              ),
              child: Column(
                children: [
                  Text(poet.emoji, style: const TextStyle(fontSize: 55)),
                  const SizedBox(height: 10),
                  Text(poet.name,
                      style: const TextStyle(
                          color: gold, fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(poet.biography,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                          color: Colors.white, height: 1.9)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('گنجینه آثار',
                style: TextStyle(
                    color: dark, fontSize: 21, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...types.map((type) {
              final list = poet.items.where((e) => e.type == type).toList();
              return Card(
                color: Colors.white,
                child: ExpansionTile(
                  leading: Icon(_typeIcon(type), color: gold),
                  title: Text(type,
                      style: const TextStyle(
                          color: dark, fontWeight: FontWeight.bold)),
                  subtitle: Text('${list.length} مطلب'),
                  children: list.map((item) => ListTile(
                    title: Text(item.title),
                    trailing: const Icon(Icons.chevron_left, color: gold),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DetailScreen(
                              poet: poet, item: item)),
                    ),
                  )).toList(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

IconData _typeIcon(String type) {
  switch (type) {
    case 'شعر':
      return Icons.auto_stories;
    case 'داستان':
      return Icons.menu_book;
    case 'کتاب':
      return Icons.book;
    default:
      return Icons.format_quote;
  }
}

class DetailScreen extends StatefulWidget {
  final Poet poet;
  final LiteraryItem item;

  const DetailScreen({super.key, required this.poet, required this.item});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool favorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  Future<void> _loadFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => favorite =
        (prefs.getStringList('favorites') ?? []).contains(widget.item.id));
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('favorites') ?? [];
    if (list.contains(widget.item.id)) {
      list.remove(widget.item.id);
    } else {
      list.add(widget.item.id);
    }
    await prefs.setStringList('favorites', list);
    if (mounted) setState(() => favorite = list.contains(widget.item.id));
  }

  Future<void> _copyText() async {
    await Clipboard.setData(ClipboardData(
        text: '${widget.item.title}\n${widget.item.body}\n— ${widget.poet.name}'));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('متن کپی شد')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.item.title),
          actions: [
            IconButton(
              onPressed: _toggleFavorite,
              icon: Icon(favorite ? Icons.favorite : Icons.favorite_border,
                  color: favorite ? Colors.redAccent : gold),
            ),
            IconButton(onPressed: _copyText, icon: const Icon(Icons.copy)),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(widget.poet.emoji,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(widget.item.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: dark, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('${widget.poet.name} • ${widget.item.type}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: green)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: gold.withValues(alpha: 0.6)),
              ),
              child: SelectableText(
                widget.item.body,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                    color: dark, fontSize: 19, height: 2.1),
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: dark),
              onPressed: _copyText,
              icon: const Icon(Icons.copy),
              label: const Text('کپی متن'),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final results = <MapEntry<Poet, LiteraryItem>>[];
    for (final poet in poets) {
      for (final item in poet.items) {
        if (query.isNotEmpty &&
            ('${poet.name} ${item.title} ${item.body} ${item.type}')
                .contains(query)) {
          results.add(MapEntry(poet, item));
        }
      }
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          textDirection: TextDirection.rtl,
          onChanged: (v) => setState(() => query = v.trim()),
          decoration: InputDecoration(
            hintText: 'نام شاعر، شعر، کتاب یا داستان را بنویس...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 16),
        if (query.isEmpty)
          const Text('برای جست‌وجو، یک کلمه یا نام شاعر وارد کن.')
        else if (results.isEmpty)
          const Text('نتیجه‌ای پیدا نشد.')
        else
          ...results.map((result) => Card(
                color: Colors.white,
                child: ListTile(
                  title: Text(result.value.title),
                  subtitle: Text(
                      '${result.key.name} • ${result.value.type}'),
                  trailing: const Icon(Icons.chevron_left, color: gold),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DetailScreen(
                            poet: result.key, item: result.value)),
                  ),
                ),
              )),
      ],
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final ids = snapshot.data!.getStringList('favorites') ?? [];
        final results = <MapEntry<Poet, LiteraryItem>>[];
        for (final poet in poets) {
          for (final item in poet.items) {
            if (ids.contains(item.id)) {
              results.add(MapEntry(poet, item));
            }
          }
        }

        if (results.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite_border, size: 65, color: gold),
                SizedBox(height: 12),
                Text('هنوز چیزی ذخیره نکرده‌ای',
                    style: TextStyle(color: dark, fontSize: 17)),
                Text('با زدن قلب کنار شعر یا داستان، آن را اینجا نگه دار.'),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: results.map((result) => Card(
                color: Colors.white,
                child: ListTile(
                  title: Text(result.value.title),
                  subtitle: Text(result.key.name),
                  trailing: const Icon(Icons.favorite, color: Colors.red),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DetailScreen(
                            poet: result.key, item: result.value)),
                  ),
                ),
              )).toList(),
        );
      },
    );
  }
}

class FortuneScreen extends StatelessWidget {
  const FortuneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final poems = poets
        .firstWhere((p) => p.id == 'hafez')
        .items
        .where((e) => e.type == 'شعر')
        .toList();
    final poem = poems[Random().nextInt(poems.length)];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('فال حافظ')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🌙', style: TextStyle(fontSize: 55)),
                    const Text('فال حافظ شما',
                        style: TextStyle(
                            color: dark, fontSize: 23,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Text(poem.title,
                        style: const TextStyle(
                            color: green, fontSize: 19,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 14),
                    SelectableText(poem.body,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: dark, fontSize: 19, height: 2)),
                    const SizedBox(height: 20),
                    const Text(
                      'این انتخاب تصادفی از شعرهای موجود در برنامه است؛ تعبیر سنتی فال به آن اضافه نشده است.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: dark),
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const FortuneScreen()),
                      ),
                      child: const Text('فال تازه بگیر'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// ---------------- ذخیره‌سازی محلی گنجینه ----------------

const String poetsStorageKey = 'ganjineh_saved_poets_v1';
const String adminPasswordKey = 'ganjineh_private_admin_password';

Map<String, dynamic> poetToMap(Poet p) => {
  'id': p.id,
  'name': p.name,
  'description': p.description,
  'emoji': p.emoji,
  'biography': p.biography,
  'items': p.items.map((e) => {
    'id': e.id,
    'title': e.title,
    'type': e.type,
    'body': e.body,
  }).toList(),
};

Poet poetFromMap(Map<String, dynamic> m) => Poet(
  m['id']?.toString() ?? '',
  m['name']?.toString() ?? '',
  m['description']?.toString() ?? '',
  m['emoji']?.toString() ?? '📚',
  m['biography']?.toString() ?? '',
  ((m['items'] as List?) ?? []).map((e) {
    final x = Map<String, dynamic>.from(e as Map);
    return LiteraryItem(
      x['id']?.toString() ?? '',
      x['title']?.toString() ?? '',
      x['type']?.toString() ?? 'شعر',
      x['body']?.toString() ?? '',
    );
  }).toList(),
);

Future<void> savePoets() async {
  final prefs = await SharedPreferences.getInstance();
  final data = poets.map(poetToMap).toList();
  await prefs.setString(poetsStorageKey, jsonEncode(data));
}

Future<void> loadSavedPoets() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(poetsStorageKey);
  if (raw == null || raw.isEmpty) return;

  try {
    final decoded = jsonDecode(raw) as List;
    poets = decoded
        .map((e) => poetFromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  } catch (_) {
    // اگر نسخه پشتیبان خراب بود، اطلاعات اولیه حفظ می‌شود.
  }
}

// ---------------- ورود مدیر خصوصی ----------------

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  bool firstSetup = false;
  bool loading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    checkPassword();
  }

  Future<void> checkPassword() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      firstSetup = !prefs.containsKey(adminPasswordKey);
      loading = false;
    });
  }

  Future<void> enter() async {
    final password = passwordController.text.trim();
    if (password.length < 6) {
      setState(() => error = 'رمز باید حداقل ۶ حرف یا عدد باشد.');
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    if (firstSetup) {
      if (password != confirmController.text.trim()) {
        setState(() => error = 'تکرار رمز با رمز اول یکسان نیست.');
        return;
      }
      await prefs.setString(adminPasswordKey, password);
    } else {
      if (password != prefs.getString(adminPasswordKey)) {
        setState(() => error = 'رمز ورود اشتباه است.');
        return;
      }
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AdminDashboard()),
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('ورود مدیر خصوصی')),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(22),
                children: [
                  const SizedBox(height: 35),
                  const Icon(Icons.shield, size: 75, color: gold),
                  const SizedBox(height: 18),
                  Text(
                    firstSetup ? 'ساخت رمز مدیر' : 'ورود به مدیریت',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: dark,
                    ),
                  ),
                  const SizedBox(height: 22),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'رمز مدیر',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (firstSetup) ...[
                    const SizedBox(height: 14),
                    TextField(
                      controller: confirmController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'تکرار رمز مدیر',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  if (error.isNotEmpty)
                    Text(error, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: dark,
                      padding: const EdgeInsets.all(15),
                    ),
                    onPressed: enter,
                    child: Text(firstSetup ? 'ثبت رمز و ورود' : 'ورود امن'),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'رمز فقط در حافظه محلی این نصب برنامه ذخیره می‌شود. '
                    'برای امنیت بیشتر، رمز را با کسی به اشتراک نگذار.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
      ),
    );
  }
}

// ---------------- پنل مدیریت ----------------

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Future<void> refresh() async {
    await savePoets();
    if (mounted) setState(() {});
  }

  Future<void> addPoet() async {
    final result = await showPoetEditor(context);
    if (result == null) return;

    final id = 'custom_${DateTime.now().microsecondsSinceEpoch}';
    poets.add(Poet(
      id,
      result['name']!,
      result['description']!,
      result['emoji']!,
      result['biography']!,
      [],
    ));
    await refresh();
  }

  Future<void> editPoet(int index) async {
    final old = poets[index];
    final result = await showPoetEditor(context, poet: old);
    if (result == null) return;

    poets[index] = Poet(
      old.id,
      result['name']!,
      result['description']!,
      result['emoji']!,
      result['biography']!,
      old.items,
    );
    await refresh();
  }

  Future<void> deletePoet(int index) async {
    final ok = await confirmDelete(context, 'این شاعر و تمام آثارش حذف شود؟');
    if (!ok) return;
    poets.removeAt(index);
    await refresh();
  }

  Future<void> addItem(int index) async {
    final result = await showItemEditor(context);
    if (result == null) return;
    final old = poets[index];
    final items = [...old.items];
    items.add(LiteraryItem(
      'custom_${DateTime.now().microsecondsSinceEpoch}',
      result['title']!,
      result['type']!,
      result['body']!,
    ));
    poets[index] = Poet(
      old.id, old.name, old.description, old.emoji, old.biography, items,
    );
    await refresh();
  }

  Future<void> editItem(int poetIndex, int itemIndex) async {
    final oldPoet = poets[poetIndex];
    final oldItem = oldPoet.items[itemIndex];
    final result = await showItemEditor(context, item: oldItem);
    if (result == null) return;

    final items = [...oldPoet.items];
    items[itemIndex] = LiteraryItem(
      oldItem.id,
      result['title']!,
      result['type']!,
      result['body']!,
    );
    poets[poetIndex] = Poet(
      oldPoet.id, oldPoet.name, oldPoet.description,
      oldPoet.emoji, oldPoet.biography, items,
    );
    await refresh();
  }

  Future<void> deleteItem(int poetIndex, int itemIndex) async {
    final ok = await confirmDelete(context, 'این شعر یا مطلب حذف شود؟');
    if (!ok) return;
    final old = poets[poetIndex];
    final items = [...old.items]..removeAt(itemIndex);
    poets[poetIndex] = Poet(
      old.id, old.name, old.description, old.emoji, old.biography, items,
    );
    await refresh();
  }

  Future<void> backup() async {
    final data = jsonEncode(poets.map(poetToMap).toList());
    await Clipboard.setData(ClipboardData(text: data));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('نسخه پشتیبان کپی شد؛ آن را در فایل متنی ذخیره کن.')),
    );
  }

  Future<void> restore() async {
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('بازیابی نسخه پشتیبان'),
        content: TextField(
          controller: controller,
          maxLines: 8,
          decoration: const InputDecoration(
            hintText: 'متن JSON نسخه پشتیبان را اینجا وارد کن',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('انصراف'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('بازیابی'),
          ),
        ],
      ),
    );

    if (ok != true) {
      controller.dispose();
      return;
    }

    try {
      final decoded = jsonDecode(controller.text) as List;
      final restored = decoded.map((e) =>
        poetFromMap(Map<String, dynamic>.from(e as Map))).toList();
      if (restored.isEmpty) throw const FormatException();
      poets = restored;
      await refresh();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('اطلاعات با موفقیت بازیابی شد.')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فایل پشتیبان معتبر نیست.')),
        );
      }
    } finally {
      controller.dispose();
    }
  }

  Future<void> settings() async {
    final prefs = await SharedPreferences.getInstance();
    final controller = TextEditingController(
      text: prefs.getString(adminPasswordKey) ?? '',
    );
    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تنظیمات امنیتی'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('تغییر رمز ورود پنل مدیریت'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'رمز جدید (حداقل ۶ کاراکتر)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('انصراف'),
          ),
          FilledButton(
            onPressed: () async {
              final value = controller.text.trim();
              if (value.length < 6) return;
              await prefs.setString(adminPasswordKey, value);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('ذخیره رمز'),
          ),
        ],
      ),
    );
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = poets.fold<int>(0, (sum, p) => sum + p.items.length);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('پنل مدیریت گنجینه')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [dark, green]),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: gold),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _AdminStat(title: 'شاعران', value: '${poets.length}'),
                  _AdminStat(title: 'مطالب', value: '$totalItems'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: dark),
              onPressed: addPoet,
              icon: const Icon(Icons.person_add),
              label: const Text('افزودن شاعر جدید'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: backup,
              icon: const Icon(Icons.backup),
              label: const Text('تهیه نسخه پشتیبان'),
            ),
            OutlinedButton.icon(
              onPressed: restore,
              icon: const Icon(Icons.restore),
              label: const Text('بازیابی نسخه پشتیبان'),
            ),
            OutlinedButton.icon(
              onPressed: settings,
              icon: const Icon(Icons.settings),
              label: const Text('تنظیمات و تغییر رمز مدیر'),
            ),
            const SizedBox(height: 18),
            const Text(
              'مدیریت شاعران و آثار',
              style: TextStyle(
                color: dark, fontSize: 20, fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(poets.length, (index) {
              final poet = poets[index];
              return Card(
                color: Colors.white,
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: dark,
                    child: Text(poet.emoji),
                  ),
                  title: Text(
                    poet.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${poet.items.length} مطلب'),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit, color: green),
                      title: const Text('ویرایش مشخصات شاعر'),
                      onTap: () => editPoet(index),
                    ),
                    ListTile(
                      leading: const Icon(Icons.add, color: green),
                      title: const Text('افزودن شعر یا مطلب'),
                      onTap: () => addItem(index),
                    ),
                    ...List.generate(poet.items.length, (itemIndex) {
                      final item = poet.items[itemIndex];
                      return ListTile(
                        title: Text(item.title),
                        subtitle: Text(item.type),
                        leading: const Icon(Icons.menu_book, color: gold),
                        trailing: Wrap(
                          spacing: 0,
                          children: [
                            IconButton(
                              tooltip: 'ویرایش',
                              icon: const Icon(Icons.edit, color: green),
                              onPressed: () => editItem(index, itemIndex),
                            ),
                            IconButton(
                              tooltip: 'حذف',
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteItem(index, itemIndex),
                            ),
                          ],
                        ),
                      );
                    }),
                    ListTile(
                      leading: const Icon(Icons.delete_forever, color: Colors.red),
                      title: const Text(
                        'حذف کامل شاعر',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () => deletePoet(index),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _AdminStat extends StatelessWidget {
  final String title;
  final String value;
  const _AdminStat({required this.title, required this.value});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(value, style: const TextStyle(
        color: gold, fontSize: 25, fontWeight: FontWeight.bold,
      )),
      Text(title, style: const TextStyle(color: Colors.white)),
    ],
  );
}

// ---------------- فرم‌های افزودن و ویرایش ----------------

Future<bool> confirmDelete(BuildContext context, String message) async {
  return await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('تأیید حذف'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('بازگشت'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('حذف'),
        ),
      ],
    ),
  ) ?? false;
}

Future<Map<String, String>?> showPoetEditor(
  BuildContext context, {Poet? poet}
) async {
  final name = TextEditingController(text: poet?.name ?? '');
  final description = TextEditingController(text: poet?.description ?? '');
  final emoji = TextEditingController(text: poet?.emoji ?? '📚');
  final biography = TextEditingController(text: poet?.biography ?? '');

  final result = await showDialog<Map<String, String>>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(poet == null ? 'افزودن شاعر' : 'ویرایش شاعر'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: name, decoration: const InputDecoration(labelText: 'نام شاعر')),
              TextField(controller: description, decoration: const InputDecoration(labelText: 'توضیح کوتاه')),
              TextField(controller: emoji, decoration: const InputDecoration(labelText: 'نماد یا ایموجی')),
              TextField(
                controller: biography,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'زندگی‌نامه'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('انصراف'),
        ),
        FilledButton(
          onPressed: () {
            if (name.text.trim().isEmpty) return;
            Navigator.pop(ctx, {
              'name': name.text.trim(),
              'description': description.text.trim(),
              'emoji': emoji.text.trim().isEmpty ? '📚' : emoji.text.trim(),
              'biography': biography.text.trim(),
            });
          },
          child: const Text('ذخیره'),
        ),
      ],
    ),
  );

  name.dispose();
  description.dispose();
  emoji.dispose();
  biography.dispose();
  return result;
}

Future<Map<String, String>?> showItemEditor(
  BuildContext context, {LiteraryItem? item}
) async {
  final title = TextEditingController(text: item?.title ?? '');
  final body = TextEditingController(text: item?.body ?? '');
  String type = item?.type ?? 'شعر';

  final result = await showDialog<Map<String, String>>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setDialogState) => AlertDialog(
        title: Text(item == null ? 'افزودن مطلب' : 'ویرایش مطلب'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: title, decoration: const InputDecoration(labelText: 'عنوان')),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: type,
                  decoration: const InputDecoration(labelText: 'نوع مطلب'),
                  items: const ['شعر', 'داستان', 'کتاب', 'سخن', 'قصیده', 'غزل', 'رباعی']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setDialogState(() => type = v);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: body,
                  maxLines: 9,
                  decoration: const InputDecoration(
                    labelText: 'متن کامل',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('انصراف'),
          ),
          FilledButton(
            onPressed: () {
              if (title.text.trim().isEmpty || body.text.trim().isEmpty) return;
              Navigator.pop(ctx, {
                'title': title.text.trim(),
                'type': type,
                'body': body.text.trim(),
              });
            },
            child: const Text('ذخیره'),
          ),
        ],
      ),
    ),
  );

  title.dispose();
  body.dispose();
  return result;
}
