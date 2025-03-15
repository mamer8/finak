import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:finak/core/exports.dart';

class DropdownButtonFormFieldWidget extends StatefulWidget {
  const DropdownButtonFormFieldWidget(
      {super.key,
      required this.items,
      required this.title,
      this.dataType,
      required this.onChanged});

  final List<String> items;
  final String title;
  final String? dataType;
  final void Function(String?)? onChanged;
  @override
  State<DropdownButtonFormFieldWidget> createState() =>
      _DropdownButtonFormFieldWidgetState();
}

class _DropdownButtonFormFieldWidgetState
    extends State<DropdownButtonFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: getBoldStyle(),
          ),
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            height: 60.h,
            child: DropdownButtonFormField<String>(
                value: widget.dataType,
                decoration: InputDecoration(
                  // labelText: widget.title,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: widget.items
                    .map((option) => DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        ))
                    .toList(),
                onChanged: widget.onChanged),
          ),
        ],
      ),
    );
  }
}
