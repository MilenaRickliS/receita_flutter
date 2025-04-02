import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    home: EditarReceitaPage(
      receita: {
        'nome': 'Guacamole',
        'descricao': 'Delicious Mexican dip.',
        'imagem': 'assets/guacamole.jpg',
        'detalhes': 'Ingredients: Avocado, lime, salt.'
      },
      onEdit: (Map<String, String> updatedReceita) {
        // Handle updated recipe
        print('Receita atualizada: $updatedReceita');
      },
    ),
  ));
}

class EditarReceitaPage extends StatefulWidget {
  final Map<String, String> receita;
  final Function(Map<String, String>) onEdit;

  const EditarReceitaPage({super.key, required this.receita, required this.onEdit});

  @override
  _EditarReceitaPageState createState() => _EditarReceitaPageState();
}

class _EditarReceitaPageState extends State<EditarReceitaPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;
  late TextEditingController _ingredientesController;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with current recipe details
    _nomeController = TextEditingController(text: widget.receita['nome']);
    _descricaoController = TextEditingController(text: widget.receita['descricao']);
    _ingredientesController = TextEditingController(text: widget.receita['detalhes']);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _ingredientesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Receita'),
        backgroundColor: Color.fromARGB(255, 228, 224, 193),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome da Receita'),
                validator: (value) => value!.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (value) => value!.isEmpty ? 'Informe a descrição' : null,
              ),
              TextFormField(
                controller: _ingredientesController,
                decoration: InputDecoration(labelText: 'Ingredientes e Preparo'),
                validator: (value) => value!.isEmpty ? 'Informe os ingredientes' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedReceita = {
                      'nome': _nomeController.text,
                      'descricao': _descricaoController.text,
                      'imagem': widget.receita['imagem']!,
                      'detalhes': _ingredientesController.text,
                    };
                    widget.onEdit(updatedReceita);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 72, 41, 30),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Salvar Alterações',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
