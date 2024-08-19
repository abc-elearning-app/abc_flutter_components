import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ActionType { bookmark, like, dislike }

class ActionButtons extends StatelessWidget {
  final bool bookmarked;
  final bool liked;
  final bool disliked;

  final String color;
  final String? selectedColor;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  final void Function(bool isSelected) onBookmark;
  final void Function(bool isSelected) onLike;
  final void Function(bool isSelected) onDislike;

  const ActionButtons({
    super.key,
    required this.bookmarked,
    required this.liked,
    required this.disliked,
    required this.color,
    required this.onBookmark,
    required this.onLike,
    required this.onDislike,
    this.margin,
    this.padding,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ActionButton(color: color, selectedColor: selectedColor, isSelected: bookmarked, onToggle: onBookmark, actionType: ActionType.bookmark),
          ActionButton(color: color, selectedColor: selectedColor, isSelected: liked, onToggle: onLike, actionType: ActionType.like),
          ActionButton(color: color, selectedColor: selectedColor, isSelected: disliked, onToggle: onDislike, actionType: ActionType.dislike),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final ActionType actionType;
  final String color;
  final String? selectedColor;
  final bool isSelected;
  final void Function(bool isSelected) onToggle;

  const ActionButton({
    super.key,
    required this.color,
    required this.isSelected,
    required this.onToggle,
    required this.actionType,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    String icon = '';
    switch (actionType) {
      case ActionType.bookmark:
        icon = '''
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M12.45 17.4C12.1833 17.2 11.8167 17.2 11.55 17.4L8.35 19.8C6.86672 20.9125 4.75 19.8541 4.75 18V5C4.75 3.75736 5.75736 2.75 7 2.75H17C18.2426 2.75 19.25 3.75736 19.25 5V18C19.25 19.8541 17.1333 20.9125 15.65 19.8L12.45 17.4Z" stroke="${isSelected ? selectedColor ?? color : color}" fill="${isSelected ? color : 'none'}" stroke-width="1.5" stroke-linejoin="round"/>
          <path fill-rule="evenodd" clip-rule="evenodd" d="M8 7C8 6.44772 8.44772 6 9 6H15C15.5523 6 16 6.44772 16 7C16 7.55228 15.5523 8 15 8H9C8.44772 8 8 7.55228 8 7Z" fill="${isSelected ? 'white' : color}"/>
          </svg>
          ''';
        break;
      case ActionType.like:
        icon = isSelected ? '''
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M8.39014 18.49V8.32998C8.39014 7.92998 8.51014 7.53998 8.73014 7.20998L11.4601 3.14998C11.8901 2.49998 12.9601 2.03998 13.8701 2.37998C14.8501 2.70998 15.5001 3.80997 15.2901 4.78997L14.7701 8.05998C14.7301 8.35998 14.8101 8.62998 14.9801 8.83998C15.1501 9.02998 15.4001 9.14997 15.6701 9.14997H19.7801C20.5701 9.14997 21.2501 9.46997 21.6501 10.03C22.0301 10.57 22.1001 11.27 21.8501 11.98L19.3901 19.47C19.0801 20.71 17.7301 21.72 16.3901 21.72H12.4901C11.8201 21.72 10.8801 21.49 10.4501 21.06L9.17014 20.07C8.68014 19.7 8.39014 19.11 8.39014 18.49Z" fill = '${selectedColor ?? '#73A8FB'}'/>
          <path d="M5.21 6.38H4.18C2.63 6.38 2 6.98 2 8.46V18.52C2 20 2.63 20.6 4.18 20.6H5.21C6.76 20.6 7.39 20 7.39 18.52V8.46C7.39 6.98 6.76 6.38 5.21 6.38Z" fill='${selectedColor ?? '#73A8FB'}'/>
          </svg>
          ''' : '''
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M7.47998 18.35L10.58 20.75C10.98 21.15 11.88 21.35 12.48 21.35H16.28C17.48 21.35 18.78 20.45 19.08 19.25L21.48 11.95C21.98 10.55 21.08 9.34997 19.58 9.34997H15.58C14.98 9.34997 14.48 8.84997 14.58 8.14997L15.08 4.94997C15.28 4.04997 14.68 3.04997 13.78 2.74997C12.98 2.44997 11.98 2.84997 11.58 3.44997L7.47998 9.54997" stroke="${isSelected ? selectedColor ?? '#73A8FB' : color}" fill="${isSelected ? selectedColor ?? '#73A8FB' : 'none'}" stroke-width="1.5" stroke-miterlimit="10"/>
          <path d="M2.37988 18.3499V8.5499C2.37988 7.1499 2.97988 6.6499 4.37988 6.6499H5.37988C6.77988 6.6499 7.37988 7.1499 7.37988 8.5499V18.3499C7.37988 19.7499 6.77988 20.2499 5.37988 20.2499H4.37988C2.97988 20.2499 2.37988 19.7499 2.37988 18.3499Z" stroke="${isSelected ? selectedColor ?? '#73A8FB' : color}" fill="${isSelected ? selectedColor ?? '#73A8FB' : 'none'}" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          ''';
        break;
      case ActionType.dislike:
        icon = isSelected ? '''
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M15.61 5.50002V15.66C15.61 16.06 15.49 16.45 15.27 16.78L12.54 20.84C12.11 21.49 11.04 21.95 10.13 21.61C9.15002 21.28 8.50002 20.18 8.71002 19.2L9.23002 15.93C9.27002 15.63 9.19002 15.36 9.02002 15.15C8.85002 14.96 8.60002 14.84 8.33002 14.84H4.22002C3.43002 14.84 2.75002 14.52 2.35002 13.96C1.97002 13.42 1.90002 12.72 2.15002 12.01L4.61002 4.52002C4.92002 3.28002 6.27002 2.27002 7.61002 2.27002H11.51C12.18 2.27002 13.12 2.50002 13.55 2.93002L14.83 3.92002C15.32 4.30002 15.61 4.88002 15.61 5.50002Z" fill= '${selectedColor ?? '#FC5656'}'/>
          <path d="M18.7899 17.61H19.8199C21.3699 17.61 21.9999 17.01 21.9999 15.53V5.48002C21.9999 4.00002 21.3699 3.40002 19.8199 3.40002H18.7899C17.2399 3.40002 16.6099 4.00002 16.6099 5.48002V15.54C16.6099 17.01 17.2399 17.61 18.7899 17.61Z" fill='${selectedColor ?? '#FC5656'}'/>
          </svg>
          ''' : '''
         <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M16.52 5.6499L13.42 3.2499C13.02 2.8499 12.12 2.6499 11.52 2.6499H7.71998C6.51998 2.6499 5.21998 3.5499 4.91998 4.7499L2.51998 12.0499C2.01998 13.4499 2.91998 14.6499 4.41998 14.6499H8.41998C9.01998 14.6499 9.51998 15.1499 9.41998 15.8499L8.91998 19.0499C8.71998 19.9499 9.31998 20.9499 10.22 21.2499C11.02 21.5499 12.02 21.1499 12.42 20.5499L16.52 14.4499" stroke="${isSelected ? selectedColor ?? '#FC5656' : color}" fill="${isSelected ? selectedColor ?? '#FC5656' : 'none'}" stroke-width="1.5" stroke-miterlimit="10"/>
          <path d="M21.6199 5.65V15.45C21.6199 16.85 21.0199 17.35 19.6199 17.35H18.6199C17.2199 17.35 16.6199 16.85 16.6199 15.45V5.65C16.6199 4.25 17.2199 3.75 18.6199 3.75H19.6199C21.0199 3.75 21.6199 4.25 21.6199 5.65Z" stroke="${isSelected ? selectedColor ?? '#FC5656' : color}" fill="${isSelected ? selectedColor ?? '#FC5656' : 'none'}" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
          </svg> 
          ''';
    }

    return GestureDetector(
      onTap: () {
        onToggle(!isSelected);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: SvgPicture.string(icon, height: 25,),
      ),
    );
  }
}
