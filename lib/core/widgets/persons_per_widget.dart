// import 'package:Investigator/core/models/employee_model.dart';
// import 'package:Investigator/core/resources/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_core/theme.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// import '../../presentation/all_employees/bloc/all_employess_bloc.dart';

// Widget personsPager({
//   required List<Data> persons,
//   required int totalSize,
//   required BuildContext context,
// }) {
//   /// search pager
//   ///
//   if (persons.isNotEmpty) {
//     return SfDataPagerTheme(
//       data: SfDataPagerThemeData(
//         itemColor: Colors.white,
//         selectedItemColor: AppColors.blueBlack,
//         itemBorderRadius: BorderRadius.circular(15),
//       ),
//       child: SfDataPager(
//           controller: DataPagerController(),
//           lastPageItemVisible: false,
//           pageCount: ((totalSize / 1000).ceil()).toDouble(),
//           direction: Axis.horizontal,
//           // visibleItemsCount: isDisplayDesktop(context) ? 15 : 5,
//           onPageNavigationStart: (int pageIndex) async {
//             AllEmployeesBloc.get(context)
//                 .add(EditPageNumber(pageIndex: (pageIndex + 1)));
//           },
//           // availableRowsPerPage: const [
//           //   100,
//           //   500,
//           //   1000,
//           //   2000,
//           //   5000,
//           //   9000,
//           // ],
//           // onRowsPerPageChanged:
//           //     (int? rowsPerPage) async {
//           //   ThinkMainScreenPlusCubit.get(context)
//           //       .onEditTake(rowsPerPage ?? 100);
//           // },
//           delegate: DataPagerDelegate(),
//           onPageNavigationEnd: (int pageIndex) async {}),
//     );
//   } else {
//     return Container();
//   }
// }


//   // return BlocBuilder<PeopleBloc,
//   //     PeopleState>(
//   //   builder: (context, state) {
//   //     var hits = state.persons;
//   //
//   //     if (hits.isNotEmpty) {
//   //       return Container(
//   //         padding: const EdgeInsets.only(
//   //             right: 10, bottom: 30),
//   //         child: SfDataPagerTheme(
//   //           data: SfDataPagerThemeData(
//   //             itemColor: Colors.white,
//   //             selectedItemColor:
//   //             AppColors.thinkRedColor,
//   //             itemBorderRadius:
//   //             BorderRadius.circular(15),
//   //           ),
//   //           child: SfDataPager(
//   //               controller: DataPagerController(),
//   //               lastPageItemVisible: false,
//   //               pageCount: (((state.count) / state.take)
//   //                   .ceil())
//   //                   .toDouble(),
//   //               direction: Axis.horizontal,
//   //               visibleItemsCount:
//   //               isDisplayDesktop(context) ? 15 : 5,
//   //               onPageNavigationStart:
//   //                   (int pageIndex) async {
//   //                 PeopleBloc.get(context).add(EditPageNumber(pageIndex));
//   //               },
//   //               // availableRowsPerPage: const [
//   //               //   100,
//   //               //   500,
//   //               //   1000,
//   //               //   2000,
//   //               //   5000,
//   //               //   9000,
//   //               // ],
//   //               // onRowsPerPageChanged:
//   //               //     (int? rowsPerPage) async {
//   //               //   ThinkMainScreenPlusCubit.get(context)
//   //               //       .onEditTake(rowsPerPage ?? 100);
//   //               // },
//   //               delegate: DataPagerDelegate(),
//   //               onPageNavigationEnd:
//   //                   (int pageIndex) async {}),
//   //         ),
//   //       );
//   //     } else {
//   //       return Container();
//   //     }
//   //   },
//   // );