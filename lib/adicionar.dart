import 'package:flutter/material.dart';

void main(){
  runApp(NovaReceitaPage(onAdd: (Map<String, String> novaReceita) {
  var receitas;
  receitas.add(novaReceita);
}));

}

class NovaReceitaPage extends StatefulWidget {
  final Function(Map<String, String>) onAdd;

  const NovaReceitaPage({super.key, required this.onAdd});

  @override
  State<NovaReceitaPage> createState() => _NovaReceitaPageState();
}

class _NovaReceitaPageState extends State<NovaReceitaPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _ingredientesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova Receita'),
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
                    final novaReceita = {
                      'nome': _nomeController.text,
                      'descricao': _descricaoController.text,
                      'imagem': 'assets/receitas.jpg',
                      'detalhes': _ingredientesController.text,
                    };
                    widget.onAdd(novaReceita);
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
                child: Text('Adicionar Receita',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
