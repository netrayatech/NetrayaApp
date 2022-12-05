import 'package:flutter/material.dart';
import 'package:netraya/widgets/bs_container.dart';

class StatusBottomSheet extends StatefulWidget {
  const StatusBottomSheet({super.key});

  @override
  State<StatusBottomSheet> createState() => _StatusBottomSheetState();
}

class _StatusBottomSheetState extends State<StatusBottomSheet> {
  String _selectedStatus = 'Semua';

  @override
  Widget build(BuildContext context) {
    return BSContainer(
      title: 'Status',
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: RadioListTile(
                contentPadding: const EdgeInsets.all(0),
                activeColor: Colors.red.shade700,
                value: 'Semua',
                title: const Text(
                  'Semua',
                  style: TextStyle(fontSize: 14),
                ),
                groupValue: _selectedStatus,
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      _selectedStatus = value as String;
                    }
                  });
                }),
          ),
          SizedBox(
            height: 50,
            child: RadioListTile(
                contentPadding: const EdgeInsets.all(0),
                activeColor: Colors.red.shade700,
                value: 'Active',
                title: const Text(
                  'Active',
                  style: TextStyle(fontSize: 14),
                ),
                groupValue: _selectedStatus,
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      _selectedStatus = value as String;
                    }
                  });
                }),
          ),
          SizedBox(
            height: 50,
            child: RadioListTile(
                contentPadding: const EdgeInsets.all(0),
                activeColor: Colors.red.shade700,
                value: 'Inactive',
                title: const Text(
                  'Inactive',
                  style: TextStyle(fontSize: 14),
                ),
                groupValue: _selectedStatus,
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      _selectedStatus = value as String;
                    }
                  });
                }),
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, _selectedStatus),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.red.shade700)),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Text('Terapkan'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
