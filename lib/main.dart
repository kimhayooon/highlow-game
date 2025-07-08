import 'dart:math';
import 'package:flutter/material.dart';
import 'flip_card.dart';

// card box code 
void main() {
  runApp(HighLowGameApp());
}

class HighLowGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '하이로우 게임',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: StartScreen(),
    );
  }
}

// 시작 화면
class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: Center(
        child: ElevatedButton(
          child: Text('🎲 하이로우 게임 시작!'), //게임버튼
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            textStyle: TextStyle(fontSize: 24),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GameScreen()),
            );
          },
        ),
      ),
    );
  }
}

// 게임 화면
class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final Random _random = Random();
  int _referenceNumber = 0;
  int _hiddenNumber = 0;
  int _attempts = 0;
  String _resultMessage = '';
  bool _revealed = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _generateNumbers();
  }

  void _generateNumbers() {
    setState(() {
      _referenceNumber = _random.nextInt(7) + 2; // 2~8
      do {
        _hiddenNumber = _random.nextInt(9) + 1; // 1~9
      } while (_hiddenNumber == _referenceNumber);
      _attempts = 0;
      _resultMessage = '';
      _revealed = false;
      _isCorrect = false;
    });
  }

  void _checkGuess(String guess) {
    setState(() {
      _attempts++;
      _revealed = true;

      _isCorrect = (guess == '크다' && _hiddenNumber > _referenceNumber) ||
                   (guess == '작다' && _hiddenNumber < _referenceNumber);

      if (_isCorrect) {
        _resultMessage = '정답입니다! ($_attempts회 시도)';
      } else {
        _resultMessage = '틀렸습니다. ($_attempts회 시도)';
      }
    });
  }

  void _resetAndGenerateNumbers() async {
    setState(() {
      _revealed = false;
    });
    await Future.delayed(Duration(milliseconds: 600));
    setState(() {
      _referenceNumber = _random.nextInt(7) + 2;
      do {
        _hiddenNumber = _random.nextInt(9) + 1;
      } while (_hiddenNumber == _referenceNumber);
      _attempts = 0;
      _resultMessage = '';
      _isCorrect = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('하이로우 게임'),
      ),
      backgroundColor: Colors.purple[50],
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 기존 코드 주석 처리
              // Text('기준 숫자: $_referenceNumber',
              //     style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              // SizedBox(height: 20),
              // // Text(
              // //   _revealed ? '당신의 숫자: $_hiddenNumber' : '당신의 숫자: ❓',
              // //   style: TextStyle(fontSize: 24),
              // // ),
              // FlipCard(
              //   number: _hiddenNumber,
              //   revealed: _revealed,
              // ),
              // SizedBox(height: 30),

              // 새 코드: 내 카드(숨겨진 숫자)와 기준 카드(항상 공개)를 Row로 배치
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 기준 카드 (항상 공개)
                  FlipCard(
                    number: _referenceNumber,
                    revealed: true, // 항상 보여줌
                    color: Color(0xFFF08080),
                  ),
                  SizedBox(width: 20),
                  // 내 카드 (숨겨진 숫자)
                  FlipCard(
                    number: _hiddenNumber,
                    revealed: _revealed,
                    color: Color(0xFFAFEEEE),
                  ),
                ],
              ),

              SizedBox(height: 20), // 카드와 버튼 사이 간격

              if (!_revealed)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _checkGuess('크다'),
                      icon: Icon(Icons.arrow_drop_up),
                      label: Text('크다'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                        shape: StadiumBorder(),
                        elevation: 1,
                      ),
                    ),
                    SizedBox(width: 16), // 버튼 사이 간격
                    ElevatedButton.icon(
                      onPressed: () => _checkGuess('작다'),
                      icon: Icon(Icons.arrow_drop_down),
                      label: Text('작다'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                        shape: StadiumBorder(),
                        elevation: 1,
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Text(
                      _resultMessage,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _isCorrect ? Colors.green : Colors.red,
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _resetAndGenerateNumbers,
                      child: Text('다시 도전'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
