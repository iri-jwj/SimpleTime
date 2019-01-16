package com.jwj.projectflutter

import android.app.Activity
import android.content.Intent
import android.util.Log
import com.microsoft.identity.client.*
import io.flutter.plugin.common.MethodChannel

class GetMicrosoftToken(private val activity: Activity) {
    private val clientId = "94e6f01c-2239-4fec-9fed-b28ef20a649a"
    private val scopes = arrayOf("https://graph.microsoft.com/Files.ReadWrite",
            "https://graph.microsoft.com/User.Read",
            "https://graph.microsoft.com/Files.ReadWrite.AppFolder")
    private val msGraphUrl = "https://graph.microsoft.com/v1.0/me"
    private val authority = "https://login.microsoftonline.com/common"


    private var sampleApp: PublicClientApplication? = null
    private val TAG = GetMicrosoftToken::class.java.simpleName
    private var authResult: AuthenticationResult? = null
    private var res: MethodChannel.Result? = null
    fun getToken(res: MethodChannel.Result?) {
        this.res = res
        if (sampleApp == null) {
            sampleApp = PublicClientApplication(
                    activity.applicationContext,
                    clientId)
        }

        val users: List<User>?
        try {
            users = sampleApp?.users?.toList()

            if (users != null && users.size == 1) {
                /* We have 1 user */
                sampleApp?.acquireTokenSilentAsync(scopes, users[0], getAuthSilentCallback())
            } else {
                /* We have no user */
                /* Let's do an interactive request */
                sampleApp?.acquireToken(activity, scopes, getAuthInteractiveCallback())
            }
        } catch (e: MsalClientException) {
            Log.d(TAG, "MSAL Exception Generated while getting users: " + e.toString())

        } catch (e: IndexOutOfBoundsException) {
            Log.d(TAG, "User at this position does not exist: " + e.toString())
        }
    }

    private fun getAuthSilentCallback(): AuthenticationCallback {
        return object : AuthenticationCallback {

            override fun onSuccess(authenticationResult: AuthenticationResult) {
                /* Successfully got a token, call Graph now */
                Log.d(TAG, "Successfully authenticated")

                /* Store the authResult */
                authResult = authenticationResult
                sendResultToFlutter(authResult?.accessToken)
                /* call graph */
                /* update the UI to post call Graph state */
            }

            override fun onError(exception: MsalException) {
                /* Failed to acquireToken */
                Log.d(TAG, "Authentication failed: " + exception.toString())
                when (exception) {
                    is MsalClientException -> {
                        /* Exception inside MSAL, more info inside MsalError.java */
                        sendResultToFlutter("failed inside")
                    }
                    is MsalServiceException -> {
                        /* Exception when communicating with the STS, likely config issue */
                        sendResultToFlutter("failed in config")
                    }
                    is MsalUiRequiredException -> {
                        /* Tokens expired or no session, retry with interactive */
                        sendResultToFlutter("retry")
                    }
                }
            }

            override fun onCancel() {
                /* User cancelled the authentication */
                Log.d(TAG, "User cancelled login.")
                res?.success("cancel")

            }
        }
    }

    /* Callback used for interactive request.  If succeeds we use the access
    * token to call the Microsoft Graph. Does not check cache
    */
    private fun getAuthInteractiveCallback(): AuthenticationCallback {
        return object : AuthenticationCallback {

            override fun onSuccess(authenticationResult: AuthenticationResult) {
                /* Successfully got a token, call graph now */
                Log.d(TAG, "Successfully authenticated")
                Log.d(TAG, "ID Token: " + authenticationResult.idToken)

                /* Store the auth result */
                authResult = authenticationResult
                sendResultToFlutter(authResult?.accessToken)


                /* call Graph */
                /* update the UI to post call Graph state */
            }

            override fun onError(exception: MsalException) {
                /* Failed to acquireToken */
                Log.d(TAG, "Authentication failed: " + exception.toString())
                if (exception is MsalClientException) {
                    /* Exception inside MSAL, more info inside MsalError.java */
                    sendResultToFlutter("failed inside")
                } else if (exception is MsalServiceException) {
                    /* Exception when communicating with the STS, likely config issue */
                    sendResultToFlutter("failed config")
                }
            }

            override fun onCancel() {
                /* User cancelled the authentication */
                Log.d(TAG, "User cancelled login.")
                sendResultToFlutter("failed cancel")

            }
        }
    }

    private fun sendResultToFlutter(message: String?) {
        if (res != null) {
            res?.success(message)
            res = null
        }
    }


/* Handles the redirect from the System Browser */


    fun handleRequestResult(requestCode: Int, resultCode: Int, data: Intent) {
        sampleApp?.handleInteractiveRequestRedirect(requestCode, resultCode, data)
    }

    /*private fun callGraphAPI() {
        Log.d(TAG, "Starting volley request to graph")

        *//* Make sure we have a token to send to graph *//*
        if (authResult?.accessToken == null) {
            return
        }

        val queue = Volley.newRequestQueue(activity)
        val parameters = JSONObject()

        try {
            parameters.put("key", "value")
        } catch (e: Exception) {
            Log.d(TAG, "Failed to put parameters: " + e.toString())
        }

        val request = object : JsonObjectRequest(Request.Method.GET, msGraphUrl,
                parameters,
                Response.Listener<JSONObject> { response ->
                    *//* Successfully called graph, process data and send to UI *//*
                    Log.d(TAG, "Response: " + response.toString())
                },
                Response.ErrorListener { error -> Log.d(TAG, "Error: " + error.toString()) }) {
            @Throws(AuthFailureError::class)
            override fun getHeaders(): Map<String, String> {
                val headers = HashMap<String, String>()
                headers.put("Authorization", "Bearer " + authResult?.accessToken)
                return headers
            }
        }

        Log.d(TAG, "Adding HTTP GET to Queue, Request: " + request.toString())

        request.retryPolicy = DefaultRetryPolicy(
                3000,
                DefaultRetryPolicy.DEFAULT_MAX_RETRIES,
                DefaultRetryPolicy.DEFAULT_BACKOFF_MULT)
        queue.add(request)
    }*/


    fun signOut(): Boolean {
        var result = true
        /* Attempt to get a user and remove their cookies from cache */
        val users: List<User>?
        try {
            users = sampleApp?.users
            when {
                users == null -> {
                    /* We have no users */
                }
                users.size == 1 -> /* We have 1 user */
                    /* Remove from token cache */
                    sampleApp?.remove(users[0])
                else -> /* We have multiple users */
                    for (i in users.indices) {
                        sampleApp?.remove(users[i])
                    }
            }
        } catch (e: MsalClientException) {
            Log.d(TAG, "MSAL Exception Generated while getting users: " + e.toString())
            result = false

        } catch (e: IndexOutOfBoundsException) {
            Log.d(TAG, "User at this position does not exist: " + e.toString())
            result = false
        }
        return result
    }
}