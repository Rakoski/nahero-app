import 'package:flutter/material.dart';

main() {
  var pessoas = [
    {
      'nome': 'Marian',
      'telefone': '(44) 991344-5544',
      'url': 'https://google.com',
    },
    {
      'nome': 'José',
      'telefone': '(44) 991334-5544',
      'url': 'https://microsoft.com',
    },
    {
      'nome': 'João',
      'telefone': '(44) 991314-5544',
      'url': 'https://amazon.com',
    },
  ];

  print(pessoas[1]['nome']);
}

class WidgetPessoaLista extends StatelessWidget {
  var pessoas = [
    {
      'nome': 'Marian',
      'telefone': '(44) 991344-5544',
      'url':
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse2.mm.bing.net%2Fth%3Fid%3DOIP.b_WVYAkHYBeZsz7TNrFBkwHaF3%26pid%3DApi&f=1&ipt=99408573c67ee5fa304966fb561eb3903ae16d0af31bd92b778c5815cf019e67&ipo=images',
    },
    {
      'nome': 'José',
      'telefone': '(44) 991334-5544',
      'url':
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse2.mm.bing.net%2Fth%3Fid%3DOIP.b_WVYAkHYBeZsz7TNrFBkwHaF3%26pid%3DApi&f=1&ipt=99408573c67ee5fa304966fb561eb3903ae16d0af31bd92b778c5815cf019e67&ipo=images',
    },
    {
      'nome': 'João',
      'telefone': '(44) 991314-5544',
      'url':
          'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse2.mm.bing.net%2Fth%3Fid%3DOIP.b_WVYAkHYBeZsz7TNrFBkwHaF3%26pid%3DApi&f=1&ipt=99408573c67ee5fa304966fb561eb3903ae16d0af31bd92b778c5815cf019e67&ipo=images',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista Pessoais')),
      body: ListView.builder(
        itemCount: pessoas.length,
        itemBuilder:
            (context, cont) => ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage('${pessoas[cont]['url']}'),
              ),
              title: Text('${pessoas[cont]["nome"]}'),
              subtitle: Text('${pessoas[cont]["telefone"]}'),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showMaterialBanner()
                      },
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                    ),

                    IconButton(
                      onPressed: () {
                        print("oii");
                      },
                      icon: const Icon(Icons.edit),
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
