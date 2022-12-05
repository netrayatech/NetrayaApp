import 'package:carousel_slider/carousel_slider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:netraya/models/chart_data.dart';
import 'package:netraya/widgets/smt_management/date_picker.dart';
import 'package:path/path.dart';

import 'smt_history_screen.dart';

class DetailScreen_2 extends StatefulWidget {
  const DetailScreen_2({super.key});

  @override
  State<DetailScreen_2> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen_2> {
  final _controller = CarouselController();
  final bool animate = true;
  var backColor;
  var txtColor;
  var borderColor;
  bool _pressed = false;
  int buttonSelected = 0;
  List<List> dataDummy = [
    ['12 Hours', 'XM20220914', '1', 'ROG4', '1', 'SMT-02F-LAB', 'Production'],
    ['24 Hours', 'XM20220914', '2', 'ROG5', '2', 'SMT-03F-LAB', 'Production'],
    ['16 Hours', 'XM20220914', '3', 'ROG6', '3', 'SMT-04F-LAB', 'Production'],
  ];

  String _selectedDate = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('LINE#1 WO: XM20220914'), actions: [
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => const SMTHistoryScreen(),
            ),
          ),
          icon: const Icon(
            Icons.history,
            color: Colors.black,
          ),
        )
      ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
            children: [
              _buildHeaderCard(),
              const SizedBox(
                height: 24,
              ),
              _buildInfos(),
              const Padding(
                padding: EdgeInsets.only(top: 16, bottom: 12),
                child: Text(
                  'Hourly Output',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              _buildHourlyOutput(),
              _buildChart(),
              const SizedBox(
                height: 8,
              ),
              _buildExpandedWidget(),
              _buildMemberCard(),
              const SizedBox(
                height: 24,
              ),
              _buildExpandedWidget2(),
              _buildExpandedWidget3(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    List<String> selectedDummy = [
      dataDummy[buttonSelected][0],
      dataDummy[buttonSelected][1],
      dataDummy[buttonSelected][2],
      dataDummy[buttonSelected][3],
      dataDummy[buttonSelected][4],
      dataDummy[buttonSelected][5],
      dataDummy[buttonSelected][6]
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Card(
        elevation: 4,
        shadowColor: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildbutton(),
              SizedBox(
                height: 16,
                child: Divider(
                  color: Colors.grey.shade100,
                ),
              ),
              _buildHeaderItem('Running Time', selectedDummy[0]),
              SizedBox(
                height: 16,
                child: Divider(
                  color: Colors.grey.shade100,
                ),
              ),
              _buildHeaderItem('Work Order', selectedDummy[1]),
              SizedBox(
                height: 16,
                child: Divider(
                  color: Colors.grey.shade100,
                ),
              ),
              _buildHeaderItem('Model No.', selectedDummy[2]),
              SizedBox(
                height: 16,
                child: Divider(
                  color: Colors.grey.shade100,
                ),
              ),
              _buildHeaderItem('Type Model', selectedDummy[3]),
              SizedBox(
                height: 16,
                child: Divider(
                  color: Colors.grey.shade100,
                ),
              ),
              _buildHeaderItem('Process Seq', selectedDummy[4]),
              SizedBox(
                height: 16,
                child: Divider(
                  color: Colors.grey.shade100,
                ),
              ),
              _buildHeaderItem('Machine Name', selectedDummy[5]),
              SizedBox(
                height: 16,
                child: Divider(
                  color: Colors.grey.shade100,
                ),
              ),
              _buildHeaderItem('Job Status', selectedDummy[6]),
              SizedBox(
                height: 16,
                child: Divider(
                  color: Colors.grey.shade100,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'Target Hour',
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          '250',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'Lot Size',
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          '3000',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderItem(String title, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        const Text(
          ':',
          style: TextStyle(fontSize: 12),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget _buildMemberCard() {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: CarouselSlider.builder(
        itemCount: 15,
        carouselController: _controller,
        options: CarouselOptions(
          viewportFraction: 1,
          height: 82,
          enableInfiniteScroll: true,
          scrollPhysics: const NeverScrollableScrollPhysics(),
        ),
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => Row(
          children: [
            IconButton(
              onPressed: () => _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 12,
              ),
            ),
            Expanded(
                child: _buildCarrouselItem(
              itemIndex + 1,
            )),
            IconButton(
              onPressed: () => _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarrouselItem(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: Image.asset(
              'assets/png/contractor.webp',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'PIC Engineering',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Emirrizat',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInfos() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildInfoItem('Target', '1750', Colors.cyan)),
        Expanded(child: _buildInfoItem('Total Output', '1750', Colors.amber)),
        Expanded(child: _buildInfoItem('Balance', '1750', Colors.blue)),
        //Expanded(child: _buildInfoItem('Gap', '410', Colors.red)),
      ],
    );
  }

  Widget _buildbutton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildbuttonItem('LB', 0),
        const SizedBox(width: 50),
        _buildbuttonItem('LA', 1),
        const SizedBox(width: 50),
        _buildbuttonItem('LAB', 2),
      ],
    );
  }

  Widget _buildbuttonItem(String label, int array) {
    if (array == buttonSelected) {
      backColor = Color.fromRGBO(211, 47, 47, 1);
      borderColor = Colors.white;
      txtColor = Colors.white;
    } else {
      backColor = Colors.white;
      borderColor = Colors.grey;
      txtColor = Colors.grey;
    }
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: backColor,
        side: BorderSide(color: borderColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {
        setState(() {
          buttonSelected = array;
        });
      },
      child: Text(
        style: TextStyle(color: txtColor),
        label,
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, Color color) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHourlyOutput() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildHourlyItem('Cummulative Target', '1750'),
          _buildHourlyItem('Total Output', '1340'),
          _buildHourlyItem('Ach Rate', '76.6%'),
        ],
      ),
    );
  }

  Widget _buildHourlyItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 10),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(value),
      ],
    );
  }

  Widget _buildChart() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 16),
          height: 200,
          width: double.infinity,
          child: charts.OrdinalComboChart(
            _createSampleData(),
            animate: animate,
            defaultRenderer: charts.BarRendererConfig(symbolRenderer: charts.CircleSymbolRenderer(), groupingType: charts.BarGroupingType.grouped),
            customSeriesRenderers: [
              charts.LineRendererConfig(customRendererId: 'customLine'),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 16,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700.withAlpha(200),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                const Text(
                  'Output',
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
            const SizedBox(
              width: 16,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(200),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                const Text(
                  'Target',
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
          ],
        )
      ],
    );
  }

  List<charts.Series<dynamic, String>> _createSampleData() {
    final output = [
      ChartData(15, 400),
      ChartData(16, 380),
      ChartData(17, 370),
      ChartData(18, 380),
      ChartData(19, 150),
      ChartData(20, 400),
    ];
    final target = [
      ChartData(15, 450),
      ChartData(16, 450),
      ChartData(17, 450),
      ChartData(18, 450),
      ChartData(19, 450),
      ChartData(20, 450),
    ];

    return [
      charts.Series<ChartData, String>(
          id: 'Output',
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.blue.shade700.withAlpha(200)),
          domainFn: (ChartData sales, _) => sales.x.toString(),
          measureFn: (ChartData sales, _) => sales.y,
          data: output),
      charts.Series<ChartData, String>(
          id: 'Target',
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.black.withAlpha(200)),
          domainFn: (ChartData sales, _) => sales.x.toString(),
          measureFn: (ChartData sales, _) => sales.y,
          data: target)
        ..setAttribute(charts.rendererIdKey, 'customLine'),
    ];
  }

  Widget _buildExpandedWidget() {
    return ExpansionTile(
      title: const Text(
        'Accumulated Hourly Output',
        style: TextStyle(
          fontSize: 12,
        ),
      ),
      textColor: Colors.black,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: Text(
            'Accumulated Hourly Output',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        _buildHourlyOutput(),
        _buildExpansionChart(),
        const SizedBox(
          width: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700.withAlpha(200),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                const Text(
                  'Output',
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
            const SizedBox(
              width: 16,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(200),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                const Text(
                  'Target',
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget _buildExpandedWidget2() {
    return ExpansionTile(
      expandedAlignment: Alignment.topLeft,
      title: const Text(
        'Change Model',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black),
      ),
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: const [
                        Text(
                          'Start: 12:00',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: const [
                        Text(
                          'End: 12:28',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: const [
                        Text(
                          'Total CM: 28 Mins',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ]),
            ))
      ],
    );
  }

  Widget _buildExpandedWidget3() {
    return ExpansionTile(
      expandedAlignment: Alignment.topLeft,
      title: const Text(
        'Down Time Remarks',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              SizedBox(
                height: 16,
              ),
              Text(
                '19:10 - 19:30: Reflow machine broken, need reparation',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpansionChart() {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: charts.OrdinalComboChart(
        _createAccumulatedData(),
        animate: animate,
        defaultRenderer: charts.BarRendererConfig(groupingType: charts.BarGroupingType.grouped),
        customSeriesRenderers: [charts.LineRendererConfig(customRendererId: 'customLine')],
      ),
    );
  }

  List<charts.Series<dynamic, String>> _createAccumulatedData() {
    final input = [
      ChartData(15, 400),
      ChartData(16, 800),
      ChartData(17, 1200),
      ChartData(18, 1600),
      ChartData(19, 1750),
      ChartData(20, 2250),
    ];
    final target = [
      ChartData(15, 600),
      ChartData(16, 1100),
      ChartData(17, 1500),
      ChartData(18, 1900),
      ChartData(19, 2300),
      ChartData(20, 2750),
    ];

    return [
      charts.Series<ChartData, String>(
          id: 'Input',
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.blue.shade700.withAlpha(200)),
          domainFn: (ChartData sales, _) => sales.x.toString(),
          measureFn: (ChartData sales, _) => sales.y,
          data: input),
      charts.Series<ChartData, String>(
          id: 'Output',
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.black.withAlpha(200)),
          domainFn: (ChartData sales, _) => sales.x.toString(),
          measureFn: (ChartData sales, _) => sales.y,
          data: target)
        ..setAttribute(charts.rendererIdKey, 'customLine'),
    ];
  }
}
