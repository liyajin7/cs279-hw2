// import material dart as a package
import 'package:flutter/material.dart';

// define type 'Todo', used later in _todos array within _TodoListState.
// each to-do has a name and boolean indicating whether checked or unchecked
class Todo {
  Todo({required this.name, required this.checked});
  final String name;
  bool checked;
}

// class for each todo item in our list (defined by todo and change handler
// passed in from _TodoListState)
class TodoItem extends StatelessWidget {
  TodoItem({
    required this.todo,
    required this.onTodoChanged,
  }) : super(key: ObjectKey(todo));

  final Todo todo;
  final onTodoChanged;

  // styles text of each todo item
  TextStyle? _getTextStyle(bool checked) {
    // takes boolean to evaluate whether todo has been checked off or not:
    // if not checked, style indigo: otherwise, style grey with strikethrough.
    if (!checked) return TextStyle(color: Colors.indigoAccent[400]);

    return TextStyle(
      color: Colors.grey[400],
      decoration: TextDecoration.lineThrough,
    );
  }

  // add onTop property to invoke onTodoChanged function, leading property
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTodoChanged(todo);
      },
      leading: CircleAvatar(
        backgroundColor: Colors.indigoAccent[200],
        child: Text('✨'), //todo.name[0]),
      ),
      title: Text(todo.name, style: _getTextStyle(todo.checked)),
    );
  }
}

// TodoList function called by MaterialApp home function calls _TodoListState to
// evaluate what needs to happen, and render accordingly
class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => new _TodoListState();
}

// state extends the state corresonding to our TodoList widgets
class _TodoListState extends State<TodoList> {
  // define text controller
  final TextEditingController _textFieldController = TextEditingController();

  // define our list of to-do's
  final List<Todo> _todos = <Todo>[];

  @override

  // widget to hold template for to-do list item state
  Widget build(BuildContext context) {
    // return a scaffold (header bar) with an appBar that holds our app title
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.indigoAccent[400],
        title: new Text('Liya\'s Lovely To-dos 🕊'),
      ),

      // define body section as ListView widget with _todo list's items as
      // children (of type Todo)
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: _todos.map((Todo todo) {
          // return a todo item to each mapped Todo type item in the state, pass
          // a todo and change handler to the widget
          return TodoItem(
            todo: todo,
            onTodoChanged: _handleTodoChange,
          );
        }).toList(),
      ),

      //
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 6, 177, 157),
          onPressed: () => _displayDialog(),
          tooltip: 'Add new todo',
          child: Icon(Icons.add)),
    );
  }

  // change checked state of to-do item to opposite of what it was pre-click
  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.checked = !todo.checked;
    });
  }

  // call setState to invoke state change, adding type Todo item to our _todos
  // list with passed-in text and bool "checked" set to false
  void _addTodoItem(String name) {
    setState(() {
      _todos.add(Todo(name: name, checked: false));
    });

    // clear text field text for next to-do
    _textFieldController.clear();
  }

  // displays dialog box when floating action button clicked
  Future<void> _displayDialog() async {
    // return a dialog, for which the content contains a TextField
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add a lovely thing to do! :-)'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(
                hintText: 'e.g. sunbathe in Quincy courtyard 😌'),
          ),

          // add an action with a button: once button clicked, close alert
          // dialog box and invoke function to add to do item (to which we pass
          // user-inputted text)
          actions: <Widget>[
            TextButton(
              child: const Text('Add!'),
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(_textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }
}

// our todo app extends statelessWidget, takes advantage of basica material app
// styling
class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return new material app, home function returns our actual TodoList
    // function. NOTE HERE: customized styling :)
    return new MaterialApp(
      title: 'Liya\'s Lovely To-dos',
      theme: new ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 248, 247, 255)),
      home: new TodoList(),
    );
  }
}

// main function returns instance of our TodoApp!
void main() => runApp(new TodoApp());
