import 'package:flutter/material.dart';
import 'package:netraya/screens/smt_management/smt_detail_screen_2.dart';
import 'package:netraya/screens/smt_management/smt_detail_screen.dart';
import 'package:netraya/widgets/smt_management/date_picker.dart';

class SMTHistoryScreen extends StatefulWidget {
  const SMTHistoryScreen({super.key});

  @override
  State<SMTHistoryScreen> createState() => _SMTHistoryScreenState();
}

class _SMTHistoryScreenState extends State<SMTHistoryScreen> {
  String _startDate = '';
  String _endDate = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('History Line#1'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: const [
                Expanded(
                  child: Text(
                    'Tanggal Mulai',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Text(
                    'Taggal Berakhir',
                    style: TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => showDatePickerDialog(
                        context: context,
                        callback: (value) {
                          setState(() {
                            _startDate = value;
                          });
                        }),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.5, color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                _startDate.isNotEmpty ? _startDate : 'DD-MM-YYYY',
                                style: TextStyle(color: _startDate.isNotEmpty ? Colors.black : Colors.grey[300]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => showDatePickerDialog(
                        context: context,
                        callback: (value) {
                          setState(() {
                            _endDate = value;
                          });
                        }),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.5, color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                _endDate.isNotEmpty ? _endDate : 'DD-MM-YYYY',
                                style: TextStyle(color: _endDate.isNotEmpty ? Colors.black : Colors.grey[300]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) => _buildListItem(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Card(
        elevation: 4,
        shadowColor: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  '25 Maret 2022',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _buildCard(context, '1750', 'Total Input', Colors.amber)),
                  Expanded(child: _buildCard(context, '1750', 'Total Output', Colors.blue)),
                  Expanded(child: _buildCard(context, '410', 'Gap', Colors.red)),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              _buildOrderItem('Model', 'SMC5213L2AM000M1'),
              const SizedBox(
                height: 8,
              ),
              _buildOrderItem('Work Order', 'XM20220914-10'),
              const SizedBox(
                height: 12,
              ),
              OutlinedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    const Size(double.infinity, 33),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  side: MaterialStateProperty.all(
                    BorderSide(width: 1.5, color: Colors.red.shade700),
                  ),
                ),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const DetailScreen(),
                )),
                child: Text(
                  'Lihat Detail',
                  style: TextStyle(color: Colors.red.shade700),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String number, String label, Color color) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      child: SizedBox(
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              number,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(String title, String value) {
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
}
