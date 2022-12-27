import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  var todoList = <Todos>[].obs;

  @override
  void onInit() {
    _configureAmplify();
    super.onInit();
  }

  Future<void> _configureAmplify() async {
    // Add the following lines to your app initialization to add the DataStore plugin
    final datastorePlugin =
    AmplifyDataStore(modelProvider: ModelProvider.instance);
    await Amplify.addPlugin(datastorePlugin);
    final api = AmplifyAPI();
    await Amplify.addPlugins([datastorePlugin, api]);
    try {
      await Amplify.configure(amplifyconfig);
      readData();
    } on AmplifyAlreadyConfiguredException {
      safePrint(
          'Tried to reconfigure Amplify; this can occur when your app restarts on Android.');
    }
  }

  Future<void> readData() async {
    try {
      todoList = RxList(await Amplify.DataStore.query(Todos.classType));
      update();
    } catch (e){
      print(e);
    }
  }

  // add todo method
  Future<void> addPost(String? task) async {
    try {
      Todos _newTodo = Todos(task: task!, isDone: false);
      await Amplify.DataStore.save(_newTodo);
      readData();
    } on Exception catch (e) {
      print(e);
    }
  }

  // update todo method
  Future<void> updatePost(String? id, String? task, bool? isDone) async {
    try {
      Todos _oldTodo = (await Amplify.DataStore.query(Todos.classType, where: Todos.ID.eq(id)))[0];
      Todos _newTodo = _oldTodo.copyWith(id: id!, task: task!, isDone: isDone!);
      await Amplify.DataStore.save(_newTodo);
      readData();
    } on Exception catch (e) {
      print(e);
    }
  }

  // delete todo method
  Future<void> deleteTodo(String? id) async {
    (await Amplify.DataStore.query(Todos.classType, where: Todos.ID.eq(id))).forEach((element) async {
      try {
        await Amplify.DataStore.delete(element);
      } catch (e) {
        print(e);
      }
    });
    readData();
  }
}