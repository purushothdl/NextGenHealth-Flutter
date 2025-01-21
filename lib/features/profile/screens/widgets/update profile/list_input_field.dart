// lib/features/profile/widgets/update_profile/list_input_field.dart
import 'package:flutter/material.dart';

class ListInputField extends StatefulWidget {
  final String label;
  final List<dynamic> items;
  final Function(List<dynamic>) onChanged;

  const ListInputField({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
  });

  @override
  _ListInputFieldState createState() => _ListInputFieldState();
}

class _ListInputFieldState extends State<ListInputField> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _items = [];
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _items = widget.items;
  }

  void _addItem() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _items.add(_controller.text);
        _controller.clear();
      });
      widget.onChanged(_items);
      _focusNode.requestFocus(); // Maintain focus after adding
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            widget.label.toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.blue[800],
              letterSpacing: 1.3,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Add new item...',
              hintStyle: TextStyle(
                color: Colors.blue[200],
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Colors.blue[400]!,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              suffixIcon: Container(
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.blue[500],
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white, size: 20),
                  onPressed: _addItem,
                  splashRadius: 20,
                ),
              ),
            ),
            style: TextStyle(
              color: Colors.blue[900],
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
            onFieldSubmitted: (_) => _addItem(),
          ),
        ),
        const SizedBox(height: 12),
        ..._items.map((item) {
          return AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  leading: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.circle,
                      color: Colors.blue[600],
                      size: 12,
                    ),
                  ),
                  title: Text(
                    item.toString(),
                    style: TextStyle(
                      color: Colors.blue[900],
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.remove_circle,
                      color: Colors.blue[300],
                      size: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        _items.remove(item);
                      });
                      widget.onChanged(_items);
                    },
                    splashRadius: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}