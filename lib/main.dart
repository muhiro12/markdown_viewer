import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: rootBundle.loadString('paths/zenn-articles.txt').then(
                (value) => value
                    .split('\n')
                    .where((element) => element.isNotEmpty)
                    .toList(),
              ),
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) =>
                  ListView(
            children: snapshot.data
                    ?.map(
                      (e) => ListTile(
                        title: Text(e),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MarkdownPage(e),
                          ),
                        ),
                      ),
                    )
                    .toList() ??
                [],
          ),
        ),
      ),
    );
  }
}

class MarkdownPage extends StatelessWidget {
  const MarkdownPage(this.path, {Key? key}) : super(key: key);

  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(toString()),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: http
              .get(
                Uri.parse(
                  'https://raw.githubusercontent.com/muhiro12/zenn-content/main/articles/$path',
                ),
              )
              .then((value) => value.body),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return Markdown(
              data: snapshot.data ?? '',
            );
          },
        ),
      ),
    );
  }
}
