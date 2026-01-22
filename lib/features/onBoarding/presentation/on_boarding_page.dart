import 'package:expense_tracker_app/features/auth/presentation/login_page.dart';
import 'package:expense_tracker_app/features/onBoarding/models/on_board.dart';
import 'package:expense_tracker_app/features/onBoarding/presentation/utils/on_board_item.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final List<OnBoard> data = [
    OnBoard(
      image: "assets/images/i1.svg",
      title: "Gardez le contrôle de votre argent",
      description:
          "Enregistrez vos dépenses et vos revenus en quelques secondes.Visualisez clairement où va votre argent et prenez de meilleures décisions au quotidien.",
      textColor: Colors.deepOrangeAccent,
    ),
    OnBoard(
      image: "assets/images/i2.svg",
      title: "Comprenez vos finances",
      description:
          "Consultez des graphiques clairs et détaillés pour analyser vos dépenses par catégorie, par période ou par type.\nIdentifiez rapidement les postes où vous dépensez le plus.",
      textColor: Colors.blue,
    ),
    OnBoard(
      image: "assets/images/i3.svg",
      title: "Dépensez intelligemment",
      description:
          "Fixez des objectifs financiers, suivez votre progression et adoptez de meilleures habitudes.Gérez votre budget en toute confiance et avancez vers vos objectifs.",
      textColor: Color(0xFffFC727),
    ),
  ];
  final List<Color> _colors = [
    Colors.deepOrangeAccent,
    Colors.blue,
    Color(0xFffFC727),
  ];

  late final PageController _controller;
  int _currentPage = 0;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            itemCount: data.length,
            controller: _controller,
            itemBuilder: (context, index) => OnBoardItem(
              image: data[index].image,
              title: data[index].title,
              description: data[index].description,
              textColor: data[index].textColor,
            ),
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
          Container(
            alignment: Alignment(0, 0.85),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    _controller.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                  icon: Icon(
                    Icons.arrow_circle_left_outlined,
                    color: _colors[_currentPage],
                    size: 55,
                  ),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: WormEffect(activeDotColor: _colors[_currentPage]),
                ),
                _currentPage == 2
                    ? GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (builder) => LoginPage()),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.green[700],
                          ),
                          child: Text(
                            "Get Started",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                        icon: Icon(
                          Icons.arrow_circle_right_rounded,
                          color: _colors[_currentPage],
                          size: 55,
                        ),
                      ),
              ],
            ),
          ),
          Positioned(
            top: -30,
            left: -40,
            child: Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _colors[_currentPage],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
