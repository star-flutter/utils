import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'bloc_provider.dart';

class BlocStreamBuilder<B extends BlocBase, S extends Equatable> extends StatelessWidget {
  final B bloc;
  final Widget Function(BuildContext, S) builder;

   BlocStreamBuilder({this.bloc, this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: bloc,
      child: StreamBuilder(
        stream: bloc.stream,
        initialData: bloc.initialData(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.data is S) {
            return builder(context, asyncSnapshot.data as S);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
