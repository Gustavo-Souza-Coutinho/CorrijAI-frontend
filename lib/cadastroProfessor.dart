import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CadastroProfessorPage extends StatefulWidget {
  @override
  _CadastroProfessorPageState createState() => _CadastroProfessorPageState();
}

class _CadastroProfessorPageState extends State<CadastroProfessorPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmarEmailController =
      TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  bool _isButtonPressed = false;

  void _cadastrarProfessor() async {
    if (_formKey.currentState!.validate()) {
      final String nome = _nomeController.text.trim();
      final String email = _emailController.text.trim();
      final String confirmarEmail = _confirmarEmailController.text.trim();
      final String senha = _senhaController.text.trim();

      if (email != confirmarEmail) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Os e-mails não correspondem!')),
        );
        return;
      }

      final url = Uri.parse('http://10.0.0.130:5000/cadastrar_usuario');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nome': nome,
          'email': email,
          'senha': senha,
          'flg_tipo': 'P', // 'P' para professor
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro realizado com sucesso!')),
        );
        Navigator.pop(context); // Voltar para a tela anterior
      } else {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );
      }
    }
  }

  Widget buildCustomTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 18.0, color: Colors.grey),
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        hintStyle: const TextStyle(color: Colors.grey),
        fillColor: Colors.black,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: Colors.grey),
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
    );
  }

  Widget buildSubmitButton() {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isButtonPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isButtonPressed = false;
        });
        _cadastrarProfessor();
      },
      onTapCancel: () {
        setState(() {
          _isButtonPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color:
              _isButtonPressed ? Colors.white.withOpacity(0.3) : Colors.black,
          borderRadius: BorderRadius.circular(10),
          boxShadow: _isButtonPressed
              ? [const BoxShadow(color: Colors.white, blurRadius: 10)]
              : [],
        ),
        alignment: Alignment.center,
        child: const Text(
          'Cadastrar',
          style: TextStyle(
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
        backgroundColor: const Color.fromARGB(255, 19, 20, 30),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0, // Alinha com o estilo da tela de login
      ),
      backgroundColor: const Color.fromARGB(255, 19, 20, 30),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildCustomTextField(
                controller: _nomeController,
                hintText: 'Nome Completo',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              buildCustomTextField(
                controller: _emailController,
                hintText: 'E-mail',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              buildCustomTextField(
                controller: _confirmarEmailController,
                hintText: 'Confirmar E-mail',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              buildCustomTextField(
                controller: _senhaController,
                hintText: 'Senha',
                prefixIcon: Icons.lock_outline,
                obscureText: true,
              ),
              const SizedBox(height: 40),
              buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}
