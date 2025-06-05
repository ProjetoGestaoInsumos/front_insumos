import 'package:flutter/material.dart';
import 'package:front_insumos/components/custom_button.dart';
import 'package:front_insumos/components/custom_pagination.dart';
import 'package:front_insumos/components/custom_popup.dart';
import 'package:front_insumos/components/custom_search_field.dart';
import 'package:front_insumos/utils/colors.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  int rowsPerPage = 10;
  int currentPage = 0;
  int totalPages = 68; // ou calcule com base nos dados

  void goToPage(int page) {
    if (page >= 0 && page < totalPages) {
      setState(() {
        currentPage = page;
      });
    }
  }

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
                      CustomSearchField(
                        width: 250,
                        onChanged: (value) {
                          // lógica de busca
                        },
                      ),
                      const Spacer(),
                      CustomButton(
                        text: 'Adicionar Lote',
                        iconData: Icons.inventory_2_outlined, //essa linha
                        buttonColor: CustomColors.blue, //essa linha
                        onPressed: () async {
                          _showAddBatchDialog(context);
                        },
                      ),
                      const SizedBox(width: 12),
                      CustomButton(
                        text: 'Registrar Ingrediente',
                        iconData: Icons.add_circle_outline, //essa linha
                        buttonColor: CustomColors.blue, //essa linha
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
                  padding: const EdgeInsets.all(16),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CustomPagination(
                      currentPage: currentPage,
                      totalPages: totalPages,
                      onPageChanged: goToPage,
                    ),
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

  Future<void> _showAddBatchDialog(BuildContext context) async {
    String dropdownValue = 'Tomate';
    String unidadeValue = '10 Kg';
    DateTime selectedDate = DateTime(2025, 4, 11);

    await CustomPopup.show(
      context: context,
      title: 'Adicionar Lote',
      onClose: () => Navigator.of(context).pop(),
      showFooter: true,
      primaryButtonLabel: 'Sim',
      primaryButtonOnPressed: () async {
        Navigator.of(context).pop();
        return Future.value();
      },
      secondaryButtonLabel: 'Não',
      secondaryButtonOnPressed: () async {
        Navigator.of(context).pop();
        return Future.value();
      },
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
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
                        DropdownMenuItem(value: 'Arroz', child: Text('Arroz')),
                        DropdownMenuItem(value: 'Leite', child: Text('Leite')),
                        DropdownMenuItem(value: 'Ovos', child: Text('Ovos')),
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
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: unidadeValue,
                      items: const [
                        DropdownMenuItem(value: '10 Kg', child: Text('10 Kg')),
                        DropdownMenuItem(value: '20 Kg', child: Text('20 Kg')),
                        DropdownMenuItem(value: '30 Kg', child: Text('30 Kg')),
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
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
          );
        },
      ),
    );
  }

  Future<void> _showRegisterIngredientDialog(BuildContext context) async {
    String nomeValue = 'Tomate';
    String categoriaValue = 'Hortaliças';
    String unidadeValue = 'Kg';

    await CustomPopup.show(
      context: context,
      title: 'Cadastrar Ingrediente',
      onClose: () => Navigator.of(context).pop(),
      showFooter: true,
      primaryButtonLabel: 'Sim',
      primaryButtonOnPressed: () async {
        Navigator.of(context).pop();
        return Future.value();
      },
      secondaryButtonLabel: 'Não',
      secondaryButtonOnPressed: () async {
        Navigator.of(context).pop();
        return Future.value();
      },
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: nomeValue,
                      onChanged: (value) => setState(() => nomeValue = value),
                      decoration: const InputDecoration(
                        labelText: 'nome',
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
                        DropdownMenuItem(value: 'Secos', child: Text('Secos')),
                        DropdownMenuItem(
                            value: 'Laticínios', child: Text('Laticínios')),
                        DropdownMenuItem(value: 'Ovos', child: Text('Ovos')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          categoriaValue = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'categoria',
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
