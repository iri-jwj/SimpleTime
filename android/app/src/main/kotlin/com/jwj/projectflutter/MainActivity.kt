package com.jwj.projectflutter

import android.content.Intent
import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    private lateinit var plugin: JumpToSynchronizePlugin
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
        plugin = JumpToSynchronizePlugin.register((this as PluginRegistry).registrarFor(JumpToSynchronizePlugin.channel))
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent) {
        plugin.handleRequestResult(requestCode, resultCode, data)
    }
}
