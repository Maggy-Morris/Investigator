import 'package:Investigator/core/resources/app_colors.dart';
import 'package:Investigator/core/widgets/flutter_pagination/number_model.dart';
import 'package:flutter/material.dart';

class FlutterPagination extends StatefulWidget {
  const FlutterPagination({
    Key? key,
    required this.listCount,
    required this.onSelectCallback,
    this.selectionColor,
    this.notSelectedColor,
    this.arrowsColor,
    this.size = 32.0,
    this.itemCount,
  }) : super(key: key);

  final int listCount;
  final void Function(int page) onSelectCallback;
  final double size;
  final Color? selectionColor;
  final Color? notSelectedColor;
  final Color? arrowsColor;
  final int? itemCount;

  @override
  State<FlutterPagination> createState() => _FlutterPaginationState();
}

class _FlutterPaginationState extends State<FlutterPagination> {
  final ScrollController _controller = ScrollController();

  int selectedPage = 1;

  double _transformSize(double size) {
    return (widget.size * size) / 44.0;
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = widget.itemCount ?? 5;

    Color selectionColor = widget.selectionColor ?? AppColors.white;

    Color notSelectedColor = widget.notSelectedColor ?? AppColors.grey;

    Color arrowsColor = widget.arrowsColor ?? Theme.of(context).primaryColor;
    return SizedBox(
      height: _transformSize(44.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ///Last index button
          AbsorbPointer(
            absorbing: selectedPage <= 1,
            child: IconButton(
                padding: EdgeInsets.zero,
                hoverColor: Theme.of(context).hoverColor,
                onPressed: () {
                  setState(() {
                    selectedPage -= 1;
                  });
                  widget.onSelectCallback(selectedPage);

                  _controller.animateTo(
                      ((selectedPage - 1) / itemCount) * _transformSize(259.9),
                      duration: const Duration(microseconds: 1),
                      curve: Curves.linear);
                },
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: (selectedPage > 1) ? arrowsColor : AppColors.grey,
                )),
          ),

          /// Numbers row

          Container(
              width:
                  widget.listCount > itemCount ? _transformSize(290.0) : null,
              padding: EdgeInsets.symmetric(horizontal: _transformSize(18.0)),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _controller,
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.listCount, (index) {
                    int pageNumber = index + 1;
                    return Padding(
                      padding: widget.listCount - pageNumber > 0
                          ? EdgeInsetsDirectional.only(end: _transformSize(8.0))
                          : EdgeInsets.zero,
                      child: GestureDetector(
                          child: NumberButton(
                        onTap: () {
                          if (pageNumber != selectedPage) {
                            setState(() {
                              selectedPage = pageNumber;
                            });
                            widget.onSelectCallback(pageNumber);
                          }
                        },
                        buttonText: (pageNumber).toString(),
                        isSelected: selectedPage == pageNumber,
                        size: widget.size,
                        selectionColor: selectionColor,
                        notSelectedColor: notSelectedColor,
                      )),
                    );
                  }),
                ),
              )),

          ///Next index button
          AbsorbPointer(
            absorbing: selectedPage >= widget.listCount,
            child: IconButton(
              padding: EdgeInsets.zero,
              hoverColor: Theme.of(context).hoverColor,
              onPressed: () {
                setState(() {
                  selectedPage += 1;
                });
                widget.onSelectCallback(selectedPage);
                if ((selectedPage - 1) % itemCount == 0) {
                  _controller.animateTo(
                      ((selectedPage - 1) / itemCount) * _transformSize(259.9),
                      duration: const Duration(microseconds: 1),
                      curve: Curves.linear);
                }
              },
              icon: Icon(
                Icons.arrow_forward_ios_outlined,
                color: (selectedPage < widget.listCount)
                    ? arrowsColor
                    : AppColors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
