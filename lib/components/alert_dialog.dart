import 'package:flutter/material.dart';

alertDialog(BuildContext context, String campus) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Você chegou!"),
        content: Text("Bem-vindo(a) à PUC Minas unidade " + campus),
        actions: [
          FlatButton(
            child: Text("FECHAR"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
