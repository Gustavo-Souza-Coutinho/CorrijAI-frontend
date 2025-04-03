import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CadastroPerguntas extends StatefulWidget {
  const CadastroPerguntas({Key? key}) : super(key: key);

  @override
  State<CadastroPerguntas> createState() => _CadastroPerguntasState();
}

class _CadastroPerguntasState extends State<CadastroPerguntas> {
  final TextEditingController _perguntaController = TextEditingController();
  final List<Map<String, dynamic>> _perguntas = [];
  int? _editingIndex;

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
        final data = jsonDecode(response.body);

        // Verifica se o dado retornado é um Map contendo a chave 'perguntas'
        if (data is Map<String, dynamic> && data['perguntas'] is List) {
          setState(() {
            _perguntas.clear();
            _perguntas
                .addAll(List<Map<String, dynamic>>.from(data['perguntas']));
          });
          print("Perguntas carregadas: $_perguntas");
        } else {
          _showSnackBar('Erro: Formato de resposta inesperado!', Colors.red);
          print("Formato de resposta inesperado: $data");
        }
      } else {
        _showSnackBar(
            'Erro ao carregar perguntas! Código: ${response.statusCode}',
            Colors.red);
      }
    } catch (e) {
      _showSnackBar('Erro ao carregar perguntas: $e', Colors.red);
      print("Erro ao carregar perguntas: $e");
    }
  }

  Future<void> _cadastrarOuEditarPergunta() async {
    final textoPergunta = _perguntaController.text.trim();

    if (textoPergunta.isEmpty) {
      _showSnackBar('O campo da pergunta não pode estar vazio!', Colors.red);
      return;
    }

    try {
      if (_editingIndex != null) {
        // Editar pergunta existente
        final perguntaId = _perguntas[_editingIndex!]["id"];
        final response = await http.put(
          Uri.parse('http://10.0.0.130:5000/perguntas/$perguntaId'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"texto": textoPergunta}),
        );
        if (response.statusCode == 200) {
          setState(() {
            _perguntas[_editingIndex!] = {
              "id": perguntaId,
              "texto": textoPergunta
            };
            _editingIndex = null;
          });
          _showSnackBar('Pergunta atualizada com sucesso!', Colors.green);
        } else {
          _showSnackBar(
              'Erro ao atualizar pergunta! Código: ${response.statusCode}',
              Colors.red);
        }
      } else {
        // Cadastrar nova pergunta
        final response = await http.post(
          Uri.parse('http://10.0.0.130:5000/perguntas'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"texto": textoPergunta}),
        );
        if (response.statusCode == 201) {
          final data = jsonDecode(response.body);
          setState(() {
            _perguntas.add({"id": data['id'], "texto": textoPergunta});
          });
          _showSnackBar('Pergunta cadastrada com sucesso!', Colors.green);
        } else {
          _showSnackBar(
              'Erro ao cadastrar pergunta! Código: ${response.statusCode}',
              Colors.red);
        }
      }
    } catch (e) {
      _showSnackBar('Erro ao processar a requisição: $e', Colors.red);
      print("Erro ao processar a requisição: $e");
    }

    _perguntaController.clear();
  }

  Future<void> _excluirPergunta(int index) async {
    final perguntaId = _perguntas[index]["id"];
    try {
      final response = await http.delete(
        Uri.parse('http://10.0.0.130:5000/perguntas/$perguntaId'),
      );
      if (response.statusCode == 200) {
        setState(() {
          _perguntas.removeAt(index);
        });
        _showSnackBar('Pergunta excluída com sucesso!', Colors.green);
      } else {
        _showSnackBar(
            'Erro ao excluir pergunta! Código: ${response.statusCode}',
            Colors.red);
      }
    } catch (e) {
      _showSnackBar('Erro ao processar exclusão: $e', Colors.red);
      print("Erro ao processar exclusão: $e");
    }
  }

  void _iniciarEdicao(int index) {
    setState(() {
      _editingIndex = index;
      _perguntaController.text = _perguntas[index]["texto"];
    });
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 19, 20, 30),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 19, 20, 30),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _perguntaController,
              style: const TextStyle(color: Colors.grey),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black,
                hintText: _editingIndex == null
                    ? 'Digite a pergunta...'
                    : 'Editar pergunta...',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                print("Botão pressionado!"); // Log para depuração
                _cadastrarOuEditarPergunta();
              },
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: _editingIndex == null ? Colors.black : Colors.orange,
                ),
                alignment: Alignment.center,
                child: Text(
                  _editingIndex == null
                      ? 'Cadastrar Pergunta'
                      : 'Salvar Edição',
                  style: const TextStyle(
                    color: Colors.white, // Texto em cinza, padronizado
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _perguntas.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.black,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        _perguntas[index]['texto'],
                        style: const TextStyle(color: Colors.grey),
                      ),
                      leading: const Icon(Icons.question_answer,
                          color: Colors.blueAccent),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _iniciarEdicao(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Confirmação"),
                                  content: const Text(
                                      "Deseja excluir esta pergunta?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text("Cancelar"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text("Excluir"),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                _excluirPergunta(index);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
