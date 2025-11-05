import 'package:flutter/material.dart';
import 'package:carwash/Reusable/color.dart';

class SearchableTextField extends StatefulWidget {
  final TextEditingController controller;
  final List<String> items;
  final String? hintText;
  final ValueChanged<String>? onItemSelected;
  final Widget Function(int index)? displayBuilder; // ✅ custom builder

  const SearchableTextField({
    super.key,
    required this.controller,
    required this.items,
    this.hintText,
    this.onItemSelected,
    this.displayBuilder,
  });

  @override
  State<SearchableTextField> createState() => _SearchableTextFieldState();
}

class _SearchableTextFieldState extends State<SearchableTextField> {
  final LayerLink _layerLink = LayerLink();
  bool _showDropdown = false;
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(widget.items);
  }

  void _selectItem(String item) {
    widget.controller.text = item;
    widget.onItemSelected?.call(item);
    setState(() => _showDropdown = false);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: widget.controller,
            cursorColor: appPrimaryColor,
            style: const TextStyle(color: appPrimaryColor, fontSize: 14),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: greyColor),
              suffixIcon: const Icon(Icons.arrow_drop_down),
              filled: true,
              fillColor: greyColor200,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            onTap: () => setState(() => _showDropdown = true),
            onChanged: (value) {
              setState(() {
                _filteredItems = widget.items
                    .where(
                      (item) =>
                          item.toLowerCase().contains(value.toLowerCase()),
                    )
                    .toList();
              });
            },
          ),

          // Dropdown list
          if (_showDropdown)
            CompositedTransformFollower(
              link: _layerLink,
              offset: const Offset(0, 55),
              showWhenUnlinked: false,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: whiteColor,
                    constraints: BoxConstraints(
                      maxHeight: _filteredItems.length == 1
                          ? 70
                          : _filteredItems.length == 2
                          ? 120
                          : 170,
                    ),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: _filteredItems.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return InkWell(
                          onTap: () => _selectItem(item),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            // ✅ Use displayBuilder if available
                            child: widget.displayBuilder != null
                                ? widget.displayBuilder!(index)
                                : Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: blackColor87,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
