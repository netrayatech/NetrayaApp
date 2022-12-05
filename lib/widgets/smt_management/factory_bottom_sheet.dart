import 'package:flutter/material.dart';
import 'package:netraya/constants/app_colors.dart';
import 'package:netraya/widgets/bs_container.dart';
import 'package:netraya/widgets/smt_management/bottom_sheet_item.dart';

class FactoryBottomSheet extends StatefulWidget {
  const FactoryBottomSheet({super.key});

  @override
  State<FactoryBottomSheet> createState() => _FactoryBottomSheetState();
}

class _FactoryBottomSheetState extends State<FactoryBottomSheet> {
  String _selectedFactory = 'Semua';

  @override
  Widget build(BuildContext context) {
    return BSContainer(
      title: 'Factory',
      child: Column(
        children: [
          Wrap(
            direction: Axis.horizontal,
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: BottomSheetItem(
                  currentValue: _selectedFactory,
                  text: 'Semua',
                  callback: (item) {
                    setState(() {
                      _selectedFactory = item;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: BottomSheetItem(
                  currentValue: _selectedFactory,
                  text: 'FACT#5 (Line 1 - Line 5)',
                  callback: (item) {
                    setState(() {
                      _selectedFactory = item;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: BottomSheetItem(
                  currentValue: _selectedFactory,
                  text: 'FACT#8 (Line 6 - Line 13)',
                  callback: (item) {
                    setState(() {
                      _selectedFactory = item;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: BottomSheetItem(
                  currentValue: _selectedFactory,
                  text: 'FACT#7 (Line 14 - Line 20)',
                  callback: (item) {
                    setState(() {
                      _selectedFactory = item;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, _selectedFactory),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(AppColors.red)),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Terapkan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
