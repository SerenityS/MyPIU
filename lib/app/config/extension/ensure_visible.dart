import 'package:flutter/material.dart';

extension GlobalKeyEnsureVisible on GlobalKey {
  void ensureVisible() {
    final keyContext = currentContext;
    if (keyContext != null) {
      Future.delayed(const Duration(milliseconds: 300)).then((_) {
        Scrollable.ensureVisible(keyContext,
            duration: const Duration(milliseconds: 200), alignmentPolicy: ScrollPositionAlignmentPolicy.explicit);
      });
    }
  }
}
