import 'package:two_oss/model/class/person.dart';
import 'package:two_oss/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class DatabaseRepository {
  Store? store;

  DatabaseRepository();

  Future<void> initStore() async {
    if (store != null) {
      return;
    }
    final docsDir = await getApplicationDocumentsDirectory();
    store = await openStore(directory: path.join(docsDir.path, "sign-in"));
  }

  Future<Person?> getPerson() async {
    await initStore();
    final box = Box<Person>(store!);
    List<Person> persons = box.getAll();
    // We should only have one person in the database
    if (persons.length == 0) {
      return null;
    } else {
      return persons[0];
    }
  }

  Future<void> savePerson(Person person) async {
    await initStore();
    final box = Box<Person>(store!);
    box.removeAll();
    box.put(person);
  }
}
