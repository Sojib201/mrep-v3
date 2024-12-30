import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mrap_v03/core/utils/app_colors.dart'; // Assuming this contains your color constants
import '../Pages/attendance_page.dart';
import '../core/utils/app_text_style.dart';

class UserInfoWidget extends StatelessWidget {
  final String userName;
  final String userId;
  final String mobileNo;
  final String startTime;
  final String endTime;
  final String prefix;
  final String prefix2;

  const UserInfoWidget({
    Key? key,
    required this.userName,
    required this.userId,
    required this.mobileNo,
    required this.startTime,
    required this.endTime,
    required this.prefix,
    required this.prefix2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10.0),
      // margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: kContainerBackgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      userName,
                      style: titleTextHeadingStyleBold.copyWith(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 4), // Add some spacing
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      '${'id'.tr()}: $userId\n$mobileNo',
                      style: titleTextHeadingStyle.copyWith(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AttendanceScreen(),
                            ),
                          );

                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('[${'attendance'.tr()}]', style: titleTextHeadingStyle.copyWith(fontSize: 16),),
                    SizedBox(height: 8,),
                    FittedBox(child: Text('${'start'.tr()}: ${prefix != prefix2 ? "" : startTime}', style: titleTextHeadingStyle.copyWith(fontSize: 16),)),
                    FittedBox(child: Text("${'end'.tr()}: ${prefix != prefix2 ? "" : endTime}", style: titleTextHeadingStyle.copyWith(fontSize: 16),)),

                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => const AttendanceScreen(),
                    //       ),
                    //     );
                    //   },
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     mainAxisSize: MainAxisSize.max,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text('[${'attendance'.tr()}]', style: titleTextHeadingStyle.copyWith(fontSize: 16),),
                    //       FittedBox(child: Text('${'start'.tr()}: ${prefix != prefix2 ? "" : startTime}', style: titleTextHeadingStyle.copyWith(fontSize: 16),)),
                    //       FittedBox(child: Text("${'end'.tr()}: ${prefix != prefix2 ? "" : endTime}", style: titleTextHeadingStyle.copyWith(fontSize: 16),)),
                    //
                    //
                    //     ],
                    //   )
                    //   // FittedBox(
                    //   //   fit: BoxFit.contain,
                    //   //   child: Text(
                    //   //     '[${'attendance'.tr()}]\n'
                    //   //         '${'start'.tr()}: ${prefix != prefix2 ? "" : startTime}\n'
                    //   //         "${'end'.tr()}: ${prefix != prefix2 ? "" : endTime}",
                    //   //     style: titleTextHeadingStyle.copyWith(fontSize: 16),
                    //   //   ),
                    //   // ),
                    // ),
                    // SizedBox(height: 4), // Add some spacing
                    // if (prefix != prefix2) // Show additional info if needed
                    //   Text(
                    //     '${'start'.tr()}:  \n'
                    //         "${'end'.tr()}:  ",
                    //     style: titleTextHeadingStyle.copyWith(fontSize: 16, color: Colors.grey),
                    //   ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
