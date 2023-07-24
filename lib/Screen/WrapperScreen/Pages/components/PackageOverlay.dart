// import 'package:flutter/material.dart';
// import 'package:pmx/constant.dart';
// import 'package:pmx/models/login.dart';
// import 'package:pmx/models/modals.dart';

// class PackageOverlay extends StatefulWidget {
//   final AnimationController controller;
//   final String packageId;
//   final bool past;

//   const PackageOverlay({
//     Key? key,
//     required this.controller,
//     required this.packageId,
//     required this.past,
//   }) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => PackageOverlayState();
// }

// class PackageOverlayState extends State<PackageOverlay> {
//   late PackageData packageData;
//   bool isLoading = true;
//   String role = "";

//   getPackageDetails(BuildContext context) async {
//     PackageData? response = await fetchPackageDetails(widget.packageId);
//     var session = await SharedPref().read('session_data');
//     setState(() {
//       role = session['role'].toString();
//       packageData = response!;
//       isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     isLoading = true;
//     getPackageDetails(context);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     setState(() {});
//     Size size = MediaQuery.of(context).size;

//     if (isLoading) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     } else {
//       return Material(
//         color: Colors.transparent,
//         child: Container(
//           height: size.height,
//           width: double.infinity,
//           color: Colors.black54,
//           child: Stack(
//             alignment: AlignmentDirectional.bottomCenter,
//             children: <Widget>[
//               Positioned.fill(
//                 child: GestureDetector(
//                   behavior: HitTestBehavior.translucent,
//                   onTap: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Container(
//                     color: Colors.black54,
//                     child: const Stack(
//                       alignment: AlignmentDirectional.topCenter,
//                       children: [],
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 width: double.infinity,
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                   color: Colors.white,
//                 ),
//                 height: size.height * .6,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: size.height * 0.02,
//                       ),
//                       Text(
//                         "Order ID: ${packageData.packageId.toString()}",
//                         style: const TextStyle(
//                           color: primaryColor,
//                           fontSize: 20,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       Text(packageData.status.toString()),
//                       SizedBox(
//                         height: size.height * 0.04,
//                       ),
//                       orderDetail("Customer Name", packageData.name, size),
//                       orderDetail("Phone", packageData.phone, size),
//                       orderDetail("Remark", packageData.remark ?? "", size),
//                       const Divider(
//                         height: 10,
//                       ),
//                       orderDetail("Address", packageData.address, size),
//                       orderDetail(
//                           "Township", packageData.townshipName ?? "", size),
//                       orderDetail("City", packageData.cityName ?? "", size),
//                       const Divider(
//                         thickness: 2,
//                         height: 20,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 2.5),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               width: size.width * .35,
//                               child: const Text(
//                                 'Total:',
//                                 style: TextStyle(
//                                   fontSize: 30,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                             ),
//                             Flexible(
//                               child: Text(
//                                 "${packageData.total} MMK",
//                                 style: const TextStyle(
//                                   fontSize: 30,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const Divider(
//                         thickness: 2,
//                         height: 20,
//                       ),
//                       const Spacer(),
//                       if (role == "Driver")
//                         OverlayButtons(
//                             orderId: packageData.packageId.toString())
//                       else
//                         Container(),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//   }

//   Padding orderDetail(String text, String value, Size size) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2.5),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: size.width * .35,
//             child: Text(
//               text,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           Flexible(
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     widget.controller.dispose();
//     super.dispose();
//   }
// }

// class OverlayButtons extends StatelessWidget {
//   final String orderId;

//   OverlayButtons({required this.orderId});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 50,
//       width: MediaQuery.of(context).size.width,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           InkWell(
//             onTap: () async {
//               bool confirm = await confirmDialog(context, 'Rescheduled');
//               if (confirm) {
//                 showDialog(
//                   barrierDismissible: false,
//                   context: context,
//                   builder: (context) {
//                     return ShowAlertDialog(orderId: orderId, status: '4');
//                   },
//                 );
//               }
//             },
//             child: Container(
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Colors.black12, width: 2),
//               ),
//               child: const Text(
//                 "Reschedule",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: secondaryColor,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ),
//           InkWell(
//             onTap: () async {
//               bool confirm = await confirmDialog(context, 'Delivered');
//               if (confirm) {
//                 showDialog(
//                   barrierDismissible: false,
//                   context: context,
//                   builder: (context) {
//                     return ShowAlertDialog(orderId: orderId, status: '6');
//                   },
//                 );
//               }
//             },
//             child: Container(
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Colors.black12, width: 2),
//               ),
//               child: const Text(
//                 "Delivered",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: secondaryColor,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ),
//           InkWell(
//             onTap: () async {
//               bool confirm = await confirmDialog(context, 'Cancel');
//               if (confirm) {
//                 showDialog(
//                   barrierDismissible: false,
//                   context: context,
//                   builder: (context) {
//                     return ShowAlertDialog(orderId: orderId, status: '5');
//                   },
//                 );
//               }
//             },
//             child: Container(
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Colors.black12, width: 2),
//               ),
//               child: const Text(
//                 "Cancel",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: secondaryColor,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Future<bool> confirmDialog(BuildContext context, String status) async {
//   final Size size = MediaQuery.of(context).size;
//   return await showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) {
//       return Dialog(
//         child: Container(
//           width: size.width * 0.05,
//           height: size.height * 0.15,
//           padding: const EdgeInsets.only(top: 5),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 padding: const EdgeInsets.only(top: 10),
//                 child: Text(
//                   'This parcel will be $status!',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 50,
//                 width: size.width,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.pop(context, true);
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           alignment: Alignment.center,
//                           child: const Text('Proceed'),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.pop(context, false);
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           alignment: Alignment.center,
//                           child: const Text('Cancel'),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
