import 'package:flutter/material.dart';
import 'package:proj_tcc/telaLogin.dart';
import 'telaPerguntas.dart'; // Importa a tela de perguntas

class MenuAluno extends StatefulWidget {
  final int idAluno; // Recebe o ID do aluno

  const MenuAluno({Key? key, required this.idAluno}) : super(key: key);

  @override
  _MenuAlunoState createState() => _MenuAlunoState();
}

class _MenuAlunoState extends State<MenuAluno> {
  bool _isPressedIniciarTeste = false;
  bool _isPressedVoltar = false;

  // Função para construir botões personalizados
  Widget buildMenuButton({
    required String text,
    required VoidCallback onPressed,
    required bool isPressed,
    required VoidCallback onTapDown,
    required VoidCallback onTapCancel,
  }) {
    return GestureDetector(
      onTapDown: (_) => onTapDown(),
      onTapUp: (_) {
        onTapCancel();
        onPressed();
      },
      onTapCancel: onTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 200,
        height: 60,
        decoration: BoxDecoration(
          color: isPressed ? Colors.white.withOpacity(0.3) : Colors.black,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isPressed
              ? [const BoxShadow(color: Colors.white, blurRadius: 10)]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Aluno'),
        backgroundColor: const Color.fromARGB(255, 19, 20, 30),
      ),
      backgroundColor: const Color.fromARGB(255, 19, 20, 30),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              buildMenuButton(
                text: "Iniciar Teste",
                onPressed: () {
                  // Navega para a tela de perguntas
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TelaPerguntas(idAluno: widget.idAluno),
                    ),
                  );
                },
                isPressed: _isPressedIniciarTeste,
                onTapDown: () {
                  setState(() {
                    _isPressedIniciarTeste = true;
                  });
                },
                onTapCancel: () {
                  setState(() {
                    _isPressedIniciarTeste = false;
                  });
                },
              ),
              const SizedBox(height: 40),
              buildMenuButton(
                text: "Voltar",
                onPressed: () {
                  // Vai para a TelaLogin ao invés de voltar na pilha
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Telalogin()),
                  );
                },
                isPressed: _isPressedVoltar,
                onTapDown: () {
                  setState(() {
                    _isPressedVoltar = true;
                  });
                },
                onTapCancel: () {
                  setState(() {
                    _isPressedVoltar = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
