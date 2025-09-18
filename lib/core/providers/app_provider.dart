import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../features/survey/provider/survey_provider.dart';

final List<SingleChildWidget> appProvider = [
  ChangeNotifierProvider(create: (_) => SurveyProvider()),
];