import 'package:mobx/mobx.dart';
part 'expand.store.g.dart';

class ExpandStore = ExpandStoreBase with _$ExpandStore;

abstract class ExpandStoreBase with Store {
  @observable
  bool isExpanded = false;

  @action
  void toggleExpand() {
    isExpanded = !isExpanded;
  }
}
