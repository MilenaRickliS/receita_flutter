import 'package:flutter/material.dart';
import 'package:receita_flutter/detalhes.dart';

void main(){
  runApp(const FavoritosPage(favoritos: [],));
}

class FavoritosPage extends StatelessWidget {
  final List<Map<String, String>> favoritos;

  const FavoritosPage({super.key, required this.favoritos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favoritos',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 228, 224, 193),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: favoritos.length,
        itemBuilder: (context, index) {
          final receita = favoritos[index];
          return ListTile(
            
            title: Hero(
                  tag: 'recipe_name_${receita['nome']}',
                  child: Text(receita['nome']!),
            ),
            subtitle: Text(receita['descricao']!),
            leading: Hero(
              tag: receita['imagem']!, 
              child: Image.asset(receita['imagem']!, width: 50, height: 50, fit: BoxFit.cover),
            ),
            onTap: () {
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
          );
        },
      ),
    );
  }
}
