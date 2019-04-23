import 'package:flutter_bloc_todo/data/data.dart';
import 'package:mockito/mockito.dart';

class MockLocalSource extends Mock implements LocalSource {}

class MockTaskRepository extends Mock implements TaskRepository {}

class MockUserSettingsRepository extends Mock
    implements UserSettingsRepository {}
