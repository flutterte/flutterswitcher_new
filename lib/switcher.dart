/*
 * Copyright (c) 2019 CHANGLEI. All rights reserved.
 */

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

const Duration _kDelayedDuration = Duration(milliseconds: 2000);
const int _kScrollDelta = 30;
const int _kMaxScrollDelta = 1000;

class Switcher extends StatefulWidget {
  final List<Widget> children;
  final double spacing;
  final int scrollDelta;
  final Duration delayedDuration;
  final Curve curve;
  final Widget? placeholder;
  final Axis _scrollDirection;

  const Switcher.vertical({
    Key? key,
    required this.children,
    this.scrollDelta = _kScrollDelta,
    this.delayedDuration = _kDelayedDuration,
    this.curve = Curves.linearToEaseOut,
    this.placeholder,
  })  : assert(scrollDelta != null &&
            scrollDelta > 0 &&
            scrollDelta <= _kMaxScrollDelta),
        assert(delayedDuration != null),
        assert(curve != null),
        spacing = 0,
        _scrollDirection = Axis.vertical,
        super(key: key);

  const Switcher.horizontal({
    Key? key,
    required this.children,
    this.scrollDelta = _kScrollDelta,
    this.delayedDuration = _kDelayedDuration,
    this.curve = Curves.linear,
    this.placeholder,
    this.spacing = 10,
  })  : assert(scrollDelta != null &&
            scrollDelta > 0 &&
            scrollDelta <= _kMaxScrollDelta),
        assert(delayedDuration != null),
        assert(curve != null),
        assert(spacing != null && spacing >= 0 && spacing < double.infinity),
        _scrollDirection = Axis.horizontal,
        super(key: key);

  @override
  _SwitcherState createState() => _SwitcherState();
}

class _SwitcherState extends State<Switcher> {
  final ScrollController _controller = ScrollController();

  int _childCount = 0;
  int _selectedIndex = 0;
  Timer? _timer;

  _initalizationElements() {
    _childCount = 0;
    if (widget.children != null) {
      _childCount = widget.children.length;
    }
    if (_childCount > 0 && widget._scrollDirection == Axis.vertical) {
      _childCount++;
    }
  }

  _initializationScroll() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (!mounted) {
        return;
      }
      var renderBox = context?.findRenderObject() as RenderBox;
      if (!_controller.hasClients ||
          _childCount == 0 ||
          renderBox == null ||
          !renderBox.hasSize) {
        return;
      }
      var position = _controller.position;
      _timer?.cancel();
      _timer = null;
      position.moveTo(0);
      _selectedIndex = 0;
      if (widget._scrollDirection == Axis.vertical) {
        _animateVertical(renderBox.size.height);
      } else {
        var maxScrollExtent = position.maxScrollExtent;
        _animateHorizonal(maxScrollExtent, false);
      }
    });
  }

  _animateVertical(double extent) {
    if (!_controller.hasClients || widget._scrollDirection != Axis.vertical) {
      return;
    }
    if (_selectedIndex == _childCount - 1) {
      _selectedIndex = 0;
      _controller.jumpTo(0);
    }
    _timer?.cancel();
    _timer = Timer(widget.delayedDuration, () {
      _selectedIndex++;
      var duration = _computeScrollDuration(extent);
      _controller
          .animateTo(extent * _selectedIndex,
              duration: duration, curve: widget.curve)
          .whenComplete(() {
        _animateVertical(extent);
      });
    });
  }

  _animateHorizonal(double extent, bool needsMoveToTop) {
    if (!_controller.hasClients || widget._scrollDirection != Axis.horizontal) {
      return;
    }
    _timer?.cancel();
    _timer = Timer(widget.delayedDuration, () {
      if (needsMoveToTop) {
        _controller.jumpTo(0);
        _animateHorizonal(extent, false);
      } else {
        var duration = _computeScrollDuration(extent);
        _controller
            .animateTo(extent, duration: duration, curve: widget.curve)
            .whenComplete(() {
          _animateHorizonal(extent, true);
        });
      }
    });
  }

  Duration _computeScrollDuration(double extent) {
    return Duration(
        milliseconds:
            (extent * Duration.millisecondsPerSecond / widget.scrollDelta)
                .floor());
  }

  @override
  void initState() {
    super.initState();
    _initalizationElements();
    _initializationScroll();
  }

  @override
  void didUpdateWidget(Switcher oldWidget) {
    var childrenChanged =
        (widget.children?.length ?? 0) != (oldWidget.children?.length ?? 0);
    if (widget._scrollDirection != oldWidget._scrollDirection ||
        childrenChanged) {
      _initalizationElements();
      _initializationScroll();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_childCount == 0) {
      return widget.placeholder ?? SizedBox.shrink();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: constraints,
          child: ListView.separated(
            itemCount: _childCount,
            physics: NeverScrollableScrollPhysics(),
            controller: _controller,
            scrollDirection: widget._scrollDirection,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final child = widget.children[index % widget.children.length];
              return Container(
                alignment: Alignment.centerLeft,
                height: constraints.constrainHeight(),
                child: child,
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                width: widget.spacing,
              );
            },
          ),
        );
      },
    );
  }
}
