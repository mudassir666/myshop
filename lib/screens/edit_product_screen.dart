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
      if (
      // if value does not have http or https , will show error msg
          (!_imgUrlController.text.startsWith('http') &&
              !_imgUrlController.text.startsWith('https')) ||
              // it should end with the following
          (!_imgUrlController.text.endsWith('.png') &&
              !_imgUrlController.text.endsWith('.jpg') &&
              !_imgUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    // it will check all the validation must return null otherwise it will end
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
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
                // validator value is the input value
                validator: (value) {
                  // check if the value is empty it will generate a error msg
                  if (value!.isEmpty) {
                    return 'Please provide a value';
                  }
                  // if its not empty just return
                  return null;
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a price';
                  }
                  // when user enter something instead of number
                  // tryParse return null when it falses
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  // to check if value is smaller or equal to 0 ,so we will stop it
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than zero';
                  }
                  // when nothing goes wrong
                  return null;
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description.';
                  }
                  if (value.length < 10) {
                    return 'Should be at least 10 characters long.';
                  }
                  return null;
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an image URL.';
                        }
                        // if value does not have http or https , will show error msg
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid URL.';
                        }
                        // it should end with the following
                         if (!value.endsWith('.png') &&
                            !value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg')
                            ) {
                          return 'Please enter a valid image URL.';
                        }
                        return null;
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
