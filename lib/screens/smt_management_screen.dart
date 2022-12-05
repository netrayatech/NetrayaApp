import 'dart:math';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netraya/constants/app_colors.dart';
import 'package:netraya/models/point.dart';
import 'package:netraya/screens/smt_management/smt_detail_screen_2.dart';
import 'package:netraya/screens/smt_management/smt_history_screen.dart';
import 'package:netraya/services/smt_management_service.dart';
import 'package:netraya/widgets/smt_management/factory_bottom_sheet.dart';
import 'package:netraya/widgets/smt_management/status_bottom_sheet.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:timelines/timelines.dart';

class SMTManagementScreen extends StatefulWidget {
  const SMTManagementScreen({Key? key}) : super(key: key);

  @override
  State<SMTManagementScreen> createState() => _SMTManagementScreenState();
}

class _SMTManagementScreenState extends State<SMTManagementScreen> {
  int _processIndex = 1;
  int _modelCheck = 1;
  int _totalItem = 1;
  final _percents = List.generate(
    10,
    (index) => Random().nextInt(100),
  );
  String _selectedFactory = 'Semua';
  String _selectedStatus = 'Semua';
  final smtManagementService = SmtManagementService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SMT Management')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildFactoryBtn(),
                  ),
                  Expanded(
                    child: _buildStatusBtn(),
                  ),
                ],
              ),
            ),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: 1,
            //     shrinkWrap: true,
            //     itemBuilder: (context, index) => _buildItem(_percents[index]),
            //   ),
            // ),
            Expanded(
              child: FutureBuilder(
                future: smtManagementService.getAllPoints(),
                builder: (context, AsyncSnapshot<List<Point>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Point point = snapshot.data![index];
                      if (index == 0) {
                        return changeModel(point);
                      }
                      return onProgressLine(point);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget changeModel(Point point) {
    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (ctx) => _buildPopupDialog(context),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                color: AppColors.darkRed,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(
                    point.name,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const SMTHistoryScreen(),
                        ),
                      ),
                      icon: const Icon(
                        Icons.history,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTimeline(),
                ),
                Expanded(
                  child: _buildGaugeChart(Random().nextInt(100)),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Image.asset('assets/png/line.png'),
                    const Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 16),
                      child: Text(
                        'C3L',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Image.asset('assets/png/gauge.png'),
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        '30 Mins',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 4, bottom: 16),
                      child: Text(
                        'Overdue',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    SvgPicture.asset('assets/svg/circuit_1.svg'),
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        '125',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 4, bottom: 16),
                      child: Text(
                        'PCB Loss',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget onProgressLine(Point point) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => const DetailScreen_2(),
        ),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                color: AppColors.darkRed,
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(
                    point.name,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const SMTHistoryScreen(),
                        ),
                      ),
                      icon: const Icon(
                        Icons.history,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: _buildLineChart(),
                ),
                Expanded(
                  child: _buildGaugeChart(Random().nextInt(100)),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Image.asset('assets/png/line.png'),
                    const Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 16),
                      child: Text(
                        'C3L',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Image.asset('assets/png/gauge.png'),
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        '9h 56m',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 4, bottom: 16),
                      child: Text(
                        '(99.99%)',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Image.asset('assets/png/boxs.png'),
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        '2900',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 4, bottom: 16),
                      child: Text(
                        '/ 3000',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  InkWell _buildFactoryBtn() {
    return InkWell(
      onTap: () => _showFactoryBottomSheet(),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Colors.black12)),
        color: AppColors.grey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Factory: $_selectedFactory',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              SvgPicture.asset('assets/svg/arrow_down_ios.svg')
            ],
          ),
        ),
      ),
    );
  }

  InkWell _buildStatusBtn() {
    return InkWell(
      onTap: () => _showStatusBottomSheet(),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Colors.black12)),
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Status: $_selectedStatus',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              SvgPicture.asset('assets/svg/arrow_down_ios.svg')
            ],
          ),
        ),
      ),
    );
  }

  _showFactoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) => const FactoryBottomSheet(),
    ).then((value) {
      if (value != null) {
        setState(() {
          _selectedFactory = value;
        });
      }
    });
  }

  _showStatusBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) => const StatusBottomSheet(),
    ).then((value) {
      if (value != null) {
        setState(() {
          _selectedStatus = value;
        });
      }
    });
  }

  Widget _buildListItem(int percent, int total) {
    if (total % 2 != 0) {
      _totalItem++;
      return InkWell(
        onTap: () => showDialog(
          context: context,
          builder: (ctx) => _buildPopupDialog(context),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                  color: AppColors.darkRed,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text(
                      'XIAOMI - LINE#1',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => const SMTHistoryScreen(),
                          ),
                        ),
                        icon: const Icon(
                          Icons.history,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildTimeline(),
                  ),
                  Expanded(
                    child: _buildGaugeChart(percent),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Image.asset('assets/png/line.png'),
                      const Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 16),
                        child: Text(
                          'C3L',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset('assets/png/gauge.png'),
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          '30 Mins',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 16),
                        child: Text(
                          'Overdue',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      SvgPicture.asset('assets/svg/circuit_1.svg'),
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          '125',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 16),
                        child: Text(
                          'PCB Loss',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      );
    } else {
      _totalItem++;
      return InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => const DetailScreen_2(),
          ),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                  color: AppColors.darkRed,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text(
                      'XIAOMI - LINE#1',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => const SMTHistoryScreen(),
                          ),
                        ),
                        icon: const Icon(
                          Icons.history,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildLineChart(),
                  ),
                  Expanded(
                    child: _buildGaugeChart(percent),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Image.asset('assets/png/line.png'),
                      const Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 16),
                        child: Text(
                          'C3L',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset('assets/png/gauge.png'),
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          '9h 56m',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 16),
                        child: Text(
                          '(99.99%)',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset('assets/png/boxs.png'),
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          '2900',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 16),
                        child: Text(
                          '/ 3000',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }
  }

  static List<dynamic> _createSampleData() {
    final now = DateTime.now();
    List<TimeSeriesSales> data = [];
    List<DateTime> dates = [];

    for (int i = 0; i < 23; i++) {
      DateTime date = DateTime(now.year, now.month, now.day, i, Random().nextInt(59));
      data.add(TimeSeriesSales(date, Random().nextInt(400)));
      if (i == 0 || i == 12 || i == 23) {
        dates.add(date);
      }
    }

    return [
      [
        charts.Series<TimeSeriesSales, DateTime>(
          id: 'Sales',
          colorFn: (_, __) => charts.MaterialPalette.red.makeShades(10)[1],
          domainFn: (TimeSeriesSales sales, _) => sales.time,
          measureFn: (TimeSeriesSales sales, _) => sales.sales,
          data: data,
        )
      ],
      dates
    ];
  }

  Widget _buildTimeline() {
    return Container(
      padding: const EdgeInsets.only(left: 15, top: 50, right: 16),
      height: 110,
      child: Timeline.tileBuilder(
        theme: TimelineThemeData(
            nodePosition: 0,
            direction: Axis.horizontal,
            color: const Color.fromRGBO(211, 47, 47, 1),
            connectorTheme: const ConnectorThemeData(
              thickness: 3,
            )),
        builder: TimelineTileBuilder.connected(
          itemCount: _processes.length,
          connectionDirection: ConnectionDirection.before,
          contentsBuilder: (context, index) {
            return Container(
                padding: const EdgeInsets.only(left: 4),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8, right: 10),
                      child: Text(
                        _processes[index],
                        style: TextStyle(fontSize: 8, color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4, right: 10),
                      child: Text(
                        _times[index],
                        style: TextStyle(fontSize: 8),
                      ),
                    )
                  ],
                ));
          },
          indicatorBuilder: (_, index) {
            var color;
            if (index < _processIndex) {
              color = Color.fromRGBO(56, 192, 34, 1);
              return OutlinedDotIndicator(
                borderWidth: 3,
                color: color,
              );
            } else {
              color = Color.fromRGBO(211, 47, 47, 1);
              return OutlinedDotIndicator(
                borderWidth: 3,
                color: color,
              );
            }
          },
          connectorBuilder: (_, index, type) {
            if (index <= _processIndex) {
              return SolidLineConnector(
                color: Color.fromRGBO(56, 192, 34, 1),
              );
            } else {
              return SolidLineConnector(
                color: Color.fromRGBO(211, 47, 47, 1),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    List<FlSpot> flSpots = [];
    List<dynamic> data = _createSampleData();

    return Container(
      padding: const EdgeInsets.only(left: 16, top: 16),
      height: 110,
      child: charts.TimeSeriesChart(
        data[0],
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        domainAxis: const charts.DateTimeAxisSpec(
          showAxisLine: true,
          tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
            hour: charts.TimeFormatterSpec(
              format: 'Hm',
              transitionFormat: 'Hm',
              noonFormat: 'Hm',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGaugeChart(int percent) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      height: 140,
      child: Stack(children: [
        SfRadialGauge(
          enableLoadingAnimation: true,
          animationDuration: 500,
          axes: <RadialAxis>[
            RadialAxis(
              axisLineStyle: const AxisLineStyle(thickness: 24),
              maximum: 100,
              minimum: 0,
              showLabels: false,
              showTicks: false,
              ranges: <GaugeRange>[
                GaugeRange(
                  startValue: 0,
                  startWidth: 24,
                  endWidth: 24,
                  endValue: percent.toDouble(),
                  color: const Color.fromRGBO(211, 47, 47, 1),
                )
              ],
            ),
          ],
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$percent%",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const Text(
                "Proses",
                style: TextStyle(fontSize: 8, color: Colors.grey),
              ),
            ],
          ),
        )
      ]),
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            SvgPicture.asset('assets/svg/check_3.svg'),
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 16),
              child: Text(
                'On Progress Change Model',
                style: TextStyle(color: Color.fromRGBO(211, 47, 47, 1), fontSize: 18),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 4, bottom: 16),
              child: Text(
                'Proses change model sedang berlangsung',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}

//timeline content text
final _processes = [
  'Start',
  'Limit',
  'Change model',
  " . ",
];

//timeline time text
final _times = [
  '12:00',
  '30 Mins',
  'Time 13:00',
  ' . ',
];
