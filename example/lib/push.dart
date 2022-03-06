import 'package:flutter/material.dart';

import 'package:umeng_push_sdk/umeng_push_sdk.dart';
import 'helper.dart';

class Push extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PushState();
  }
}

class _PushState extends State<Push> with AutomaticKeepAliveClientMixin {
  TextEditingController controller = TextEditingController();

  late Map<String, VoidCallback?> methods;

  @override
  void initState() {
    super.initState();
    methods = {
      'agree': () async {
        UmengHelper.agree();
      },
      'register': () => UmengPushSdk.register(),
      'getDeviceToken': () async {
        String? deviceToken = await UmengPushSdk.getRegisteredId();
        if (deviceToken != null) {
          controller.text = deviceToken;
        }
      },
      // 'pushEnable': () async => UmengPushSdk.setPushEnable(true),
      'addAlias': () async => controller.text =
          (await UmengPushSdk.addAlias("myAlias", "SINA_WEIBO")).toString(),
      'removeAlias': () async => controller.text =
          (await UmengPushSdk.removeAlias("myAlias", "SINA_WEIBO")).toString(),
      'setAlias': () async => controller.text =
          (await UmengPushSdk.setAlias("myAlias", "SINA_WEIBO")).toString(),
      'addTags': () async =>
          controller.text = (await UmengPushSdk.addTags(["myTag1", "myTag2", "myTag3"])).toString(),
      'removeTags': () async => controller.text =
          (await UmengPushSdk.removeTags(["myTag1", "myTag2", "myTag3"])).toString(),
      'getAllTags': () async =>
          controller.text = (await UmengPushSdk.getTags()).toString()
    };
    UmengPushSdk.setTokenCallback((result) {
      controller.text = result;
    });
    UmengPushSdk.setMessageCallback((result) {
      controller.text = result;
    });
  }

  @override
  void dispose() {
    super.dispose();
    UmengPushSdk.setTokenCallback(null);
    UmengPushSdk.setMessageCallback(null);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('PushSample'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              TextField(
                maxLines: 3,
                controller: controller,
                maxLength: 100,
              ),
              Expanded(
                  child: Wrap(
                runSpacing: 10,
                spacing: 10,
                children: methods.keys
                    .map((e) => ElevatedButton(
                          child: Text(e),
                          onPressed: methods[e],
                        ))
                    .toList(),
              )),
            ],
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
