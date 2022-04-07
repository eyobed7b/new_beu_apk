import 'package:efood_multivendor/helper/size_config.dart';
import 'package:flutter/material.dart';

class ListItem extends StatefulWidget {
  const ListItem(
      {Key key,
      this.onTap,
      this.icons,
      this.iconColor,
      this.showArrow = false,
      this.seconderyText = ' ',
      this.title})
      : super(key: key);

  final VoidCallback onTap;
  final IconData icons;
  final Color iconColor;
  final bool showArrow;
  final String seconderyText;
  final String title;

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.h),
      child: MaterialButton(
        splashColor: Colors.grey[200],
        padding: const EdgeInsets.all(0),
        onPressed: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xffCECDD2).withOpacity(0.21),
            borderRadius: BorderRadius.circular(10.0),
            // border: Border(
            //   bottom: BorderSide(
            //     color: Colors.grey[300],
            //     width: 1.h,
            //   ),
            // ),
          ),
          child: Column(
            children: [
              SizedBox(height: 1.w),
              Container(
                // color:Colors.red,
                padding: EdgeInsets.fromLTRB(4.w, 1.w, 3.w, 1.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 11.w,
                          height: 11.w,
                          padding: EdgeInsets.all(1.w),
                          child: Center(
                              child: Icon(widget.icons, color: Colors.white)),
                          decoration: BoxDecoration(
                              color: widget.iconColor,
                              borderRadius: BorderRadius.circular(20.w)),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 1.9.h,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: widget.showArrow,
                      child: Row(
                        children: [
                          Text(
                            widget.seconderyText.toString(),
                            style: TextStyle(
                              fontSize: 1.6.h,
                              color: Colors.grey[400],
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 2.5.h,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1.w),
            ],
          ),
        ),
      ),
    );
  }
}
