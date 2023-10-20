import 'package:lista_contatos/contato.dart';
import 'package:lista_contatos/http_provider.dart';
import 'package:lista_contatos/lista_contatos.dart';
import 'package:flutter/material.dart';

void main() {
  final httpProvider = HttpProvider.back4app();
  final contactRepository = ContactRepository(httpProvider);

  // Injection.init();ƒ

  runApp(
    AppInjections(
      httpProvider: httpProvider,
      contactRepository: contactRepository,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final contactRepository = AppInjections.of(context).contactRepository;
    return MaterialApp(
      title: 'Lista de Contatos',
      theme: ThemeData(
        // Tema Claro
        primarySwatch: Colors.purple,
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        // Tema Escuro
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ContactsListPage(
        repository: contactRepository,
      ),
    );
  }
}

class AppInjections extends InheritedWidget {
  final HttpProvider httpProvider;
  final ContactRepository contactRepository;

  AppInjections({
    Key? key,
    required Widget child,
    required this.httpProvider,
    required this.contactRepository,
  }) : super(key: key, child: child);

  static AppInjections of(BuildContext context) {
    final AppInjections? appInjection =
        context.dependOnInheritedWidgetOfExactType<AppInjections>()!;
    if (appInjection != null) return appInjection;
    throw Exception("AppInjections not found");
  }

  @override
  bool updateShouldNotify(covariant AppInjections oldWidget) {
    return httpProvider != oldWidget.httpProvider ||
        contactRepository != oldWidget.contactRepository;
  }
}

// class Injection {
//   static final getIt = GetIt.instance;

//   static void init() {
//     getIt.registerSingleton(ContactRepository());
//   }
// }

// void ovos() {
//   final repository = GetIt.I.get<ContactRepository>();
// }
