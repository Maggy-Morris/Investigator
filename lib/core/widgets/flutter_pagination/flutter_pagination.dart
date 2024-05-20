import 'package:Investigator/core/resources/app_colors.dart';
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
  bool isNavigating = false;

  double _transformSize(double size) {
    return (widget.size * size) / 44.0;
  }

  void _navigateToPage(int pageNumber) {
    if (pageNumber >= 1 && pageNumber <= widget.listCount && !isNavigating) {
      setState(() {
        isNavigating = true;
        selectedPage = pageNumber;
      });
      widget.onSelectCallback(pageNumber);

      // Calculate the scroll position
      double scrollPosition =
          ((pageNumber - 1) / (widget.itemCount ?? 5)) * _transformSize(259.9);

      // Scroll to the calculated position
      _controller
          .animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      )
          .then((_) {
        setState(() {
          isNavigating = false;
        });
      });
    }
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
          widget.listCount != 0
              ? AbsorbPointer(
                  absorbing: selectedPage <= 1 || isNavigating,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    hoverColor: Theme.of(context).hoverColor,
                    onPressed: () => _navigateToPage(selectedPage - 1),
                    icon: Icon(
                      Icons.arrow_back_ios_outlined,
                      color: (selectedPage > 1) ? arrowsColor : AppColors.grey,
                    ),
                  ),
                )
              : const SizedBox(),

          /// Numbers row
          Container(
            width: widget.listCount > itemCount ? _transformSize(290.0) : null,
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
                      onTap: () => _navigateToPage(pageNumber),
                      child: NumberButton(
                        buttonText: pageNumber.toString(),
                        isSelected: selectedPage == pageNumber,
                        size: widget.size,
                        selectionColor: selectionColor,
                        notSelectedColor: notSelectedColor,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          widget.listCount != 0
              ?

              ///Next index button
              AbsorbPointer(
                  absorbing: selectedPage >= widget.listCount || isNavigating,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    hoverColor: Theme.of(context).hoverColor,
                    onPressed: () => _navigateToPage(selectedPage + 1),
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: (selectedPage < widget.listCount)
                          ? arrowsColor
                          : AppColors.grey,
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class NumberButton extends StatelessWidget {
  final String buttonText;
  final bool isSelected;
  final double size;
  final Color selectionColor;
  final Color notSelectedColor;
  final VoidCallback? onTap;

  const NumberButton({
    Key? key,
    required this.buttonText,
    required this.isSelected,
    required this.size,
    required this.selectionColor,
    required this.notSelectedColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? selectionColor : notSelectedColor,
          borderRadius: BorderRadius.circular(12.0),
        ),

        // BoxDecoration(
        //   color: isSelected ? selectionColor : notSelectedColor,
        //   shape: BoxShape.circle,
        // ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: isSelected ? notSelectedColor : selectionColor,
            fontSize: size * 0.5,
          ),
        ),
      ),
    );
  }
}
