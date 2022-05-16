import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
//import 'package:quick_feedback/quick_feedback.dart';
class feedBack_page extends StatelessWidget {
  const feedBack_page({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback form'),
      ),
      body: Center(
        child: RaisedButton(
          child: const Text('Open form'),
          onPressed: () {
            showDialog(
                context: context, builder: (context) => const FeedbackDialog());
          },
        ),
      ),
    );
  }
}

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog({Key? key}) : super(key: key);

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            hintText: 'Enter your feedback here',
            filled: true,
          ),
          maxLines: 5,
          maxLength: 4096,
          textInputAction: TextInputAction.done,
          validator: (String? text) {
            if (text == null || text.isEmpty) {
              return 'Please enter a value';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text('Send'),
          onPressed: () async {
            /**
             * Here we will add the necessary code to 
             * send the entered data to the Firebase Cloud Firestore.
             */
          },
        )
      ],
    );
  }
}
