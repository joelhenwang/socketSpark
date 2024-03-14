import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'Splash.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(), // Set SplashScreen as the initial route
  ));
}

class ChartStyle {
  static Color bg_color = Colors.cyanAccent;
  static Color accent_color = Color(0xff586af8);
  static Color spline_color = Colors.lightGreenAccent;
}

class ChartData {
  int day = 0;
  double price = 0;
  ChartData(this.day, this.price);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<ChartData> data;
  final int watts_usage_month = 1000000;

  @override
  void initState() {
    super.initState();
    _initializeChartData();
  }

  void _initializeChartData() {
    data = [
      ChartData(17, 21500),
      ChartData(18, 22684),
      ChartData(19, 21643),
      ChartData(20, 22000),
      ChartData(21, 22883),
      ChartData(22, 22635),
      ChartData(23, 21800),
      ChartData(24, 20500),
      ChartData(25, 21354),
      ChartData(26, 22354),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200), // Adjust the height as needed
        child: Stack(
          children: [
            const MyWaveClipper(), // Add MyWaveClipper to Stack
            AppBar(
              backgroundColor: Colors.transparent, // Make AppBar transparent
              elevation: 0, // Remove AppBar elevation
              actions: [
                const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Icon(Icons.menu),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.only(right: 15.0),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage("assets/file.jpeg"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: _buildBody(),
      bottomSheet: BottomSheet(data: data),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home),
          backgroundColor: Colors.white,
        ),
        BottomNavigationBarItem(
          label: 'Settings',
          icon: Icon(Icons.settings),
          backgroundColor: Colors.white,
        ),
      ],
    );
  }
}

class MyWaveClipper extends StatelessWidget {
  const MyWaveClipper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: WaveClipper(),
            child: Container(
              color: Colors.lightGreen.shade100,
              height: 250,
            ),
          ),
        ),
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
            color: Colors.lightGreen.shade300,
            height: 180,
          ),
        ),
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
            color: Colors.lightGreen.shade500,
            height: 120,
          ),
        ),
        Positioned(
          top: 30,
          left: 10,
          child: _buildBody(),
        ),
      ],
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    var firstStart = Offset(size.width * 0.3, size.height);
    var firstEnd = Offset(size.width * 0.55, size.height * 0.75);
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);
    var secondStart = Offset(size.width * 0.75, size.height * 0.5);
    var secondEnd = Offset(size.width, size.height * 0.7);
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class BottomSheet extends StatelessWidget {
  final List<ChartData> data;
  const BottomSheet({Key? key, required this.data});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          height: 220, // Adjust the height as needed
          decoration: BoxDecoration(
            color: Colors.indigo.shade200,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
            ),
          ),
          child: Container(
            height: 220, // Adjust the height as needed
            child: SfCartesianChart(
              margin: EdgeInsets.zero,
              borderWidth: 0,
              borderColor: Colors.transparent,
              plotAreaBorderWidth: 0,
              primaryXAxis:
                  NumericAxis(minimum: 17, maximum: 26, isVisible: false),
              primaryYAxis: NumericAxis(
                  minimum: 19000,
                  maximum: 23000,
                  interval: 1000,
                  isVisible: false,
                  borderWidth: 0,
                  borderColor: Colors.transparent),
              series: <ChartSeries<ChartData, int>>[
                SplineAreaSeries(
                    dataSource: data,
                    xValueMapper: (ChartData data, _) => data.day,
                    yValueMapper: (ChartData data, _) => data.price,
                    gradient: LinearGradient(
                        colors: [
                          ChartStyle.spline_color,
                          ChartStyle.bg_color.withAlpha(150),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget _buildBody() {
  var now = DateTime.now();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: kToolbarHeight),
      const Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: Text(
          'Hi, username!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          DateFormat('d MMMM y').format(now),
          style: const TextStyle(
            color: Color.fromARGB(255, 63, 146, 66),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  );
}
