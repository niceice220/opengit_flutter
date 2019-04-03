import 'package:flutter/material.dart';
import 'package:open_git/base/base_state.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/contract/markdown_editor_contract.dart';
import 'package:open_git/presenter/markdown_editor_presenter.dart';

class MarkdownEditorPage extends StatefulWidget {
  final IssueBean issueBean;
  final String repoUrl;

  MarkdownEditorPage(this.issueBean, this.repoUrl);

  @override
  _MarkdownEditorState createState() =>
      _MarkdownEditorState(issueBean, repoUrl);
}

class _MarkdownEditorState
    extends BaseState<MarkdownEditorPresenter, IMarkdownEditorView>
    implements IMarkdownEditorView {
  final IssueBean issueBean;
  final String repoUrl;

  TextEditingController _controller;
  final FocusNode _focusNode = new FocusNode();

  _MarkdownEditorState(this.issueBean, this.repoUrl);

  bool _isEnable = false;

  @override
  void initData() {
    super.initData();
    _controller =
        TextEditingController.fromValue(TextEditingValue(text: issueBean.body));
    _controller.addListener(() {
      if (_controller.text.toString() == issueBean.body) {
        _isEnable = false;
      } else {
        _isEnable = true;
      }
      setState(() {});
    });
  }

  @override
  String getTitle() {
    return "编辑评论";
  }

  @override
  List<Widget> getActions() {
    Widget saveWidget = new FlatButton(
      onPressed: _isEnable
          ? () {
              _editIssueComment();
            }
          : null,
      child: Icon(Icons.check),
      disabledTextColor: Colors.grey,
      textColor: Colors.white,
    );
    return [saveWidget];
  }

  @override
  Widget buildBody(BuildContext context) {
    final form = ListView(
      children: <Widget>[
        buildEditor(),
      ],
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: form,
    );
  }

  Widget buildEditor() {
    return TextField(
//        decoration: InputDecoration(labelText: 'Description'),
      controller: _controller,
      focusNode: _focusNode,
      autofocus: true,
//      physics: ClampingScrollPhysics(),
    );
  }

  @override
  MarkdownEditorPresenter initPresenter() {
    return new MarkdownEditorPresenter();
  }

  _editIssueComment() async {
    if (presenter != null) {
      final result = await presenter.editIssueComment(
          repoUrl, issueBean.id, _controller.text.toString());
      if (result != null) {
        IssueBean issueBean = IssueBean.fromJson(result);
        Navigator.pop(context, issueBean);
      }
    }
  }

  @override
  onEditSuccess(IssueBean issueBean) {
    //在该处会抛异常
//    Navigator.pop(context, issueBean);
  }
}