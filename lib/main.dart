import 'package:flutter/material.dart';
import 'package:receita_flutter/detalhes.dart';
import 'package:receita_flutter/favoritos.dart';
import 'package:receita_flutter/adicionar.dart';
import 'package:receita_flutter/editar.dart';
import 'dart:async'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 8, 8, 7),
        scaffoldBackgroundColor: Color.fromARGB(255, 255, 235, 124),
        fontFamily: 'Raleway',
      ),
      home: MenuReceitas(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MenuReceitas extends StatefulWidget {
  const MenuReceitas({super.key});

  @override
  _MenuReceitasState createState() => _MenuReceitasState();
}


class _MenuReceitasState extends State<MenuReceitas> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Map<String, String>> favoritos = [];
  double _fontSize = 32; 
  bool _isLarge = true; 
  Timer? _timer; 

  List<Map<String, String>> receitas = [
   {
      'nome': 'Guacamole',
      'descricao': 'Essa pasta mexicana funciona perfeitamente como entrada em almoços e jantares, como petisco se servida junto com nachos ou torradinhas, ou até mesmo em sanduíches para dar mais cremosidade.',
      'imagem': 'assets/guacamole.jpg',
      'detalhes': 'Ingredientes: Abacate, cebola, tomate, limão, sal.\n\nModo de preparo: Amasse o abacate, misture os outros ingredientes e sirva.'
    },
    {
      'nome': 'Ceviche tradicional',
      'descricao': 'O ceviche é uma receita deliciosa e superfácil de ser feita. Originalmente um prato peruano, ele vem da tradição dos pescadores de pescar, cortar, temperar e comer os peixes dentro do próprio barco.',
      'imagem': 'assets/Ceviche.jpeg',
      'detalhes': 'Ingredientes: Peixe fresco, limão, cebola roxa, coentro, pimenta.\n\nModo de preparo: Corte o peixe, tempere com limão e misture os outros ingredientes.'
    },
    {
      'nome': 'Arroz à grega',
      'descricao': 'Arroz à grega é um prato brasileiro que consiste em arroz cozido com passas e legumes picados. Os legumes mais utilizados na preparação do prato são cenoura, ervilhas, milho e cebolinha.',
      'imagem': 'assets/arroz.jpg',
      'detalhes': 'Ingredientes: Arroz, passas, cenoura, ervilhas, milho.\n\nModo de preparo: Cozinhe o arroz e misture os outros ingredientes.'
    },
    {
      'nome': 'Torta de frango',
      'descricao': 'Se você busca praticidade, essa é a receita ideal! Aprenda agora mesmo a fazer essa torta de frango simples e fácil!',
      'imagem': 'assets/tortafrango.jpg',
      'detalhes': 'Ingredientes: Frango, massa, temperos.\n\nModo de preparo: Cozinhe o frango, prepare a massa e asse.'
    },
    {
      'nome': 'Dadinho de tapioca',
      'descricao': 'Um petisco delicioso de boteco que fica perfeito com uma geleia de pimenta: aprenda como fazer dadinho de tapioca!',
      'imagem': 'assets/dadinho.jpg',
      'detalhes': 'Ingredientes: Tapioca, queijo coalho, temperos.\n\nModo de preparo: Misture os ingredientes, molde e frite.'
    },
  ];

  void _toggleFavorito(Map<String, String> receita) {
    setState(() {
      final index = favoritos.indexWhere((fav) => fav['nome'] == receita['nome']);
      if (index >= 0) {
        favoritos.removeAt(index);
      } else {
        favoritos.add(receita);
      }
    });
  }

  void _removerReceita(Map<String, String> receita) {
    final index = receitas.indexOf(receita);
    final removed = receitas.removeAt(index);
    _listKey.currentState!.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: _buildReceitaCard(removed, false),
      ),
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void initState() {
    super.initState();
    _startAnimation(); 
  }

  @override
  void dispose() {
    _timer?.cancel(); 
    super.dispose();
  }

  void _startAnimation() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _isLarge = !_isLarge; 
        _fontSize = _isLarge ? 32 : 36; 
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: _fontSize,
          ),
          child: Text('Receitas'),
        ),
        backgroundColor: Color.fromARGB(255, 228, 224, 193),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritosPage(favoritos: favoritos),
                ),
              );
            },
          ),
        ],
      ),
      body: AnimatedList(
        key: _listKey,
        padding: EdgeInsets.all(20.0),
        initialItemCount: receitas.length,
        itemBuilder: (context, index, animation) {
          final receita = receitas[index];
          final isFavorito = favoritos.any((fav) => fav['nome'] == receita['nome']);

          return SizeTransition(
            sizeFactor: animation,
            child: _buildReceitaCard(receita, isFavorito),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 72, 41, 30),
        child: Icon(Icons.add, color: Colors.white,),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NovaReceitaPage(
                onAdd: (novaReceita) {
                  setState(() {
                    receitas.insert(0, novaReceita);
                    _listKey.currentState!.insertItem(0);
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReceitaCard(Map<String, String> receita, bool isFavorito) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Hero(
            tag: receita['imagem']!, 
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage(receita['imagem']!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                Hero(
                  tag: 'recipe_name_${receita['nome']}',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      receita['nome']!,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  receita['descricao']!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return DetalhesReceita(receita: receita);
                        },
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          
                          var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOut,
                            ),
                          );
                          return FadeTransition(opacity: fadeAnimation, child: child);
                        },
                        transitionDuration: Duration(seconds: 1), 
                      ),
                    );

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 72, 41, 30),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Ver Receita',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isFavorito ? Icons.favorite : Icons.favorite_border,
                        color: isFavorito ? Colors.red : Colors.grey,
                      ),
                      onPressed: () => _toggleFavorito(receita),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.black54),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditarReceitaPage(
                              receita: receita,
                              onEdit: (updatedReceita) {
                                setState(() {
                                  final index = receitas.indexWhere((r) => r['nome'] == receita['nome']);
                                  receitas[index] = updatedReceita;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.black54),
                      onPressed: () => _removerReceita(receita),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
