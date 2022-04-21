import 'package:flutter/material.dart';
import 'package:trapezoid_tabbar/trapezoid_widget.dart';

/// trapezoid_tabbar
/// @Auther: huyue
/// @datetime: 2022/4/20
/// @desc: 梯形tabbar

class TrapezoidTabBar extends StatefulWidget implements PreferredSizeWidget {
  final TabController tabController;
  final double tabHeight;
  final Color selectedColor;
  final Color unselectedColor;
  final Widget? leftTitle;
  final Widget? rightTitle;
  final TextStyle? unselectedLabelStyle;
  final TextStyle? labelStyle;
  final Color? unselectedLabelColor;
  final Color? labelColor;

  const TrapezoidTabBar(
      {Key? key,
      required this.tabController,
      this.tabHeight = 44.0,
      this.selectedColor = Colors.blueAccent,
      this.unselectedColor = Colors.blueGrey,
      this.leftTitle,
      this.rightTitle,
      this.unselectedLabelStyle,
      this.labelStyle,
      this.unselectedLabelColor,
      this.labelColor})
      : assert(tabController.length == 2),
        super(key: key);

  @override
  State<TrapezoidTabBar> createState() => _TrapezoidTabBarState();

  @override
  Size get preferredSize => Size.fromHeight(tabHeight);
}

class _TrapezoidTabBarState extends State<TrapezoidTabBar> {
  bool _leftFlag = true; // 默认选中左边的

  late TabController _tabController; //需要定义一个Controller

  @override
  void initState() {
    super.initState();
    _tabController = widget.tabController;

    _tabController.animation?.addListener(() {
      double? value = _tabController.animation?.value;

      if (value != null && value >= 0.5 && _leftFlag) {
        _leftFlag = false;
      }
      if (value != null && value < 0.5 && !_leftFlag) {
        _leftFlag = true;
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.tabHeight,
      width: double.infinity,
      child: Stack(
          children: _leftFlag
              ? [_buildRightTab(context), _buildLeftTab(context)]
              : [_buildLeftTab(context), _buildRightTab(context)]),
    );
  }

  // 左边tab
  Widget _buildLeftTab(BuildContext context) {
    return Positioned(
      left: 0,
      height: widget.tabHeight,
      width: MediaQuery.of(context).size.width * 0.5 + widget.tabHeight * 0.5,
      child: GestureDetector(
        onTap: () {
          if (!_leftFlag) {
            _tabController.animateTo(0);
          }
        },
        child: _buildLeftTrapezoid(),
      ),
    );
  }

  // 左边梯形
  Widget _buildLeftTrapezoid() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(6)),
          child: TrapezoidContainer(
            width: MediaQuery.of(context).size.width * 0.5 +
                widget.tabHeight * 0.5,
            height: widget.tabHeight,
            backgroundColor: Colors.transparent,
            color: Color.lerp(widget.selectedColor, widget.unselectedColor,
                    _tabController.animation?.value ?? 0.5) ??
                widget.selectedColor,
          ),
        ),
        Center(
          child: _buildStyleTab(context, true, widget.leftTitle),
        )
      ],
    );
  }

  // 右边tab
  Widget _buildRightTab(BuildContext context) {
    return Positioned(
      right: 0,
      height: widget.tabHeight,
      width: MediaQuery.of(context).size.width * 0.5 + widget.tabHeight * 0.5,
      child: GestureDetector(
        onTap: () {
          if (_leftFlag) {
            _tabController.animateTo(1);
          }
        },
        child: _buildRightTrapezoid(),
      ),
    );
  }

  // 斜边在左梯形
  Widget _buildRightTrapezoid() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(topRight: Radius.circular(6)),
          child: TrapezoidContainer(
            width: MediaQuery.of(context).size.width * 0.5 +
                widget.tabHeight * 0.5,
            height: widget.tabHeight,
            position: SlopePosition.LEFT_TOP,
            backgroundColor: Colors.transparent,
            color: Color.lerp(widget.unselectedColor, widget.selectedColor,
                    _tabController.animation?.value ?? 0.5) ??
                widget.unselectedColor,
          ),
        ),
        Center(
          child: _buildStyleTab(context, false, widget.rightTitle),
        )
      ],
    );
  }

  // 动态修改
  Widget? _buildStyleTab(BuildContext context, bool selected, Widget? child) {
    return child == null
        ? null
        : TabStyleWidget(
            animation: _tabController.animation!,
            selected: selected,
            labelColor: widget.labelColor,
            unselectedLabelColor: widget.unselectedLabelColor,
            labelStyle: widget.labelStyle,
            unselectedLabelStyle: widget.unselectedLabelStyle,
            child: child);
  }
}

class TabStyleWidget extends AnimatedWidget {
  const TabStyleWidget({
    Key? key,
    required Animation<double> animation,
    required this.selected,
    required this.labelColor,
    required this.unselectedLabelColor,
    required this.labelStyle,
    required this.unselectedLabelStyle,
    required this.child,
  }) : super(key: key, listenable: animation);

  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final bool selected;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TabBarTheme tabBarTheme = TabBarTheme.of(context);
    final Animation<double> animation = listenable as Animation<double>;

    // To enable TextStyle.lerp(style1, style2, value), both styles must have
    // the same value of inherit. Force that to be inherit=true here.
    final TextStyle defaultStyle = (labelStyle ??
            tabBarTheme.labelStyle ??
            themeData.primaryTextTheme.bodyText1!)
        .copyWith(inherit: true);
    final TextStyle defaultUnselectedStyle = (unselectedLabelStyle ??
            tabBarTheme.unselectedLabelStyle ??
            labelStyle ??
            themeData.primaryTextTheme.bodyText1!)
        .copyWith(inherit: true);
    final TextStyle textStyle = selected
        ? TextStyle.lerp(defaultStyle, defaultUnselectedStyle, animation.value)!
        : TextStyle.lerp(
            defaultUnselectedStyle, defaultStyle, animation.value)!;

    final Color selectedColor = labelColor ??
        tabBarTheme.labelColor ??
        themeData.primaryTextTheme.bodyText1!.color!;
    final Color unselectedColor = unselectedLabelColor ??
        tabBarTheme.unselectedLabelColor ??
        selectedColor.withAlpha(0xB2); // 70% alpha
    final Color color = selected
        ? Color.lerp(selectedColor, unselectedColor, animation.value)!
        : Color.lerp(unselectedColor, selectedColor, animation.value)!;

    return DefaultTextStyle(
      style: textStyle.copyWith(color: color),
      child: IconTheme.merge(
        data: IconThemeData(
          size: 24.0,
          color: color,
        ),
        child: child,
      ),
    );
  }
}
