import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: TelaLogin(),
    debugShowCheckedModeBanner: false,
  ));
}

class TelaLogin extends StatelessWidget {
  TextEditingController controllerLogin = TextEditingController();
  TextEditingController controllerSenha = TextEditingController();
  final List<String> login = ["claralinda", "heitorlindo", "outros"];
  final String senha = "12345";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela de Login"),
        backgroundColor: Colors.pink[900],
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: TextField(
              controller: controllerLogin,
              decoration: InputDecoration(hintText: "Insira o nome"),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: TextField(
              controller: controllerSenha,
              decoration: InputDecoration(hintText: "Insira a senha"),
              obscureText: true,
            ),
          ),
          Container(
            margin: EdgeInsets.all(25),
            child: ElevatedButton(
              onPressed: () {
                if ((controllerLogin.text == login[0] ||
                        controllerLogin.text == login[1]) &&
                    controllerSenha.text == senha) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Diario(),
                    ),
                  );
                } else {
                  print("Algo deu errado, tente novamente!");
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.pink[900],
                backgroundColor: Colors.white, // Text Color (Foreground color)
              ),
              child: const Text("Entrar"),
            ),
          ),
        ],
      ),
    );
  }
}

class Diario extends StatefulWidget {
  @override
  _DiarioState createState() => _DiarioState();
}

class _DiarioState extends State<Diario> {
  List<Map<String, String>> listaItens = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Diário"),
        backgroundColor: Colors.pink[900],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 50,
          crossAxisSpacing: 700,
        ),
        itemCount: listaItens.length,
        itemBuilder: (context, index) {
          return Card(
            child: InkWell(
              onTap: () {
                _visualizarConfissao(listaItens[index]['titulo']!,
                    listaItens[index]['sobre']!, listaItens[index]['data']!);
              },
              onLongPress: () {
                setState(() {
                  listaItens.removeAt(index);
                });
              },
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listaItens[index]['titulo']!,
                      style: TextStyle(fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Text(
                      listaItens[index]['data']!,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormDiario(),
            ),
          ).then((novoItem) {
            if (novoItem != null) {
              setState(() {
                listaItens.add(novoItem);
              });
            }
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink[900],
      ),
    );
  }

  void _visualizarConfissao(String titulo, String sobre, String data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confissão"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Data: $data"),
              SizedBox(height: 10),
              Text("Título: $titulo"),
              SizedBox(height: 10),
              Text("Confissão: $sobre"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Fechar"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.pink[900],
                backgroundColor: Colors.white, // Text Color (Foreground color)
              ),
            ),
          ],
        );
      },
    );
  }
}

class FormDiario extends StatefulWidget {
  @override
  _FormDiarioState createState() => _FormDiarioState();
}

class _FormDiarioState extends State<FormDiario> {
  TextEditingController controllerTitulo = TextEditingController();
  TextEditingController controllerSobre = TextEditingController();
  TextEditingController controllerData = TextEditingController();

// link de onde achei o calendario: https://api.flutter.dev/flutter/material/showDatePicker.html e https://medium.flutterdevs.com/date-and-time-picker-in-flutter-72141e7531c
// link que achei a mudanca de cor: https://github.com/flutter/flutter/issues/58254
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  Color.fromARGB(255, 136, 14, 79), // Cabeçalho do calendário
              onPrimary: Colors.white, // Texto do cabeçalho
              onSurface: Color.fromARGB(255, 121, 8, 68), // Texto dos dias
            ),
            dialogBackgroundColor: Colors.pink[50], // Fundo do diálogo
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        controllerData.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comece Escrever"),
        backgroundColor: Colors.pink[900],
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: TextField(
              controller: controllerTitulo,
              decoration: InputDecoration(hintText: "Frase de efeito"),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: TextField(
              controller: controllerSobre,
              decoration:
                  InputDecoration(hintText: "Como você está se sentindo?"),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: TextField(
              readOnly: true, // eu pesquisei e esse é pra nn editar a linha lá
              controller: controllerData,
              decoration: InputDecoration(
                  hintText: "Data desta confissão",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () {
                      _selectDate(context);
                    },
                  )),
            ),
          ),
          Container(
            margin: EdgeInsets.all(25),
            child: ElevatedButton(
              onPressed: () {
                if (controllerTitulo.text.isNotEmpty &&
                    controllerSobre.text.isNotEmpty &&
                    controllerData.text.isNotEmpty) {
                  Navigator.pop(
                    context,
                    {
                      'titulo': controllerTitulo.text,
                      'sobre': controllerSobre.text,
                      'data': controllerData.text,
                    },
                  );
                } else {
                  // Pode exibir um aviso ao usuário se algum campo estiver vazio
                }
              },
              child: Text("Salva"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.pink[900],
                backgroundColor: Colors.white, // Text Color (Foreground color)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
