// Représente une personne dans l'application
import 'package:objectbox/objectbox.dart';

@Entity()
class Person {
  @Id()
  int id = 0;
  final String name;
  final List<double> biometricData;

  Person(this.name, this.biometricData);
}