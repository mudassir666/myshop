import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
// to focus on a single input
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

// to clear the memory when we leave the screen
  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                //  this will show a button which will move towards next input
                textInputAction: TextInputAction.next,
                // pressing next button will fire submittion
                onFieldSubmitted: (_) {
                  // when submitted the focus will moves towards the requested focus node
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                //  this will show a button which will move towards next input
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                // this form will be focus form outside
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  // when submitted the focus will moves towards the requested focus node
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                //how many lines should be display
                maxLines: 3,
                //it will give enter symbol to add line
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
