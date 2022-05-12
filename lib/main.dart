import 'dart:developer' as dev;
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class Mensagem {
  final String data;

  Mensagem(this.data);

  factory Mensagem.fromJson(Map<String, dynamic> json) {
    return Mensagem(json["data"]!);
  }
}

const url = 'https://positive-vibes-api.herokuapp.com/quotes/random';

Future<Mensagem> fetchMensagens() async {
  final res = await http.get(Uri.parse(url));
  if (res.statusCode == 200) {
    return Mensagem.fromJson(jsonDecode(res.body));
  } else {
    throw Exception('Failed to load message');
  }
}

void main() {
  runApp(const AppMensagens());
}

class AppMensagens extends StatelessWidget {
  const AppMensagens({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  late Future<Mensagem> futureMensagem;

  final _frases = [
    "As pessoas costumam dizer que a motivação não dura sempre. Bem, nem o efeito do banho, por isso recomenda-se diariamente.",
    "Motivação é a arte de fazer as pessoas fazerem o que você quer que elas façam porque elas o querem fazer.",
    "Toda ação humana, quer se torne positiva ou negativa, precisa depender de motivação.",
    "No meio da dificuldade encontra-se a oportunidade.",
    "Lute. Acredite. Conquiste. Perca. Deseje. Espere. Alcance. Invada. Caia. Seja tudo o quiser ser, mas, acima de tudo, seja você sempre.",
    "Eu faço da dificuldade a minha motivação. A volta por cima vem na continuação.",
    "A verdadeira motivação vem de realização, desenvolvimento pessoal, satisfação no trabalho e reconhecimento.",
    "Pedras no caminho? Eu guardo todas. Um dia vou construir um castelo.",
    "É parte da cura o desejo de ser curado.",
    "Tudo o que um sonho precisa para ser realizado é alguém que acredite que ele possa ser realizado."
  ];

  var _fraseGerada = "Clique abaixo para gerar uma frase";

  void _gerarFrase() {
    var numeroSorteado = Random().nextInt(_frases.length);
    _fraseGerada = _frases[numeroSorteado];

    setState(() {});
  }

  void getMessages() {
    futureMensagem = fetchMensagens();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    futureMensagem = fetchMensagens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        decoration:
        const BoxDecoration(color: Colors.black),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            //Image.asset("images/cat_quote.jpg"),
            FutureBuilder<Mensagem>(
                future: futureMensagem,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // return Text(
                    //   snapshot.data!.data,
                    //   textAlign: TextAlign.justify,
                    //   style: const TextStyle(
                    //       fontSize: 20,
                    //       fontStyle: FontStyle.italic,
                    //       color: Colors.white),
                    // );
                    return Stack(
                      children: [
                        Image.asset("images/cat_quote.jpg",
                        width: double.infinity,
                        fit: BoxFit.cover),
                        Positioned(
                         bottom: 80,
                         right: 45,
                         left: 110,
                         child: Text(
                           snapshot.data!.data,
                           textAlign: TextAlign.justify,
                           style: const TextStyle(
                               fontSize: 14,
                               fontStyle: FontStyle.italic,
                               color: Colors.black),
                         ),
                        )
                      ],
                    );
                  } else {
                    return Text(
                      _fraseGerada,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          color: Colors.black),
                    );
                  }
                }),
            ElevatedButton(
              onPressed: getMessages,
              child: const Text("Nova Frase"),
              style: ElevatedButton.styleFrom(primary: Colors.red),
            )
          ],
        ),
      ),
    );
  }
}
