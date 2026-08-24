import 'package:flutter/material.dart';
import '../../../../data/models/user_model.dart';

const Color _kGreen = Color(0xFF3D9A7E);

class AssignVendorSheet extends StatefulWidget {
  final List<UserModel> vendors;

  const AssignVendorSheet({super.key, required this.vendors});

  @override
  State<AssignVendorSheet> createState() => _AssignVendorSheetState();
}

class _AssignVendorSheetState extends State<AssignVendorSheet> {
  final _remarkController = TextEditingController();
  UserModel? _selectedVendor;

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Assign Vendor',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: widget.vendors.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final vendor = widget.vendors[index];
                  final selected = _selectedVendor == vendor;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () => setState(() => _selectedVendor = vendor),
                    leading: Icon(
                      selected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: selected ? _kGreen : Colors.grey,
                    ),
                    title: Text(
                      vendor.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    subtitle: Text(
                      vendor.divisionName ?? 'Division unavailable',
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _remarkController,
              minLines: 2,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Remark is required',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedVendor == null
                        ? null
                        : () {
                            final remark = _remarkController.text.trim();
                            if (remark.isEmpty) return;
                            Navigator.pop(context, (
                              vendor: _selectedVendor!,
                              remark: remark,
                            ));
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF8C300),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Assign'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
