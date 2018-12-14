package com.jwj.projectflutter

import android.app.Activity
import android.content.Intent
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry


class JumpToSynchronizePlugin(private val activity: Activity) : MethodChannel.MethodCallHandler {

    private var microsoftToken: GetMicrosoftToken? = null

    companion object {
        private val TAG = JumpToSynchronizePlugin::class.java.simpleName
        const val channel = "com.jwj.project_flutter/jump"
        fun register(registry: PluginRegistry.Registrar): JumpToSynchronizePlugin {
            val methodChannel = MethodChannel(registry.messenger(), channel)
            val plugin = JumpToSynchronizePlugin(registry.activity())
            methodChannel.setMethodCallHandler(plugin)
            return plugin
        }

    }

    override fun onMethodCall(p0: MethodCall?, p1: MethodChannel.Result?) {
        if (microsoftToken == null) {
            microsoftToken = GetMicrosoftToken(activity)
        }

        when (p0?.method) {
            "synchronize" -> {

            }
            "connect" -> {
                Log.d(TAG, "in connectMethod")
                microsoftToken!!.getToken(p1)
            }
            "disconnect" -> {
                Log.d(TAG, "in disconnect")
                val result = microsoftToken!!.signOut()
                if (result) {
                    p1?.success("sign out success")
                } else {
                    p1?.error("disconnect", "fail to sign out", null)
                }
                Log.d(TAG, "result=$result")
            }
        }
    }

    fun handleRequestResult(requestCode: Int, resultCode: Int, data: Intent) {
        microsoftToken?.handleRequestResult(requestCode, resultCode, data)
    }

}