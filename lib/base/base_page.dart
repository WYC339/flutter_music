import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import 'base_view_model.dart';

abstract class BasePage<vm extends BaseViewModel> extends StatefulWidget {
  const BasePage({super.key});

  @override
  State createState() {
    return _BasePageState<vm>();
  }

  vm createViewModel(BuildContext context);

  Widget build(BuildContext context);
}

class _BasePageState<vm extends BaseViewModel> extends State<BasePage<vm>> with WidgetsBindingObserver {
  late vm _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.createViewModel(context);
    // 注册页面状态监听器
    WidgetsBinding.instance.addObserver(this);
  }


  @override
  void dispose() {
    _viewModel.dispose();
    // 移除页面状态监听器
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<vm>.value(
      value: _viewModel,
      child: Builder(builder: (context) => widget.build(context)),
    );
  }
}
