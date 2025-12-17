import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// A `ListView` with a nice animation when opening/closing the details view which belongs to a `ListTile`.
/// See https://m2.material.io/design/motion/choreography.html#sequencing.
class ListView2 extends HookWidget {
  const ListView2.builder({
    super.key,
    this.controller,
    this.primary,
    this.physics,
    this.padding,
    this.itemCount,
    required this.itemBuilder,
    required this.itemDetailsBuilder,
    this.onOpeningDetails,
    this.onDetailsClosed,
  });

  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;
  final int? itemCount;
  final Widget Function(BuildContext context, int index, void Function(BuildContext context) openDetails) itemBuilder;
  final Widget Function(BuildContext context, int index, VoidCallback closeDetails) itemDetailsBuilder;
  final void Function(int index)? onOpeningDetails;
  final VoidCallback? onDetailsClosed;


  @override
  Widget build(BuildContext context) {
    final listViewContext = context;
    final animationController = useAnimationController(duration: const Duration(milliseconds: 500));
    final animation = useMemoized(() => CurvedAnimation(parent: animationController, curve: Curves.ease), [animationController]);
    final openedState = useState<({int index, Tween<double> topTween, Tween<double> bottomTween})?>(null);
    final opened = openedState.value;
    final closingRef = useRef(false);

    void closeDetails() {
      if (closingRef.value) {
        return;
      }
      closingRef.value = true;
      animationController.reverse().then((_) {
        openedState.value = null;
        closingRef.value = false;
        onDetailsClosed?.call();
      });
    }

    return PopScope(
      canPop: opened == null,
      onPopInvokedWithResult: (didPop, route) {
        if (didPop) {
          return;
        }
        if (opened != null) {
          closeDetails();
        }
      },
      child: Stack(
        children: [
          // The list view ...
          ListView.builder(
            controller: controller,
            primary: primary,
            physics: physics,
            padding: padding,
            itemCount: itemCount,
            itemBuilder: (context, index) => itemBuilder(context, index, (context) {
              try {
                final listViewRenderBox = listViewContext.findRenderObject() as RenderBox;
                final listViewPos = listViewRenderBox.localToGlobal(Offset.zero);
                final listViewSize = listViewRenderBox.size;
                final listTileRenderBox = context.findRenderObject() as RenderBox;
                final listTilePos = listTileRenderBox.localToGlobal(Offset.zero);
                final listTileSize = listTileRenderBox.size;
                openedState.value = (
                  index: index,
                  topTween: Tween<double>(begin: listTilePos.dy - listViewPos.dy, end: 0),
                  bottomTween: Tween<double>(begin: (listViewPos.dy + listViewSize.height) - (listTilePos.dy + listTileSize.height), end: 0),
                );
                onOpeningDetails?.call(index);
                animationController.forward();
              } catch (error, stack) {
                debugPrintStack(label: 'Failed to open details: $error', stackTrace: stack);
              }
            }),
          ),
          // Scrim ...
          if (opened != null)
            AnimatedBuilder(
              animation: animation,
              builder: (_, _) => IgnorePointer(
                child: Opacity(
                  opacity: animation.value / 2,
                  child: Container(color: Colors.black),
                ),
              ),
            ),
          // The animated details view ...
          if (opened != null)
            AnimatedBuilder(
              animation: animation,
              builder: (_, child) => Positioned(
                top: opened.topTween.evaluate(animation),
                left: 0,
                bottom: opened.bottomTween.evaluate(animation),
                right: 0,
                child: Opacity(opacity: animation.value, child: child!),
              ),
              child: itemDetailsBuilder(context, opened.index, closeDetails),
            ),
        ],
      ),
    );
  }
}
