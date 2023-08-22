import 'package:flutter/material.dart';

Future<dynamic> showDialogContent(
    {required BuildContext context,
    required Widget content,
    String? title}) async {
  return await showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    context: context,
    pageBuilder: (_, __, ___) {
      return Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(32),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: 1,
                        offset: Offset(0, 0),
                        spreadRadius: 1)
                  ],
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 50),
                        title != null && title.isNotEmpty
                            ? Text(title)
                            : const SizedBox(),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: IconButton(
                            iconSize: 20,
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
                      width: double.infinity,
                      child: content,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, -1), end: const Offset(0, 0))
            .animate(anim),
        child: child,
      );
    },
  );
}
