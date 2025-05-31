import 'package:flutter/material.dart';
import 'package:front_insumos/components/custom_button.dart';

class StockPage extends StatelessWidget {
  const StockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Center(
                    child: Text(
                      'Gerenciar Estoque',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Divider(
                    thickness: 2,
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: Row(
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            fillColor: Colors.grey[200],
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: const Icon(Icons.search),
                          ),
                        ),
                      ),
                      const Spacer(),
                      CustomButton(
                        text: 'Adicionar Lote',
                        onPressed: () async {
                          _showAddBatchDialog(context);
                        },
                      ),
                      const SizedBox(width: 12),
                      CustomButton(
                        text: 'Registrar Ingrediente',
                        onPressed: () async {
                          await _showRegisterIngredientDialog(context);
                        },
                      ),
                    ],
                  ),
                ),

                // 👉 Espaçamento atualizado para o dobro
                const SizedBox(height: 32),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        Container(
                          color: Colors.grey[300],
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 8),
                          child: Row(
                            children: const [
                              Expanded(
                                  child: Text('INGREDIENTE',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                  child: Text('CATEGORIA',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                  child: Text('UNIDADE',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                  child: Text('LOTES',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                  child: Text('VALIDADE',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                  child: Text('TOTAL',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                  child: Text('STATUS',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: ListView(
                            children: [
                              _buildRow(
                                  'Arroz',
                                  'Secos',
                                  'Kg',
                                  '2',
                                  '11/04/2025',
                                  '30 Kg',
                                  Colors.orange,
                                  'A vencer'),
                              _buildRow('Leite', 'Laticínios', 'Litros', '1',
                                  '06/04/2025', '20 L', Colors.red, 'Vencido'),
                              _buildRow(
                                  'Ovos',
                                  'Ovos',
                                  'Unidades',
                                  '1',
                                  '19/04/2025',
                                  '20 un',
                                  Colors.green,
                                  'Normal'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 32, bottom: 16, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text('< Previous'),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('1'),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('2'),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('3'),
                      ),
                      const Text('...'),
                      TextButton(
                        onPressed: () {},
                        child: const Text('67'),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('68'),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Next >'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildRow(
    String ingrediente,
    String categoria,
    String unidade,
    String lotes,
    String validade,
    String total,
    Color statusColor,
    String statusText,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              Expanded(child: Text(ingrediente)),
              Expanded(child: Text(categoria)),
              Expanded(child: Text(unidade)),
              Expanded(child: Text(lotes)),
              Expanded(child: Text(validade)),
              Expanded(child: Text(total)),
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.circle, color: statusColor, size: 12),
                    const SizedBox(width: 4),
                    Text(statusText, style: TextStyle(color: statusColor)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey,
        ),
      ],
    );
  }

  void _showAddBatchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String dropdownValue = 'Tomate';
        String unidadeValue = '10 Kg';
        DateTime selectedDate = DateTime(2025, 4, 11);

        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Adicionar Lote'),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: dropdownValue,
                          items: const [
                            DropdownMenuItem(
                                value: 'Tomate', child: Text('Tomate')),
                            DropdownMenuItem(
                                value: 'Arroz', child: Text('Arroz')),
                            DropdownMenuItem(
                                value: 'Leite', child: Text('Leite')),
                            DropdownMenuItem(
                                value: 'Ovos', child: Text('Ovos')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              dropdownValue = value!;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'nome',
                            isDense: true,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: unidadeValue,
                          items: const [
                            DropdownMenuItem(
                                value: '10 Kg', child: Text('10 Kg')),
                            DropdownMenuItem(
                                value: '20 Kg', child: Text('20 Kg')),
                            DropdownMenuItem(
                                value: '30 Kg', child: Text('30 Kg')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              unidadeValue = value!;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'unidade',
                            isDense: true,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              setState(() {
                                selectedDate = date;
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'validade',
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 12),
                            ),
                            child: Text(
                                '${selectedDate.day.toString().padLeft(2, '0')}/'
                                '${selectedDate.month.toString().padLeft(2, '0')}/'
                                '${selectedDate.year}'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Não'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Sim'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showRegisterIngredientDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        String nomeValue = 'Tomate';
        String categoriaValue = 'Hortaliças';
        String unidadeValue = 'Kg';

        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Cadastrar Ingrediente'),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: nomeValue,
                          onChanged: (value) =>
                              setState(() => nomeValue = value),
                          decoration: const InputDecoration(
                            labelText: 'nome',
                            isDense: true,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: categoriaValue,
                          items: const [
                            DropdownMenuItem(
                                value: 'Hortaliças', child: Text('Hortaliças')),
                            DropdownMenuItem(
                                value: 'Secos', child: Text('Secos')),
                            DropdownMenuItem(
                                value: 'Laticínios', child: Text('Laticínios')),
                            DropdownMenuItem(
                                value: 'Ovos', child: Text('Ovos')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              categoriaValue = value!;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'categoria',
                            isDense: true,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: unidadeValue,
                          items: const [
                            DropdownMenuItem(value: 'Kg', child: Text('Kg')),
                            DropdownMenuItem(
                                value: 'Litros', child: Text('Litros')),
                            DropdownMenuItem(
                                value: 'Unidades', child: Text('Unidades')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              unidadeValue = value!;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'unidade',
                            isDense: true,
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Não'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Sim'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black),
          const SizedBox(width: 12),
          Text(title,
              style: const TextStyle(fontSize: 14, color: Colors.black)),
        ],
      ),
    );
  }
}
