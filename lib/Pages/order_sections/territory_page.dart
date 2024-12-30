// // ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
// // ignore_for_file: file_names

// import 'package:flutter/material.dart';

// import 'package:mrap_v03/local_storage/boxes.dart';

// import 'package:mrap_v03/service/apiCall.dart';
// import 'package:url_launcher/link.dart';

 


// class TerritoryPage extends StatefulWidget {
//   String baseurl;
//   String roat;

//     TerritoryPage({
//     Key? key,
//     required this.baseurl,
//    required this.roat,
//   }) : super(key: key);

//   @override
//   State<TerritoryPage> createState() => _TerritoryPageState();
// }

// class _TerritoryPageState extends State<TerritoryPage> {
//   String cid = '';
//   String userId = '';
//   String userPassword = '';
//   String areaPageUrl = '';
//   String syncUrl = '';

//   final databox= Boxes.allData();

//   @override
//   void initState() {
//     super.initState();
    

   
//     setState(() {
        
//         cid =databox.get("CID")!;
//         userId =databox.get("USER_ID")!;
//         areaPageUrl =databox.get('user_area_url')!;
//         userPassword =databox.get("PASSWORD")!;
//         syncUrl =databox.get("sync_url")!;
       
//     });
     
 
//   }
 

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Territory Page'),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: FutureBuilder(
//           future: getAreaPage(areaPageUrl, cid, userId, userPassword),
//           builder: ((context, AsyncSnapshot<List> snapshot) {
//             if (snapshot.connectionState == ConnectionState.done) {
//               if (snapshot.hasError) {
//                 return Text('${snapshot.error} occured');
//               } else if (snapshot.data != null) {
//                 return ListView.builder(
//   itemCount: snapshot.data!.length,
//   itemBuilder: (BuildContext context, int index) {
//     return     Link(
//                 uri: Uri.parse('${widget.baseurl}&${widget.roat}=${snapshot.data![index]['area_id']}'),
//                 target: LinkTarget.blank,
//                 builder: (BuildContext ctx, FollowLink? openLink) {
//                   return GestureDetector(
//       onTap: openLink,
//       child: Card(
//         elevation: 2,
//         child: SizedBox(
//           height: 40,
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   snapshot.data![index]['area_name'],
//                 ),
//               ),
          
//             ],
//           ),
//         ),
//       ),
//     );
//                 },
//               );
    
    
    
    
//   },
// );


//                 // ListView.builder(
//                 //     itemCount: snapshot.data!.length,
//                 //     itemBuilder: (context, index) {
//                 //       return StatefulBuilder(
//                 //           builder: (BuildContext context, setState1) {
//                 //         return         Link(
//                 //     uri: Uri.parse(
//                 //            //'https://ww11.yeapps.com/ipi_report/client_update/clientNew_add?cid=$cid&rep_id=$userId&rep_pass=$userPassword'),
//                 //         '$client_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword'),
//                 //     target: LinkTarget.blank,
//                 //     builder: (BuildContext ctx, FollowLink? openLink) {
//                 //       return
//                 //         Card(
//                 //          // color: Colors.blue.withOpacity(.03),
//                 //          elevation: 2,
//                 //          child: SizedBox(
//                 //              height: 40,
//                 //              child: Row(
//                 //                crossAxisAlignment: CrossAxisAlignment.center,
//                 //                mainAxisAlignment:
//                 //                    MainAxisAlignment.spaceBetween,
//                 //                children: [
//                 //                  Padding(
//                 //                    padding: const EdgeInsets.all(8.0),
//                 //                    child: Text(
//                 //                      snapshot.data![index]['area_name'],
//                 //                    ),
//                 //                  ),
                             
                                     
                              
//                 //                ],
//                 //              )),
//                 //           );
                                   
//                 //     });
                        
//                 //       });
//                 //     });
//               }
//             } else {}
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }
