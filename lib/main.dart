import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(SnakeTarazApp());
}

class SnakeTarazApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Змейка Тараза',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/game': (context) => GameScreen(),
        '/scores': (context) => ScoresScreen(),
        '/profile': (context) => ProfileScreen(),
        '/about': (context) => AboutScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[700]!, Colors.yellow[700]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('🐍', style: TextStyle(fontSize: 100)),
              Text(
                'Змейка Тараза',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'ЖИХЦ Тараз 🇰🇿',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              SizedBox(height: 30),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController(
    text: "student@jihc.taraz.kz",
  );
  TextEditingController pass = TextEditingController(text: "123456");
  bool loading = false;

  void login() async {
    setState(() => loading = true);
    await Future.delayed(Duration(seconds: 1)); // имитация входа

    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue[900],
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Вход в игру',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: email,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: pass,
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Пароль'),
                    ),
                    SizedBox(height: 25),
                    loading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: login,
                            child: Text(
                              'ВОЙТИ КАК СТУДЕНТ',
                              style: TextStyle(fontSize: 18),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(250, 55),
                            ),
                          ),
                    TextButton(
                      onPressed: () {},
                      child: Text('Регистрация (потом сделаю)'),
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

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Змейка Тараза - ЖИХЦ')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.green, Colors.blue[900]!]),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Привет, Альғани!',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              SizedBox(height: 40),
              menuBtn(context, 'ИГРАТЬ', '/game'),
              SizedBox(height: 15),
              menuBtn(context, 'РЕКОРДЫ', '/scores'),
              SizedBox(height: 15),
              menuBtn(context, 'ПРОФИЛЬ', '/profile'),
              SizedBox(height: 15),
              menuBtn(context, 'ПРО ЖИХЦ', '/about'),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuBtn(BuildContext c, String text, String route) {
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(c, route),
      child: Text(text, style: TextStyle(fontSize: 22)),
      style: ElevatedButton.styleFrom(minimumSize: Size(280, 65)),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Offset> snake = [Offset(10, 10)];
  Offset dir = Offset(1, 0);
  Offset food = Offset.zero;
  int score = 0;
  bool isGameOver = false;
  Timer? timer;

  int grid = 20;

  @override
  void initState() {
    super.initState();
    newFood();
    startGame();
  }

  void startGame() {
    timer = Timer.periodic(Duration(milliseconds: 160), (t) {
      if (isGameOver) return;
      updateGame();
    });
  }

  void updateGame() {
    Offset head = snake.first + dir;

    if (head.dx < 0 ||
        head.dx >= grid ||
        head.dy < 0 ||
        head.dy >= grid ||
        snake.contains(head)) {
      gameOver();
      return;
    }

    snake.insert(0, head);

    if (head == food) {
      score = score + 1;
      newFood();
    } else {
      snake.removeLast();
    }

    setState(() {});
  }

  void newFood() {
    var r = Random();
    do {
      food = Offset(r.nextInt(grid).toDouble(), r.nextInt(grid).toDouble());
    } while (snake.contains(food));
  }

  void gameOver() {
    timer?.cancel();
    isGameOver = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text('ИГРА ЗАКОНЧИЛАСЬ'),
        content: Text('Твой счёт: $score\n\nМолодец студент ЖИХЦ!'),
        actions: [
          TextButton(onPressed: restart, child: Text('ЕЩЁ РАЗ')),
          TextButton(
            onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
            child: Text('В МЕНЮ'),
          ),
        ],
      ),
    );
  }

  void restart() {
    Navigator.pop(context);
    setState(() {
      snake = [Offset(10, 10)];
      dir = Offset(1, 0);
      score = 0;
      isGameOver = false;
      newFood();
      timer?.cancel();
      startGame();
    });
  }

  void changeDir(Offset newDir) {
    if ((newDir.dx + dir.dx).abs() == 2 || (newDir.dy + dir.dy).abs() == 2)
      return;
    dir = newDir;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Играем | Счёт: $score')),
      body: GestureDetector(
        onVerticalDragUpdate: (d) {
          if (d.delta.dy > 15) changeDir(Offset(0, 1));
          if (d.delta.dy < -15) changeDir(Offset(0, -1));
        },
        onHorizontalDragUpdate: (d) {
          if (d.delta.dx > 15) changeDir(Offset(1, 0));
          if (d.delta.dx < -15) changeDir(Offset(-1, 0));
        },
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  width: 380,
                  height: 380,
                  decoration: BoxDecoration(
                    color: Colors.lightGreen[100],
                    border: Border.all(color: Colors.yellow, width: 10),
                  ),
                  child: CustomPaint(painter: SnakePainter(snake, food, grid)),
                ),
              ),
            ),
            Container(
              color: Colors.blue[900],
              padding: EdgeInsets.all(15),
              child: Text(
                'Свайпай пальцем!\nЕшь дыни из Тараза 🐍',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}

class SnakePainter extends CustomPainter {
  final List<Offset> snake;
  final Offset food;
  final int grid;

  SnakePainter(this.snake, this.food, this.grid);

  @override
  void paint(Canvas canvas, Size size) {
    double cell = size.width / grid;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.lightGreen[100]!,
    );

    canvas.drawRect(
      Rect.fromLTWH(food.dx * cell, food.dy * cell, cell, cell),
      Paint()..color = Colors.orange,
    );

    for (int i = 0; i < snake.length; i++) {
      var p = Paint()..color = i == 0 ? Colors.red : Colors.green[800]!;
      canvas.drawRect(
        Rect.fromLTWH(snake[i].dx * cell, snake[i].dy * cell, cell, cell),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ScoresScreen extends StatelessWidget {
  final List<int> top = [30, 25, 20, 18, 15]; // просто статические рекорды

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Рекорды студентов ЖИХЦ')),
      body: ListView.builder(
        itemCount: top.length,
        itemBuilder: (c, i) => ListTile(
          leading: Text('${i + 1}'),
          title: Text(i == 0 ? 'ТЫ (Альғани)' : 'Студент ${i + 1}'),
          trailing: Text('${top[i]}'),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Мой профиль')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.yellow,
              child: Text('АА', style: TextStyle(fontSize: 45)),
            ),
            SizedBox(height: 20),
            Text(
              'Альғани Абдикадир',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            Text('Студент ЖИХЦ, Тараз'),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('ВЫЙТИ'),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Про ЖИХЦ и Тараз')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Жамбылский инновационный высший колледж',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text('• 1993 год'),
            Text('• Тараз, Казахстан'),
            Text('• Здесь я учусь Flutter'),
            SizedBox(height: 30),
            Text(
              'Тараз — древний город на Шелковом пути!',
              style: TextStyle(fontSize: 20),
            ),
            Text('Играй и гордись своим колледжем! 🇰🇿'),
          ],
        ),
      ),
    );
  }
}
