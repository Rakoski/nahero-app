import 'package:flutter/material.dart';

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
                width: 120,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        print("salvou!");
                      },
                      icon: const Icon(Icons.save),
                      color: Colors.green,
                    ),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showMaterialBanner(
                          MaterialBanner(
                            content: Text(
                              'Deseja realmente excluir ${pessoas[cont]["nome"]}?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).hideCurrentMaterialBanner();
                                },
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).hideCurrentMaterialBanner();
                                },
                                child: Text('Excluir'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                    ),
                    IconButton(
                      onPressed: () {
                        print("editou");
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
