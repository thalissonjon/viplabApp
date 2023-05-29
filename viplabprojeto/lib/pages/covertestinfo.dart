import 'package:flutter/material.dart';

class CoverTestinfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TESTE'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
            'Nulla nec velit euismod, tristique lorem a, laoreet dolor. '
            'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices '
            'posuere cubilia curae; Aliquam tristique purus ut leo viverra, '
            'sit amet placerat augue viverra. Nam vitae justo nisl. '
            'Curabitur nec lacus eget magna fringilla iaculis. '
            'Vestibulum consequat nisi nec tristique volutpat.',
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Voltar'),
          ),
        ],
      ),
    );
  }
}
