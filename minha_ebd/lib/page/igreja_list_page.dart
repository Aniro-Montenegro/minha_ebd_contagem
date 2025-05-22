import 'package:flutter/material.dart';
import 'package:minha_ebd/fragments/appbar_personalizada.dart';
import 'package:minha_ebd/model/igreja_model.dart';
import 'package:minha_ebd/page/igreja_form_page.dart';
import 'package:minha_ebd/repositories/igreja_repository.dart';
import 'package:signals/signals_flutter.dart';

class IgrejaPage extends StatefulWidget {
  const IgrejaPage({super.key});

  @override
  State<IgrejaPage> createState() => _IgrejaPageState();
}

class _IgrejaPageState extends State<IgrejaPage> {
  @override
  void initState() {
    super.initState();
    igrejaRepo.loadIgreja();
  }

  @override
  Widget build(BuildContext context) {
    final igreja = igrejaRepo.igreja;
    final isLoading = igrejaRepo.isLoading;

    return Scaffold(
      appBar: AppBarPersonalizada(titulo: "Igreja"),
      body: Watch((context) {
        return isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : igreja.value == null
            ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Nenhuma igreja cadastrada"),
                  ElevatedButton(
                    onPressed: () => _navigateToForm(context),
                    child: const Text("Cadastrar Igreja"),
                  ),
                ],
              ),
            )
            : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    igreja.value!.nome ?? '',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => _navigateToForm(context, igreja.value),
                        child: const Text("Editar"),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () => igrejaRepo.deleteIgreja(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Remover"),
                      ),
                    ],
                  ),
                ],
              ),
            );
      }),
    );
  }

  void _navigateToForm(BuildContext context, [IgrejaModel? igreja]) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => IgrejaFormPage(igreja: igreja)),
    ).then((_) => igrejaRepo.loadIgreja());
  }
}
