import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../features/staffs/data/staff_repository.dart';

class AppProviders {
  static List<SingleChildWidget> buildProviders() {
    return [ChangeNotifierProvider(create: (_) => StaffRepository())];
  }
}
