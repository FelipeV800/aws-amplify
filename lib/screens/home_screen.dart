import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:prototipo_aws_amplify/controller/controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Controller>(
      init: Controller(),
      initState: (_) {},
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('GetX Amplify Prototype'),
          ),
          body: ListView.builder(
              itemCount: _.todoList.length,
              itemBuilder: (context, index) =>
                Dismissible(
                  key: ValueKey<int>(_.todoList[index].id),
                  child: _.todoList.isNotEmpty ? const ListTile() : const Center(child: Text('No hay tareas actualmente')),
                )),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => showModalBottomSheet(
                context: context,
                builder: (context) => Column()),
          ),
        );
      }
    );
  }
}
