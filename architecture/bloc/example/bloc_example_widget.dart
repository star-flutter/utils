import '../bloc_stream_builder.dart';
import '../example_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BlocExampleWidget extends StatelessWidget {
  final BlocExample _bloc = BlocExample();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: BlocStreamBuilder<BlocExample, BlocExampleStates>(
        bloc: _bloc,
        builder: (context, state) {
          if (state is BlocExampleLoadingState) {
            return _buildProgressState(context);
          } else if (state is BlocExampleDataState) {
            return _buildDataState(context, state.clickCount);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildProgressState(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator()
        ),
      ),
    );
  }

  Widget _buildDataState(BuildContext context, int clickCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("$clickCount times clicked"),
            MaterialButton(
              onPressed: () => _bloc.onIncrementButtonClick(),
              color: Colors.blue,
              child: Text("Increment"),
            )
          ],
        ),
      ],
    );
  }
}
