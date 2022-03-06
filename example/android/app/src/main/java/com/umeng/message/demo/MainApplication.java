package com.umeng.message.demo;

import com.umeng.commonsdk.utils.UMUtils;
import com.umeng.message.demo.helper.MyPreferences;
import com.umeng.message.demo.helper.PushHelper;
import com.umeng.commonsdk.UMConfigure;

import io.flutter.app.FlutterApplication;

public class MainApplication extends FlutterApplication {

    @Override
    public void onCreate() {
        super.onCreate();
        UMConfigure.setLogEnabled(true);
        PushHelper.preInit(this);
        if (MyPreferences.getInstance(this).hasAgreePrivacyAgreement()) {
            if (UMUtils.isMainProgress(this)) {
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        PushHelper.init(getApplicationContext());
                    }
                }).start();
            } else {
                PushHelper.init(getApplicationContext());
            }
        }
    }

}