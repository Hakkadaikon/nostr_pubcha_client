import 'dart:async';
import 'package:flutter/material.dart';
import 'settings.dart';
import 'post.dart';
import "nostr/content.dart";
import "widgets/posts.dart";

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ViewState createState() => ViewState();
}

class ViewState extends State<ChatScreen> {
  final _streamController = StreamController<List<PostListItem>>();

  void recentChannelMessagesCallback(
      List<ChannelMessageItem> channelMessageList) {
    var postListItems = channelMessageList.map((channelItem) {
      return PostListItem(
        id: channelItem.id,
        // iconUrl:
        //     'https://api.dicebear.com/7.x/thumbs/svg?seed=${channelItem.author}',
        name: channelItem.author,
        text: channelItem.content,
        images: "",
        datetime: channelItem.datetime,
      );
    }).toList();
    _streamController.add(postListItems);
  }

  @override
  void initState() {
    super.initState();
    fetchRecentChannelMessages("2b184fe3dcdabfc9e2983b1316158c2ef88f54cce58f2cb6572bf59bfd008ec8", recentChannelMessagesCallback);
    // fetchRecentMessages(recentChannelMessagesCallback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('チャット'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<PostListItem>>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          // データがない場合
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          // データがある場合
          List<PostListItem> postItems = snapshot.data!;
          return ListView.builder(
            itemCount: postItems.length,
            itemBuilder: (context, index) {
              PostListItem item = postItems[index];
              return ListTile(
                title: Text('Item ${item.name}'),
                subtitle: Text(item.text),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostScreen()),
          );
        },
      ),
    );
  }
}
