import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class ListState {
  final List<String> items;
  ListState({this.items});

  ListState.initialState() : items = [];
}

class AddAction {
  final String input;
  AddAction({this.input});
}

typedef AddItem(String text);

class _ViewModel {
  final AddItem addItemToList;
  _ViewModel({this.addItemToList});
}

ListState reducer(ListState state, action) {
  if (action is AddAction) {
    return ListState(
        items: []
          ..addAll(state.items)
          ..add(action.input));
  }

  return ListState(items: state.items);
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final store =
      Store<ListState>(reducer, initialState: ListState.initialState());
  @override
  Widget build(BuildContext context) {
    return StoreProvider<ListState>(
      store: store,
      child: MaterialApp(
        theme: ThemeData.dark(),
        title: 'Redux List App',
        home: Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Redux List"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ListInput(),
            ViewList(),
          ],
        ),
      ),
    );
  }
}

class ListInput extends StatefulWidget {
  @override
  ListInputState createState() => ListInputState();
}

class ListInputState extends State<ListInput> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return StoreConnector<ListState, _ViewModel>(
        converter: (store) => _ViewModel(
              addItemToList: (inputText) => store.dispatch(
                    AddAction(input: inputText),
                  ),
            ),
        builder: (context, viewModel) => TextField(
            decoration: InputDecoration(hintText: "Enter an Item"),
            controller: controller,
            onSubmitted: (text) {
              viewModel.addItemToList(text);
              controller.text = "";
            }));
  }
}

class ViewList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<ListState, List<String>>(
      converter: (store) => store.state.items,
      builder: (context, items) => Column(
            children: items.map((i) => ListTile(title: Text(i))).toList(),
          ),
    );
  }
}
