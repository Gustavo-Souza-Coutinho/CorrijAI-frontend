import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cadastroProfessor.dart';
import 'menuProfessor.dart';
import 'menuAluno.dart';

class Telalogin extends StatefulWidget {
  const Telalogin({Key? key}) : super(key: key);

  @override
  State<Telalogin> createState() => _TelaloginState();
}

class _TelaloginState extends State<Telalogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _isPressed = false;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.0.130:5000/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'login': email, 'senha': senha}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final bool success = data['success'];
        final String message = data['message'];
        final String tipo = data['tipo']; // Tipo do usuário ('P' ou 'A')
        final int idAluno = data['id'] ?? 0; // ID do aluno (se necessário)

        if (success) {
          if (tipo == 'P') {
            // Substitui a tela atual pelo MenuProfessor
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MenuProfessor()),
            );
          } else if (tipo == 'A') {
            // Substitui a tela atual pelo MenuAluno
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MenuAluno(idAluno: idAluno),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao realizar login. Tente novamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 19, 20, 30),
      body: Column(
        children: [
          const SizedBox(height: 70),
          GestureDetector(
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('imagem/esseaq.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: _emailController,
              style: const TextStyle(fontSize: 18.0, color: Colors.grey),
              decoration: InputDecoration(
                filled: true,
                hintStyle: const TextStyle(color: Colors.grey),
                fillColor: Colors.black,
                hintText: 'Email',
                prefixIcon:
                    const Icon(Icons.email_outlined, color: Colors.grey),
                contentPadding:
                    const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: _senhaController,
              obscureText: true,
              style: const TextStyle(fontSize: 18.0, color: Colors.grey),
              decoration: InputDecoration(
                filled: true,
                hintStyle: const TextStyle(color: Colors.grey),
                fillColor: Colors.black,
                hintText: 'Senha',
                prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                contentPadding:
                    const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTapDown: (_) {
              setState(() {
                _isPressed = true;
              });
            },
            onTapUp: (_) {
              setState(() {
                _isPressed = false;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CadastroProfessorPage()),
              );
            },
            onTapCancel: () {
              setState(() {
                _isPressed = false;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 200,
              height: 60,
              decoration: BoxDecoration(
                color:
                    _isPressed ? Colors.white.withOpacity(0.3) : Colors.black,
                borderRadius: BorderRadius.circular(10),
                boxShadow: _isPressed
                    ? [const BoxShadow(color: Colors.white, blurRadius: 10)]
                    : [],
              ),
              alignment: Alignment.center,
              child: const Text(
                'Cadastrar Professor',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTapDown: (_) {
              setState(() {
                _isPressed = true;
              });
            },
            onTapUp: (_) {
              setState(() {
                _isPressed = false;
                _login();
              });
            },
            onTapCancel: () {
              setState(() {
                _isPressed = false;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 200,
              height: 60,
              decoration: BoxDecoration(
                color:
                    _isPressed ? Colors.white.withOpacity(0.3) : Colors.black,
                borderRadius: BorderRadius.circular(10),
                boxShadow: _isPressed
                    ? [const BoxShadow(color: Colors.white, blurRadius: 10)]
                    : [],
              ),
              alignment: Alignment.center,
              child: const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
