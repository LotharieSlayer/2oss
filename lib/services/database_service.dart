import 'package:get_it/get_it.dart';
import 'package:two_oss/model/class/person.dart';
import 'package:two_oss/repositories/database/database_repository.dart';

class DatabaseService {
  GetIt _getIt = GetIt.instance;
  late DatabaseRepository _databaseRepository;

  DatabaseService({DatabaseRepository? databaseRepository}) {
    _databaseRepository = databaseRepository ?? _getIt.get<DatabaseRepository>();
  }

  Future<Person?> getRegisteredPerson() async {
    return _databaseRepository.getPerson();
  } 

  Future<void> registerPerson(Person person) async {
    return _databaseRepository.savePerson(person);
  }
}