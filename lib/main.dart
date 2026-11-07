import 'package:flutter/material.dart';

void main() {
  runApp(const GanjinehApp());
}

const gold = Color(0xFFD6B46A);
const dark = Color(0xFF102D2A);
const background = Color(0xFFF6F1E7);

class GanjinehApp extends StatelessWidget {
  const GanjinehApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'گنجینه پارسی',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: dark,
          primary: dark,
          secondary: gold,
        ),
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final poets = const [
    Poet('سعدی شیرازی', 'گلستان، بوستان و غزلیات', '🌹'),
    Poet('مولانا', 'مثنوی معنوی و دیوان شمس', '🕊️'),
    Poet('حافظ شیرازی', 'غزلیات و فال حافظ', '🌙'),
    Poet('فردوسی', 'شاهنامه و داستان‌های حماسی', '⚔️'),
    Poet('خیام نیشابوری', 'رباعیات و اندیشه‌ها', '📜'),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: dark,
          foregroundColor: gold,
          centerTitle: true,
          title: const Text(
            'گنجینه پارسی',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [dark, Color(0xFF24534A)],
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: gold, width: 1.5),
              ),
              child: const Column(
                children: [
                  Text('📚', style: TextStyle(fontSize: 48)),
                  SizedBox(height: 10),
                  Text(
                    'به گنجینه پارسی خوش آمدید',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: gold,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'سفری به دنیای شعر، ادب، حکمت و فرهنگ',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'شهر شاعران پارسی',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: dark,
              ),
            ),
            const SizedBox(height: 12),
            ...poets.map(
              (poet) => Card(
                color: Colors.white,
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    radius: 27,
                    backgroundColor: dark,
                    child: Text(
                      poet.emoji,
                      style: const TextStyle(fontSize: 25),
                    ),
                  ),
                  title: Text(
                    poet.name,
                    style: const TextStyle(
                      color: dark,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(poet.description),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: gold,
                    size: 18,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PoetPage(poet: poet),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'شعر • ادب • حکمت • فرهنگ',
                style: TextStyle(color: dark, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: dark,
          selectedItemColor: gold,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'خانه',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'علاقه‌مندی‌ها',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'کتابخانه',
            ),
          ],
        ),
      ),
    );
  }
}

class Poet {
  final String name;
  final String description;
  final String emoji;

  const Poet(this.name, this.description, this.emoji);
}

class PoetPage extends StatelessWidget {
  final Poet poet;

  const PoetPage({super.key, required this.poet});

  @override
  Widget build(BuildContext context) {
    final sections = [
      'زندگینامه',
      'کتاب‌ها و آثار',
      'شعرها و غزل‌ها',
      'حکایت‌ها و داستان‌ها',
      'معنی و تفسیر اشعار',
      'سخنان معروف',
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: dark,
          foregroundColor: gold,
          title: Text(poet.name),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              poet.emoji,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 65),
            ),
            const SizedBox(height: 12),
            Text(
              'به شهر ${poet.name} خوش آمدید',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 21,
                color: dark,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...sections.map(
              (section) => Card(
                child: ListTile(
                  leading: const Icon(Icons.menu_book, color: dark),
                  title: Text(section),
                  trailing: const Icon(Icons.chevron_left),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('بخش $section به‌زودی تکمیل می‌شود')),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
