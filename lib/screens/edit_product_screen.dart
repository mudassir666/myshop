import 'package:flutter/material.dart';
import 'package:myshop/models/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
// to focus on a single input
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imgUrlController = TextEditingController();
  //step 1 : creating custom listner
  final _imgUrlFocusNode = FocusNode();
  // global key most use for forms
  final _form = GlobalKey<FormState>();

  // Object of Product which is empty
  var _editedProduct = Product(
    id: null.toString(),
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

//step 5 : when the update function rebuild state then it run initstate after listning
  @override
  void initState() {
    _imgUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

// to clear the memory when we leave the screen
  @override
  void dispose() {
    // step 6 : remove the imgUrlFocusNode listner
    _imgUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imgUrlController.dispose();
    //step 2 : distoring when exist page
    _imgUrlFocusNode.dispose();
    super.dispose();
  }

  //step 4 : check if imgUrlnode has focus or not , when the imgUrlnode loses focus it will update it by setState
  void _updateImageUrl() {
    if (!_imgUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    // by using global key which has the asscess of form , we can save it
    _form.currentState!.save();
    print(_editedProduct.title);
    print(_editedProduct.description);
    print(_editedProduct.imageUrl);
    print(_editedProduct.price);
    print(_editedProduct.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // proving global key to access its data outside
          key: _form,
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
                // when the save button is click the form input move into the product object by updating it
                onSaved: (value) {
                  _editedProduct = Product(
                      id: null.toString(),
                      title: value.toString(),
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl);
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
                // when the save button is click the form input move into the product object by updating it
                onSaved: (value) {
                  _editedProduct = Product(
                      id: null.toString(),
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(value.toString()),
                      imageUrl: _editedProduct.imageUrl);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                //how many lines should be display
                maxLines: 3,
                //it will give enter symbol to add line
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                // when the save button is click the form input move into the product object by updating it
                onSaved: (value) {
                  _editedProduct = Product(
                      id: null.toString(),
                      title: _editedProduct.title,
                      description: value.toString(),
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    )),
                    child: _imgUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(
                              _imgUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      // using controller to show the image before submitting
                      controller: _imgUrlController,
                      // step 3 : to focus on this form
                      focusNode: _imgUrlFocusNode,
                      // when pressing the done button it will submit the form
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      // when the save button is click the form input move into the product object by updating it
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: null.toString(),
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: value.toString(),
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
