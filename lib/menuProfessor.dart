import 'package:flutter/material.dart';
import 'package:proj_tcc/listarNotas.dart';
import 'cadastrarAluno.dart';
import 'cadastroPerguntas.dart';
import 'telaLogin.dart'; // Certifique-se de importar a tela de login

class MenuProfessor extends StatefulWidget {
  const MenuProfessor({Key? key}) : super(key: key);

  @override
  State<MenuProfessor> createState() => _MenuProfessorState();
}

class _MenuProfessorState extends State<MenuProfessor> {
  bool _isPressedCadastrarPerguntas = false;
  bool _isPressedCadastrarAluno = false;
  bool _isPressedVoltar = false;

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
            fontSize: 18, // Consistente com os botões da tela de login
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 19, 20, 30),

        elevation: 0, // Alinha com o estilo da tela de login
      ),
      backgroundColor: const Color.fromARGB(255, 19, 20, 30),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildMenuButton(
              text: "Cadastrar Perguntas",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CadastroPerguntas()),
                );
              },
              isPressed: _isPressedCadastrarPerguntas,
              onTapDown: () {
                setState(() {
                  _isPressedCadastrarPerguntas = true;
                });
              },
              onTapCancel: () {
                setState(() {
                  _isPressedCadastrarPerguntas = false;
                });
              },
            ),
            const SizedBox(height: 20),
            buildMenuButton(
              text: "Cadastrar Aluno",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CadastrarAluno()),
                );
              },
              isPressed: _isPressedCadastrarAluno,
              onTapDown: () {
                setState(() {
                  _isPressedCadastrarAluno = true;
                });
              },
              onTapCancel: () {
                setState(() {
                  _isPressedCadastrarAluno = false;
                });
              },
            ),
            const SizedBox(height: 20),
            buildMenuButton(
              text: "Listagem de Notas",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ListarNotas()),
                );
              },
              isPressed: _isPressedCadastrarAluno,
              onTapDown: () {
                setState(() {
                  _isPressedCadastrarAluno = false;
                });
              },
              onTapCancel: () {
                setState(() {
                  _isPressedCadastrarAluno = false;
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
    );
  }
}
