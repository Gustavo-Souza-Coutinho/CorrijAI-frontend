import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ListarNotas extends StatefulWidget {
  const ListarNotas({Key? key}) : super(key: key);

  @override
  _ListarNotasState createState() => _ListarNotasState();
}

class _ListarNotasState extends State<ListarNotas> {
  List<dynamic> alunos = []; // Lista de alunos
  List<dynamic> respostas = []; // Lista de respostas (inicialmente vazia)

  @override
  void initState() {
    super.initState();
    fetchAlunos();
  }

  // Função para buscar a lista de alunos
  Future<void> fetchAlunos() async {
    const String url =
        'http://10.0.0.130:5000/alunos_notas'; // Altere para o endereço correto
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          alunos = json.decode(response.body); // Preenche a lista de alunos
        });
      } else {
        throw Exception('Erro ao carregar alunos');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }

  // Função para buscar as respostas de um aluno
  Future<void> fetchRespostas(int idAluno) async {
    final String url =
        'http://10.0.0.130:5000/alunos_respostas?id=$idAluno'; // Endpoint para pegar respostas do aluno
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          respostas = json.decode(
              response.body)['respostas']; // Preenche a lista de respostas
        });
        // Exibe o dialog automaticamente após buscar as respostas
        _showRespostasDialog();
      } else {
        throw Exception('Erro ao carregar respostas');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }

  // Função para exibir o AlertDialog com as respostas
  void _showRespostasDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Respostas do Aluno"),
          content: SingleChildScrollView(
            child: Column(
              children: respostas.map((resposta) {
                return ListTile(
                  title: Text(
                    'Pergunta: ${resposta['pergunta_texto']}',
                    style: const TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    'Resposta: ${resposta['resposta']}',
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
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
      body: alunos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: alunos.length,
              itemBuilder: (context, index) {
                final aluno = alunos[index];
                return Card(
                  color: const Color.fromARGB(255, 30, 30, 40),
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      aluno['nome'],
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    subtitle: Text(
                      'ID: ${aluno['id']} | Nota: ${aluno['nota']}%',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    onTap: () {
                      // Ao clicar no aluno, busca as respostas desse aluno e exibe o popup
                      fetchRespostas(aluno['id']);
                    },
                  ),
                );
              },
            ),
    );
  }
}
