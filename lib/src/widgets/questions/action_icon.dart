import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ActionType { bookmark, like, dislike }

class ActionButtons extends StatelessWidget {
  final bool bookmarked;
  final bool liked;
  final bool disliked;

  final String unselectedColor;
  final String selectedBookmarkColor;
  final String selectedLikeColor;
  final String selectedDislikeColor;

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
    required this.unselectedColor,
    required this.selectedBookmarkColor,
    required this.selectedLikeColor,
    required this.selectedDislikeColor,
    required this.onBookmark,
    required this.onLike,
    required this.onDislike,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ActionButton(
              unselectedColor: unselectedColor,
              selectedColor: selectedBookmarkColor,
              isSelected: bookmarked,
              onToggle: onBookmark,
              actionType: ActionType.bookmark),
          ActionButton(
              unselectedColor: unselectedColor,
              selectedColor: selectedBookmarkColor,
              isSelected: liked,
              onToggle: onLike,
              actionType: ActionType.like),
          ActionButton(
              unselectedColor: unselectedColor,
              selectedColor: selectedBookmarkColor,
              isSelected: disliked,
              onToggle: onDislike,
              actionType: ActionType.dislike),
        ],
      ),
    );
  }
}

class ActionButton extends StatefulWidget {
  final ActionType actionType;
  final String unselectedColor;
  final String selectedColor;
  final bool isSelected;
  final void Function(bool isSelected) onToggle;

  const ActionButton({
    super.key,
    required this.unselectedColor,
    required this.selectedColor,
    required this.isSelected,
    required this.onToggle,
    required this.actionType,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool isSelected = false;

  @override
  void initState() {
    isSelected = widget.isSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String icon = '';

    switch (widget.actionType) {
      case ActionType.bookmark:
        icon = '''
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M12.45 17.4C12.1833 17.2 11.8167 17.2 11.55 17.4L8.35 19.8C6.86672 20.9125 4.75 19.8541 4.75 18V5C4.75 3.75736 5.75736 2.75 7 2.75H17C18.2426 2.75 19.25 3.75736 19.25 5V18C19.25 19.8541 17.1333 20.9125 15.65 19.8L12.45 17.4Z" stroke="${isSelected ? widget.selectedColor : widget.unselectedColor}" fill="${isSelected ? widget.selectedColor : 'none'}" stroke-width="1.5" stroke-linejoin="round"/>
          <path fill-rule="evenodd" clip-rule="evenodd" d="M8 7C8 6.44772 8.44772 6 9 6H15C15.5523 6 16 6.44772 16 7C16 7.55228 15.5523 8 15 8H9C8.44772 8 8 7.55228 8 7Z" fill=${isSelected ? 'white' : widget.unselectedColor}/>
          </svg>
          ''';
        break;
      case ActionType.like:
        icon = '''
      <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path d="M7.47998 18.35L10.58 20.75C10.98 21.15 11.88 21.35 12.48 21.35H16.28C17.48 21.35 18.78 20.45 19.08 19.25L21.48 11.95C21.98 10.55 21.08 9.34997 19.58 9.34997H15.58C14.98 9.34997 14.48 8.84997 14.58 8.14997L15.08 4.94997C15.28 4.04997 14.68 3.04997 13.78 2.74997C12.98 2.44997 11.98 2.84997 11.58 3.44997L7.47998 9.54997" stroke="${isSelected ? widget.selectedColor : widget.unselectedColor}" fill="${isSelected ? widget.selectedColor : 'none'}" stroke-width="1.5" stroke-miterlimit="10"/>
          <path d="M2.37988 18.3499V8.5499C2.37988 7.1499 2.97988 6.6499 4.37988 6.6499H5.37988C6.77988 6.6499 7.37988 7.1499 7.37988 8.5499V18.3499C7.37988 19.7499 6.77988 20.2499 5.37988 20.2499H4.37988C2.97988 20.2499 2.37988 19.7499 2.37988 18.3499Z" stroke="${isSelected ? widget.selectedColor : widget.unselectedColor}" fill="${isSelected ? widget.selectedColor : 'none'}" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          ''';
        break;
      case ActionType.dislike:
        icon = '''
      <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path d="M16.52 5.6499L13.42 3.2499C13.02 2.8499 12.12 2.6499 11.52 2.6499H7.71998C6.51998 2.6499 5.21998 3.5499 4.91998 4.7499L2.51998 12.0499C2.01998 13.4499 2.91998 14.6499 4.41998 14.6499H8.41998C9.01998 14.6499 9.51998 15.1499 9.41998 15.8499L8.91998 19.0499C8.71998 19.9499 9.31998 20.9499 10.22 21.2499C11.02 21.5499 12.02 21.1499 12.42 20.5499L16.52 14.4499" stroke="${isSelected ? widget.selectedColor : widget.unselectedColor}" fill="${isSelected ? widget.selectedColor : 'none'}" stroke-width="1.5" stroke-miterlimit="10"/>
          <path d="M21.6199 5.65V15.45C21.6199 16.85 21.0199 17.35 19.6199 17.35H18.6199C17.2199 17.35 16.6199 16.85 16.6199 15.45V5.65C16.6199 4.25 17.2199 3.75 18.6199 3.75H19.6199C21.0199 3.75 21.6199 4.25 21.6199 5.65Z" stroke="${isSelected ? widget.selectedColor : widget.unselectedColor}" fill="${isSelected ? widget.selectedColor : 'none'}" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
          ''';
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          widget.onToggle(isSelected);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SvgPicture.string(icon),
      ),
    );
  }
}
