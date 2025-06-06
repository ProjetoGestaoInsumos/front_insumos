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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Gerenciar Estoque',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(thickness: 1, color: Colors.grey),
                  const SizedBox(height: 8),
                  Row(
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
                          _showRegisterIngredientDialog(context);
                        },
                      ),
                    ],
                  ),

                  // 👉 Espaçamento atualizado para o dobro
                  const SizedBox(height: 20),

                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Table(
                        border: TableBorder(
                          horizontalInside:
                              BorderSide(color: Colors.grey.shade400, width: 1),
                        ),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(1.5),
                          3: FlexColumnWidth(1),
                          4: FlexColumnWidth(2),
                          5: FlexColumnWidth(1.5),
                          6: FlexColumnWidth(2),
                        },
                        children: [
                          TableRow(
                            decoration: const BoxDecoration(
                              color: Color(0xFFE0E0E0),
                            ),
                            children: [
                              _buildHeaderCell('INGREDIENTE'),
                              _buildHeaderCell('CATEGORIA'),
                              _buildHeaderCell('UNIDADE'),
                              _buildHeaderCell('LOTES'),
                              _buildHeaderCell('VALIDADE'),
                              _buildHeaderCell('TOTAL'),
                              _buildHeaderCell('STATUS'),
                            ],
                          ),
                          _buildDataRow('Arroz', 'Secos', 'Kg', '2',
                              '11/04/2025', '30 Kg', Colors.orange, 'A vencer'),
                          _buildDataRow('Leite', 'Laticínios', 'Litros', '1',
                              '06/04/2025', '20 L', Colors.red, 'Vencido'),
                          _buildDataRow('Ovos', 'Ovos', 'Unidades', '1',
                              '19/04/2025', '20 un', Colors.green, 'Normal'),
                        ],
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomPagination(
                      currentPage: currentPage,
                      totalPages: totalPages,
                      onPageChanged: goToPage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  TableRow _buildDataRow(
    String ingrediente,
    String categoria,
    String unidade,
    String lotes,
    String validade,
    String total,
    Color statusColor,
    String statusText,
  ) {
    return TableRow(
      children: [
        _buildCell(ingrediente),
        _buildCell(categoria),
        _buildCell(unidade),
        _buildCell(lotes),
        _buildCell(validade),
        _buildCell(total),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.circle, size: 12, color: statusColor),
              const SizedBox(width: 4),
              Text(statusText, style: TextStyle(color: statusColor)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Center(child: Text(text)),
    );
  }

  Future<void> _showAddBatchDialog(BuildContext context) async {
    String dropdownValue = 'Tomate';
    String unidadeValue = '10 Kg';
    DateTime selectedDate = DateTime(2025, 4, 11);

    await CustomPopup.show(
      context: context,
      title: 'Adicionar Lote',
      showFooter: true,
      primaryButtonLabel: 'Sim',
      primaryButtonOnPressed: () async {
        Navigator.of(context, rootNavigator: true).pop();
      },
      secondaryButtonLabel: 'Não',
      secondaryButtonOnPressed: () async {
        Navigator.of(context, rootNavigator: true).pop();
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
    String categoriaValue = 'Hortaliças';
    String unidadeValue = 'Kg';

    await CustomPopup.show(
      context: context,
      title: 'Cadastrar Ingrediente',
      showFooter: true,
      primaryButtonLabel: 'Sim',
      primaryButtonOnPressed: () async {
        Navigator.of(context, rootNavigator: true).pop();
      },
      secondaryButtonLabel: 'Não',
      secondaryButtonOnPressed: () async {
        Navigator.of(context, rootNavigator: true).pop();
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
                      decoration: const InputDecoration(
                        labelText: 'nome',
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
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
