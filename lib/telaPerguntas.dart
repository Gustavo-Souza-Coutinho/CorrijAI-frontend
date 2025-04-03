import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TelaPerguntas extends StatefulWidget {
  final int idAluno; // Passar o ID do aluno para a tela

  const TelaPerguntas({Key? key, required this.idAluno}) : super(key: key);

  @override
  State<TelaPerguntas> createState() => _TelaPerguntasState();
}

class _TelaPerguntasState extends State<TelaPerguntas> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  List<String> _perguntas = [];
  List<String> _respostas = [];
  int _currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadPerguntas();
  }

  Future<void> _loadPerguntas() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.0.130:5000/perguntas'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data is Map<String, dynamic> && data['perguntas'] is List) {
          setState(() {
            _perguntas = List<String>.from(
                data['perguntas'].map((pergunta) => pergunta['texto']));
            if (_perguntas.isNotEmpty) {
              _messages.add({"ia": _perguntas[_currentQuestionIndex]});
            } else {
              _messages.add({"ia": "Nenhuma pergunta disponível no momento."});
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Erro: Formato de resposta inesperado!'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Erro ao carregar perguntas. Código: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar perguntas: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    String userMessage = _controller.text;

    if (userMessage.isNotEmpty && _currentQuestionIndex < _perguntas.length) {
      setState(() {
        _messages.add({"user": userMessage});
        _respostas.add(userMessage);
        _controller.clear();
        _scrollToBottom();

        if (_currentQuestionIndex < _perguntas.length - 1) {
          _currentQuestionIndex++;
          _messages.add({"ia": _perguntas[_currentQuestionIndex]});
        } else {
          _corrigirRespostas();
        }
      });
    }
  }

  Future<void> _corrigirRespostas() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.0.130:5000/corrigir'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id_aluno": widget.idAluno,
          "perguntas": _perguntas,
          "respostas": _respostas,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var nota = data['nota'];
        setState(() {
          _messages.add({
            "ia":
                "Sua nota é $nota%. Vamos revisar os pontos que você pode melhorar."
          });
        });
        _scrollToBottom();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Você acertou $nota%!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Erro ao corrigir respostas. Código: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao corrigir respostas: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Responder Perguntas"),
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
      ),
      backgroundColor: const Color.fromARGB(255, 19, 20, 30),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(10.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isUser = _messages[index].containsKey("user");
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blueAccent : Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      isUser
                          ? _messages[index]["user"]!
                          : _messages[index]["ia"]!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black,
                      hintText: 'Digite sua resposta...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15.0),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.grey),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
