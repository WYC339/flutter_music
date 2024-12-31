import 'package:flutter/cupertino.dart';

abstract class BaseViewModel extends ChangeNotifier {
  final BuildContext _context;

  BaseViewModel(this._context);

  BuildContext get context => _context;
}
