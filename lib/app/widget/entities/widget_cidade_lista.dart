import 'package:flutter/material.dart';
import 'package:flutter_app_helio/app/widget/entities/widget_cidade.dart';

class WidgetCidadeLista extends StatefulWidget {
  final Map<String, dynamic>? cidade;

  WidgetCidadeLista({Key? key, this.cidade}) : super(key: key);

  @override
  _WidgetCidadeListaState createState() => _WidgetCidadeListaState();
}

class _WidgetCidadeListaState extends State<WidgetCidadeLista> {
  late List<Map<String, dynamic>> cidades;

  @override
  void initState() {
    super.initState();

    cidades = [
      {
        'nome': 'Paranavaí',
        'cep': '87707',
        'estado': 'PR',
        'url':
            'https://i0.wp.com/www.paranaturismo.com.br/wp-content/uploads/2013/10/paranavai1.jpg?ssl=1',
      },
      {
        'nome': 'Maringá',
        'cep': '87701',
        'estado': 'PR',
        'url':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKT3facoOpABBrZ56_fdeO5on3kAnVD6tvtA&s',
      },
      {
        'nome': 'OSASCO SLK',
        'cep': '01011',
        'estado': 'SP',
        'url':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKT3facoOpABBrZ56_fdeO5on3kAnVD6tvtA&s',
      },
    ];

    if (widget.cidade != null) {
      cidades.add(widget.cidade!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista Pessoais')),
      body: ListView.builder(
        itemCount: cidades.length,
        itemBuilder:
            (context, cont) => ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage('${cidades[cont]['url']}'),
              ),
              title: Text('${cidades[cont]["nome"]}'),
              subtitle: Text('${cidades[cont]["cep"]}'),
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
                              'Deseja realmente excluir ${cidades[cont]["nome"]}?',
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => WidgetCidade(
                                  cidadeParaEditar: cidades[cont],
                                  taEditando: true,
                                ),
                          ),
                        );
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
