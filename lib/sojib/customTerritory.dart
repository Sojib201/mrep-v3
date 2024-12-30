// import 'package:flutter/material.dart';
//
// import '../Pages/order_sections/customer_edit_page.dart';
// import '../Pages/order_sections/newOrderPage.dart';
// import '../Widgets/new_order_customerwidget.dart';
// import '../core/utils/app_colors.dart';
//
// class CustomTerritoryCard extends StatelessWidget {
//   final IconData? icon;
//   final Function ontap;
//   final Function nextTap;
//   final double? elevation;
//   final bool clientedit;
//   final Map<String, dynamic> foundusers;
//   // final String terrorid;
//   // final String terrorname;
//
//   const CustomTerritoryCard({
//     Key? key,
//     required this.ontap,
//     this.elevation,
//     this.icon,
//     required this.nextTap,
//     required this.clientedit,
//     required this.foundusers,
//     // required this.terrorid,
//     // required this.terrorname,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 5,
//       shape: RoundedRectangleBorder(
//         side: const BorderSide(color: Colors.white70, width: 1),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
//       child: Row(
//         children: [
//           clientedit == true
//               ? InkWell(
//                   onTap: () async {
//                     // var url =
//                     //     //  'https://ww11.yeapps.com/ipi_report/client_update/client_edit?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=${widget.clientId}';
//                     //     '$client_edit_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=${foundUsers[index]['client_id']}';
//                     // if (await canLaunch(url)) {
//                     //   await launch(url);
//                     // } else {
//                     //   throw 'Could not launch $url';
//                     // }
//                     // Navigator.of(context).push(
//                     //   MaterialPageRoute(
//                     //     builder: (context) => CustomerEditPage(
//                     //       clientId: "${foundusers['client_id']}",
//                     //     ),
//                     //   ),
//                     // );
//                     ontap;
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 16),
//                     child: Icon(
//                       Icons.edit,
//                       color: kSecondaryColor,
//                     ),
//                   ),
//                 )
//               : SizedBox(),
//           Expanded(
//             child: GestureDetector(
//               onTap: () {
//                 nextTap;
//               },
//               child: NewOrderCustomerListCardWidget(
//                 clientName:
//                 "${foundusers['client_name'] ?? ''} (${foundusers['client_id'] ?? ''})",
//                 base: foundusers['category_name']?.toString().isNotEmpty ?? false
//                     ? '(${foundusers['category_name'] ?? ''})'
//                     : '',
//                 marketName: foundusers['address'] ?? '',
//                 outstanding: foundusers['outstanding'] ?? '',
//               ),
//               // child: NewOrderCustomerListCardWidget(
//               //   clientName:
//               //       "${foundusers['client_name'] ?? ''} (${foundusers['client_id'] ?? ''})",
//               //   base: foundusers['category_name'].toString().isNotEmpty
//               //       ? '(${foundusers['category_name'] ?? ''})'
//               //       : '',
//               //   marketName: foundusers['address'] ?? '',
//               //   outstanding: foundusers['outstanding'] ?? '',
//               // ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Icon(
//               Icons.arrow_forward_ios_sharp,
//               color: kSecondaryColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../Widgets/new_order_customerwidget.dart';
import '../core/utils/app_colors.dart';

class CustomTerritoryCard extends StatelessWidget {
  final bool clientEdit;
  final Map<String, dynamic> user;
  final Function ontap;
  final Function nextTap;
  final Color secondaryColor;

  const CustomTerritoryCard({
    Key? key,
    required this.clientEdit,
    required this.user,
    required this.ontap,
    required this.nextTap,
    required this.secondaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
      child: Row(
        children: [
          clientEdit == true
              ? InkWell(
                  onTap: () => ontap(),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Icon(
                      Icons.edit,
                      color: kSecondaryColor,
                    ),
                  ),
                )
              : SizedBox(),
          Expanded(
            child: GestureDetector(
              onTap: () => nextTap(),
              child: NewOrderCustomerListCardWidget(
                clientName:
                    "${user['client_name'] ?? ''} (${user['client_id'] ?? ''})",
                base: user['category_name']?.toString().isNotEmpty ?? false
                    ? '(${user['category_name'] ?? ''})'
                    : '',
                marketName: user['address'] ?? '',
                outstanding: user['outstanding'] ?? '',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_forward_ios_sharp,
              color: secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
