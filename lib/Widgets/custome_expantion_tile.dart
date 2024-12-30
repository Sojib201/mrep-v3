import 'package:flutter/material.dart';
import 'package:mrap_v03/core/utils/app_colors.dart';

class CustomExpansionTileWidget extends StatelessWidget {
  final String title;
  final String imageAsset;
  final List<Widget> children;
  final Color containerColor;
  final Function isExpanded;

  const CustomExpansionTileWidget({
    Key? key,
    required this.title,
    required this.imageAsset,
    required this.children,
    required this.containerColor, required this.isExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: containerColor,
        // boxShadow: [
        //
        //   BoxShadow(
        //   color: Colors.black.withOpacity(0.10),
        //   spreadRadius: 2,
        //   blurRadius: 4,
        //   offset: Offset(0, 4),
        // ),
        // ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ExpansionTile(
          iconColor: kSecondaryColor,
          onExpansionChanged: (expanded) {
            isExpanded();
            if(expanded)
              {


                print("expanded");


                // final ScrollController _scrollController = ScrollController();
                // bool _isExpanded = false;
                // Future.delayed(const Duration(milliseconds: 300), () {
                //   _scrollController.animateTo(
                //     _scrollController.position.maxScrollExtent,
                //     duration: const Duration(milliseconds: 300),
                //     curve: Curves.easeInOut,
                //   );

            // });
              }

          },
          trailing: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.keyboard_double_arrow_down),
            ],
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                imageAsset,
                height: 60,
                width: 60,
              ),
              Expanded(
                child: Text(
                  textAlign: TextAlign.center,
                  title,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 29, 67, 78),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          children: children,
        ),
      ),
    );
  }
}
