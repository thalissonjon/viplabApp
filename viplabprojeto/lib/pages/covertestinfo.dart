import 'package:flutter/material.dart';

class CoverTestinfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            top: 60,
            left: 20,
            right: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informações',
                style: TextStyle(
                  fontSize: 25,
                  color: Color.fromRGBO(0, 74, 173, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'O aplicativo oferece a possibilidade de realizar um autoteste para detecção de estrabismo utilizando a câmera frontal. '
                'No entanto, se preferir, outra pessoa pode fazer a gravação utilizando a câmera traseira.\n\n'
                'Para realizar o teste adequadamente, é altamente recomendado seguir os seguintes passos:\n',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '1. Garanta que a gravação seja realizada em uma área bem iluminada e, se possível, utilize um suporte para o celular.\n'
                '2. Mantenha uma distância de aproximadamente 50 cm entre a câmera e a pessoa.\n'
                '3. Posicione o rosto centralizado e mantenha o olhar fixo na câmera.\n'
                '4. Mova o oclusor de um olho para o outro, sem retirá-lo da visão da câmera.\n'
                '5. Realize a oclusão alternada de cada olho pelo menos 5 vezes.\n\n',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Lembre-se: o resultado do seu teste dependerá da qualidade do vídeo gravado pelo usuário. '
                'Portanto, siga os passos corretamente e aguarde pelo resultado.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Image.asset('assets/gifInfo.gif'),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Voltar para a página inicial",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(0, 74, 173, 1),
                    padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    shadowColor: Colors.black,
                    elevation: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
