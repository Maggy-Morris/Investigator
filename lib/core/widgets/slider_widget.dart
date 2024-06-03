import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SliderWidget extends StatefulWidget {
  final double min = 10;
  final double max = 100;
  final double value;
  final Function(double) onChanged;
  final Function(dynamic, String)? labelFormatterCallback;
  final bool showLabelFormatter;

  const SliderWidget({
    Key? key,
    // required this.min,
    // required this.max,
    // required this.value,
    required this.onChanged,
    this.value = 10,
    this.labelFormatterCallback,
    this.showLabelFormatter = false,
  }) : super(key: key);

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  // late double _currentValue;

  @override
  void initState() {
    super.initState();
    // _currentValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return SfRangeSliderTheme(
      data: SfRangeSliderThemeData(
        activeTrackColor: Colors.white,
        activeLabelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontStyle: FontStyle.italic,
        ),
        inactiveLabelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontStyle: FontStyle.italic,
        ),
      ),
      child: SfSlider(
          enableTooltip: true,
          activeColor: const Color.fromRGBO(214, 221, 224, 1),
          min: widget.min,
          max: widget.max,
          value: widget.value,
          interval: 18, // Assuming interval is 1
          showTicks: true,
          showLabels: true,
          onChanged: (dynamic newValue) {
            // setState(() {
            //   _currentValue = newValue;
            // });
            debugPrint(newValue.toString());
            widget.onChanged(newValue);
          },
          labelFormatterCallback: widget.showLabelFormatter
              ? (dynamic value, String formattedValue) {
                  // Map numeric values to custom string labels
                  switch (value.toInt()) {
                    case 10:
                      return 'Low';
                    case 28:
                      return 'Medium';
                    case 46:
                      return 'High';
                    case 64:
                      return 'Very High';
                    case 82:
                      return 'Extreme';
                    case 100:
                      return 'Identical';
                    default:
                      return ''; // Return empty string for other values
                  }
                }
              : null),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_core/theme.dart';
// import 'package:syncfusion_flutter_sliders/sliders.dart';

// class SliderWidget extends StatefulWidget {
//   final double min = 10;
//   final double max = 100;
//   final double value = 10;
//   final Function(double) onChanged;
//   final Function(dynamic, String)? labelFormatterCallback;

//   const SliderWidget({
//     Key? key,
//     // required this.min,
//     // required this.max,
//     // required this.value,
//     required this.onChanged,
//     this.labelFormatterCallback,
//   }) : super(key: key);

//   @override
//   _SliderWidgetState createState() => _SliderWidgetState();
// }

// class _SliderWidgetState extends State<SliderWidget> {
//   late double _currentValue;

//   @override
//   void initState() {
//     super.initState();
//     _currentValue = widget.value;
//   }

//   @override
//   void didUpdateWidget(covariant SliderWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.value != oldWidget.value) {
//       _currentValue = widget.value;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SfRangeSliderTheme(
//       data: SfRangeSliderThemeData(
//         activeTrackColor: Colors.white,
//         activeLabelStyle: const TextStyle(
//           color: Colors.white,
//           fontSize: 12,
//           fontStyle: FontStyle.italic,
//         ),
//         inactiveLabelStyle: const TextStyle(
//           color: Colors.white,
//           fontSize: 12,
//           fontStyle: FontStyle.italic,
//         ),
//       ),
//       child: SfSlider(
//         enableTooltip: true,
//         activeColor: const Color.fromRGBO(214, 221, 224, 1),
//         min: widget.min,
//         max: widget.max,
//         value: _currentValue,
//         interval: 18,
//         showTicks: true,
//         showLabels: true,
//         onChanged: (dynamic newValue) {
//           setState(() {
//             _currentValue = newValue;
//           });
//           widget.onChanged(newValue);
//         },
//         labelFormatterCallback: (dynamic value, String formattedValue) {
//           // Map numeric values to custom string labels
//           switch (value.toInt()) {
//             case 10:
//               return 'Low';
//             case 28:
//               return 'Medium';
//             case 46:
//               return 'High';
//             case 64:
//               return 'Very High';
//             case 82:
//               return 'Extreme';
//             case 100:
//               return 'Identical';
//             default:
//               return ''; // Return empty string for other values
//           }
//         },
//       ),
//     );
//   }
// }
