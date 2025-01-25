import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:two_oss/model/mvvm/widget_event_observer.dart';
import 'package:two_oss/pages/ask_login/ask_login_view_model.dart';
import 'package:two_oss/pages/register/register_view.dart';
import 'package:two_oss/services/database_service.dart';

class AskLoginView extends StatefulWidget {
  static String route = '/askLogin';

  const AskLoginView({super.key});

  @override
  State<AskLoginView> createState() => _AskLoginViewState();
}

class _AskLoginViewState extends WidgetEventObserver<AskLoginView> {
  late AskLoginViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = AskLoginViewModel();
    viewModel.subscribe(this);

    GetIt getIt = GetIt.instance;
    DatabaseService databaseService = getIt.get<DatabaseService>();

    databaseService.getRegisteredPerson().then((value) {
      print('BBBBBBBBBBBBBBB');
      print(value);
      if (value == null) {
        Navigator.pushNamed(context, RegisterView.route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('Essayez de vous connecter ?',
              style: TextStyle(fontSize: 30, color: Colors.white)),
          const Text('lothaire.guee@ecole.ensicaen.fr',
              style: TextStyle(fontSize: 20, color: Colors.white)),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Appareil : ',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              Text('Windows NT 10.0',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Localisation : ',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              Text('Caen, France',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  viewModel.clickNo();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                ),
                child: const Text('Non', style: TextStyle(fontSize: 30)),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  viewModel.clickYes(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                ),
                child: const Text('Oui', style: TextStyle(fontSize: 30)),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, RegisterView.route);
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            ),
            child: const Text('Recommencer la détection', style: TextStyle(fontSize: 14)),
          ),
        ])),
      ),
    );
  }
}
