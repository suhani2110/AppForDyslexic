import 'package:flutter/material.dart';

class NotebookEntryPage extends StatefulWidget {
  final String title;
  final String content;

  const NotebookEntryPage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  State<NotebookEntryPage> createState() => _NotebookEntryPageState();
}

class _NotebookEntryPageState extends State<NotebookEntryPage> {
  double fontSize = 22;
  bool boldText = true;
  Color backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: backgroundColor,
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Text(
                  widget.content,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: boldText ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text("Font Size"),
                    Expanded(
                      child: Slider(
                        min: 16,
                        max: 36,
                        value: fontSize,
                        onChanged: (v) => setState(() => fontSize = v),
                      ),
                    ),
                  ],
                ),
                SwitchListTile(
                  title: const Text("Bold text"),
                  value: boldText,
                  onChanged: (v) => setState(() => boldText = v),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _colorButton(Colors.white),
                    _colorButton(Colors.yellow.shade100),
                    _colorButton(Colors.blue.shade50),
                    _colorButton(Colors.green.shade50),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorButton(Color color) {
    return GestureDetector(
      onTap: () => setState(() => backgroundColor = color),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
