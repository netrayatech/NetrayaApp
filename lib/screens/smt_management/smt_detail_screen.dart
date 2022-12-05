import 'package:carousel_slider/carousel_slider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:netraya/models/chart_data.dart';
import 'package:netraya/widgets/smt_management/date_picker.dart';

import 'smt_history_screen.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _controller = CarouselController();
  final bool animate = true;

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
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: () => showDatePickerDialog(
                      context: context,
                      callback: (value) {
                        setState(() {
                          _selectedDate = value;
                        });
                      }),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.black54,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          _selectedDate.isNotEmpty ? _selectedDate : 'Pilih Tanggal',
                          style: TextStyle(color: _selectedDate.isNotEmpty ? Colors.black : Colors.grey[300], fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _buildHeaderCard(),
              const SizedBox(
                height: 24,
              ),
              _buildMemberCard(),
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
              _buildExpandedWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
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
              _buildHeaderItem('Time', '09:11:36'),
              SizedBox(
                height: 16,
                child: Divider(
                  color: Colors.grey.shade100,
                ),
              ),
              _buildHeaderItem('Model', 'SMC521C3L2AM000M1'),
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
                          'Work Order',
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          'XM20220914-10',
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
                          '5000',
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
        Expanded(child: _buildInfoItem('Total Input', '1750', Colors.amber)),
        Expanded(child: _buildInfoItem('Total Output', '1750', Colors.blue)),
        Expanded(child: _buildInfoItem('Gap', '410', Colors.red)),
      ],
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
          child: charts.OrdinalComboChart(_createSampleData(),
              animate: animate,
              defaultRenderer: charts.BarRendererConfig(symbolRenderer: charts.CircleSymbolRenderer(), groupingType: charts.BarGroupingType.grouped),
              customSeriesRenderers: [
                charts.LineRendererConfig(customRendererId: 'customLine', includePoints: true, radiusPx: 5, strokeWidthPx: 2),
              ]),
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
                    color: Colors.red.shade700.withAlpha(200),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                const Text(
                  'Input',
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
                    color: Colors.green.shade700.withAlpha(200),
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
    final input = [
      ChartData(15, 400),
      ChartData(16, 400),
      ChartData(17, 400),
      ChartData(18, 400),
      ChartData(19, 150),
      ChartData(20, 400),
    ];
    final output = [
      ChartData(15, 400),
      ChartData(16, 400),
      ChartData(17, 400),
      ChartData(18, 400),
      ChartData(19, 150),
      ChartData(20, 400),
    ];
    final target = [
      ChartData(15, 300),
      ChartData(16, 400),
      ChartData(17, 400),
      ChartData(18, 400),
      ChartData(19, 150),
      ChartData(20, 400),
    ];

    return [
      charts.Series<ChartData, String>(
          id: 'Input',
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.red.shade700.withAlpha(200)),
          domainFn: (ChartData sales, _) => sales.x.toString(),
          measureFn: (ChartData sales, _) => sales.y,
          data: input),
      charts.Series<ChartData, String>(
          id: 'Output',
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.blue.shade700.withAlpha(200)),
          domainFn: (ChartData sales, _) => sales.x.toString(),
          measureFn: (ChartData sales, _) => sales.y,
          data: output),
      charts.Series<ChartData, String>(
          id: 'Target',
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.green.shade300.withAlpha(200)),
          domainFn: (ChartData sales, _) => sales.x.toString(),
          measureFn: (ChartData sales, _) => sales.y,
          data: target)
        // Configure our custom line renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customLine'),
    ];
  }

  Widget _buildExpandedWidget() {
    return ExpansionTile(
      title: const Text(
        'Real-Time Station Output',
        style: TextStyle(fontSize: 12),
      ),
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 8, bottom: 32),
          child: Text(
            'Real-Time Station Output',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        _buildExpansionChart()
      ],
    );
  }

  Widget _buildExpansionChart() {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: charts.OrdinalComboChart(
        _createExpansionSampleData(),
        animate: animate,
        defaultRenderer: charts.BarRendererConfig(groupingType: charts.BarGroupingType.grouped),
      ),
    );
  }

  List<charts.Series<dynamic, String>> _createExpansionSampleData() {
    final input = [
      ChartData(15, 400),
      ChartData(16, 400),
      ChartData(17, 400),
      ChartData(18, 400),
      ChartData(19, 150),
      ChartData(20, 400),
    ];
    final output = [
      ChartData(15, 400),
      ChartData(16, 400),
      ChartData(17, 400),
      ChartData(18, 400),
      ChartData(19, 150),
      ChartData(20, 400),
    ];

    return [
      charts.Series<ChartData, String>(
          id: 'Input',
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.red.shade700.withAlpha(200)),
          domainFn: (ChartData sales, _) => sales.x.toString(),
          measureFn: (ChartData sales, _) => sales.y,
          data: input),
      charts.Series<ChartData, String>(
          id: 'Output',
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.blue.shade700.withAlpha(200)),
          domainFn: (ChartData sales, _) => sales.x.toString(),
          measureFn: (ChartData sales, _) => sales.y,
          data: output),
    ];
  }
}
