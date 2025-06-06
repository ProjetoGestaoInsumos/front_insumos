import 'package:flutter/material.dart';
import 'package:front_insumos/components/custom_popup.dart';
import 'package:front_insumos/utils/colors.dart';
import 'package:front_insumos/components/custom_button.dart';

void showOrderPopup(BuildContext context) {
  CustomPopup.show(
    context: context,
    title: "POP",
    showFooter: true,
    primaryButtonLabel: "Sim",
    secondaryButtonLabel: "Não",
    primaryButtonOnPressed: () async {
      Navigator.of(context, rootNavigator: true).pop();
    },
    secondaryButtonOnPressed: () async {
      Navigator.of(context, rootNavigator: true).pop();
    },
    content: const OrderPopupContent(),
  );
}

void showAddItemPopup(BuildContext context) {
  String? selectedIngredient;
  final TextEditingController unitController = TextEditingController();

  CustomPopup.show(
    context: context,
    title: "Adicionar item extra",
    showFooter: true,
    primaryButtonLabel: "Sim",
    secondaryButtonLabel: "Não",
    primaryButtonOnPressed: () async {
      if (selectedIngredient == null || unitController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preencha todos os campos')),
        );
        return;
      }
      // ✅ Aqui você pode processar os dados capturados
      // print('Ingrediente: $selectedIngredient');
      // print('Unidade: ${unitController.text}');

      Navigator.of(context, rootNavigator: true).pop();
      return;
    },
    secondaryButtonOnPressed: () async {
      Navigator.of(context, rootNavigator: true).pop();
      return;
    },
    content: StatefulBuilder(
      builder: (context, setState) {
        return SizedBox(
          width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Ingrediente',
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(),
                      ),
                      value: selectedIngredient,
                      hint: const Text('Selecione', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      onChanged: (value) {
                        setState(() {
                          selectedIngredient = value;
                        });
                      },
                      items: ['Leite', 'Farinha', 'Ovo', 'Carne']
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: unitController,
                      decoration: const InputDecoration(
                        labelText: 'Unidade',
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(),
                        hintText: 'Ex: 300 ml',
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}


class OrderPopupContent extends StatelessWidget {
  const OrderPopupContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildTextField("Curso")),
              const SizedBox(width: 16),
              Expanded(child: _buildTextField("Docente")),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                flex: 19,
                child: _buildTextField("Disciplina"),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 9,
                child: _buildTextField("Alunos"),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 9,
                child: _buildTextField("Grupos"),
              ),
            ],
          ),
    
    
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildDateField(context)),
              const SizedBox(width: 16),
              Expanded(child: _buildDropdown("Turno", ["Manhã", "Tarde", "Noite"])),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildDropdown("Protocolo", ["Padrão", "Outro"])),
              const SizedBox(width: 16),
              Expanded(child: _buildDropdown("Receita", ["Receita 1", "Receita 2"])),
            ],
          ),
          const SizedBox(height: 10),
          _buildTextField("Objetivo", height: 80, maxLines: 3, expand: true),
          const SizedBox(height: 10),
       Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            onPressed:() async  {
              showAddItemPopup(context);
              return;
            },
            iconData: Icons.add,
            text: "Adicionar Item Extra",
            buttonColor:CustomColors.white,
            iconColor: Colors.black,
          ),
        ],
      ),
          const SizedBox(height: 10),
          _buildSummaryTable(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ===============================
  // Widgets Auxiliares
  // ===============================

  static Widget _buildTextField(String label, {double height = 40, int maxLines = 1, bool expand = false}) {
    return SizedBox(
      height: height,
      width: expand ? double.infinity : 230,
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 14),
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: CustomColors.blue),
          ),
        ),
      ),
    );
  }

static Widget _buildDateField(BuildContext context) {
  final TextEditingController controller = TextEditingController();

  return SizedBox(
    height: 40,
    child: TextField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: "Data",
        suffixIcon: Icon(Icons.calendar_today, size: 20),
        labelStyle: TextStyle(fontSize: 14),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.blue),
        ),
      ),
      readOnly: true,
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
          initialDate: DateTime.now(),
        );
    
        if (pickedDate != null) {
          controller.text =
              "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
        }
      },
    ),
  );
}


static Widget _buildDropdown(String label, List<String> items) {
  String? selectedItem;

  return StatefulBuilder(
    builder: (context, setState) {
      return DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 14),
          isDense: true,
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: CustomColors.blue),
          ),
        ),
        value: selectedItem,
        onChanged: (value) {
          setState(() {
            selectedItem = value;
          });
        },
        items: items
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ),
            )
            .toList(),
      );
    },
  );
}


  static Widget _buildSummaryTable() {
    return SizedBox(
      height: 100, 
      child: SingleChildScrollView(
        child: Table(
          border: TableBorder.all(borderRadius: BorderRadius.circular(10),color: Colors.black26),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(),
            2: FlexColumnWidth(),
            3: FlexColumnWidth(),
          },
          children: [
            _buildTableHeader(),
            _buildTableRow("Farinha", "3 kg", "1 kg", "2 kg"),
            _buildTableRow("Carne Moída", "1,5 kg", "1,5 kg", "0 kg"),
            _buildTableRow("Ovo", "1 unid", "3 unid", "0 unid"),
            _buildTableRow("Leite [Extra]", "300 ml", "100 ml", "200 ml"),
          ],
        ),
      ),
    );
  }

  static TableRow _buildTableHeader() {
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFFEFEFEF)),
      children: [
        _tableCell("Ingredientes", isHeader: true),
        _tableCell("Necessário", isHeader: true),
        _tableCell("Em estoque", isHeader: true),
        _tableCell("Faltando", isHeader: true),
      ],
    );
  }

  static TableRow _buildTableRow(
      String ingrediente, String necessario, String estoque, String faltando) {
    return TableRow(
      children: [
        _tableCell(ingrediente),
        _tableCell(necessario),
        _tableCell(estoque),
        _tableCell(faltando),
      ],
    );
  }

  static Widget _tableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
      ),
    );
  }
}
