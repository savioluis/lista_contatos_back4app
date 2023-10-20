import 'package:lista_contatos/repository/contato_repository.dart';
import 'package:lista_contatos/services/http_provider.dart';
import 'package:lista_contatos/pages/lista_contatos_page.dart';
import 'package:flutter/material.dart';

void main() {
  final httpProvider = HttpProvider.back4app();
  final contactRepository = ContatoRepository(httpProvider);

  runApp(
    AppInjections(
      httpProvider: httpProvider,
      contactRepository: contactRepository,
      child: ListaContatosBack4App(),
    ),
  );
}

class ListaContatosBack4App extends StatelessWidget {
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
      home: ListaContatosPage(
        repository: contactRepository,
      ),
    );
  }
}

class AppInjections extends InheritedWidget {
  final HttpProvider httpProvider;
  final ContatoRepository contactRepository;

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
