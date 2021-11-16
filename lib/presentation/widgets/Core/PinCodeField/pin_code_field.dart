import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class PinCodeField extends StatefulWidget {
  final int length;
  final void Function(String? text) onChange;
  final bool? error;

  const PinCodeField(
      {Key? key, this.length = 4, required this.onChange, this.error})
      : super(key: key);

  @override
  PinCodeFieldState createState() => PinCodeFieldState();
}

class PinCodeFieldState extends State<PinCodeField>
    with SingleTickerProviderStateMixin {
  List<FocusNode> nodes = [];
  List<TextEditingController> controllers = [];
  List<FocusNode> keyboardNodes = [];
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    for (var i = 0; i < widget.length; i++) {
      nodes.add(FocusNode());
      keyboardNodes.add(FocusNode());
      var newController = TextEditingController();
      controllers.add(newController);
      // newController.addListener(() {
      //   changeListener(i);
      // });
    }
    super.initState();
    if (nodes.length > 0) {
      nodes[0].requestFocus();
    }

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _animation = TweenSequence([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: -10)
            .chain(CurveTween(curve: Curves.elasticInOut)),
        weight: 25.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -10, end: 0)
            .chain(CurveTween(curve: Curves.elasticInOut)),
        weight: 25.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: 10)
            .chain(CurveTween(curve: Curves.elasticInOut)),
        weight: 25.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 10, end: 0)
            .chain(CurveTween(curve: Curves.elasticInOut)),
        weight: 25.0,
      ),
    ]).animate(_controller!);
  }

  @override
  void didUpdateWidget(oldWidget) {
    if (oldWidget.error == false && widget.error == true) {
      animate();
    }

    super.didUpdateWidget(oldWidget);
  }

  void animate() {
    _controller!.forward();
    _controller!.addListener(() {
      print('animation');
      print(_animation?.value);
      if (_controller?.status == AnimationStatus.completed) {
        _controller?.reset();
      }
    });
  }

  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void handleChange(String text, int index) {
    if (text.length == 1) {
      if (index < widget.length - 1) {
        var nextFocus = nodes[index + 1];
        nextFocus.requestFocus();
      } else {
        var currentFocus = nodes[index];
        currentFocus.unfocus();
      }
    } else if (text.length == 0) {
      if (index > 0) {
        var nextFocus = nodes[index - 1];
        nextFocus.requestFocus();
      }
    }
    String result = "";

    controllers.forEach((controller) {
      String text = controller.value.text;
      result = result + text;
    });

    widget.onChange(result);
  }

  List<Widget> getInputList() {
    List<Widget> result = [];
    var containerWidth = (MediaQuery.of(context).size.width)>450 ? 450 : MediaQuery.of(context).size.width;
    var width = ( containerWidth-40 - (8*(widget.length-1))) / widget.length;
    
    var height =  width/78*91;
    nodes.asMap().forEach((key, node) {
      result.add(Neumorphic(
        style: NeumorphicStyle(
          color: Colors.transparent,
          depth: -2,
          shadowLightColorEmboss: Color.fromRGBO(255, 255, 255, 0.6),
          shadowDarkColorEmboss: Color.fromRGBO(255, 255, 255, 0.6),
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
        ),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: height,
          width: width,
          
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: const Color(0xffECECF5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: widget.error == true
                      ? Theme.of(context).colorScheme.error
                      : const Color(0xffE0E0EB),
                  width: 1.5)),
          child: Container(
            child: Center(
              child: RawKeyboardListener(
                focusNode: keyboardNodes[key],
                onKey: (event) => onKeyPress(event, key),
                child: TextFormField(
                  focusNode: node,
                  inputFormatters: [],
                  onChanged: (text) => handleChange(text, key),
                  controller: controllers[key],
                  enableInteractiveSelection: false,
                  keyboardType: TextInputType.number,
                  cursorColor: Theme.of(context).textTheme.bodyText2?.color,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      counterText: ''),
                  maxLength: 1,
                  textAlignVertical: TextAlignVertical.center,
                  style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontSize: height*0.625,
                      height: 1.2,
                      color: widget.error == true
                          ? Theme.of(context).colorScheme.error
                          : const Color(0xff1A1D21)),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ));
    });

    return result;
  }

  void onKeyPress(RawKeyEvent? event, int index) {
    if (event?.logicalKey == LogicalKeyboardKey.backspace) {
      var currentValue = controllers[index].value.text;

      if (currentValue == "") {
        if (index > 0) {
          var nextFocus = nodes[index - 1];
          nextFocus.requestFocus();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller!,
        builder: (context, snapshot) {
          return Transform.translate(
            offset: Offset(_animation!.value, 0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: getInputList()),
          );
        });
  }
}
