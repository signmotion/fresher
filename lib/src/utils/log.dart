import 'package:logger/logger.dart';

final logger = Logger(
  filter: ProductionFilter(),
  level: Level.debug,
);
