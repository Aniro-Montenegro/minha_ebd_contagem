import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:minha_ebd/config/config_colors.dart';
import 'package:minha_ebd/fragments/menu_icon_button.dart';
import 'package:minha_ebd/models/igreja.dart';

class IgrejaPage extends StatefulWidget {
  const IgrejaPage({super.key});

  @override
  State<IgrejaPage> createState() => _IgrejaPageState();
}

class _IgrejaPageState extends State<IgrejaPage> {
  static const String igrejaKey = 'igreja_principal';

  final TextEditingController _controller = TextEditingController();
  bool _editando = false;

  late Box<Igreja> igrejaBox;

  @override
  void initState() {
    super.initState();
    igrejaBox = Hive.box<Igreja>('igrejas');

    final igreja = igrejaBox.get(igrejaKey);
    if (igreja != null) {
      _controller.text = igreja.nome;
    }
  }

  void _salvarIgreja() async {
    final nome = _controller.text.trim();

    if (nome.isEmpty) return;

    await igrejaBox.put(igrejaKey, Igreja(nome: nome));

    setState(() {
      _editando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final igreja = igrejaBox.get(igrejaKey);

    return Scaffold(
      appBar: AppBar(
        leading: MenuIconButton(),
        title: Text(
          'Igreja',
          style: TextStyle(color: ConfigColors.textAppBarTitle),
        ),
        backgroundColor: ConfigColors.primaryBlue,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _editando = !_editando;
          });
        },
        child: Icon(_editando ? Icons.close : Icons.edit),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child:
              _editando
                  ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          labelText: 'Nome da Igreja',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _salvarIgreja,
                          child: const Text('Salvar'),
                        ),
                      ),
                    ],
                  )
                  : igreja == null
                  ? const Text(
                    'Cadastre o nome de sua igreja',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  )
                  : Text(
                    igreja.nome,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
        ),
      ),
    );
  }
}
