package com.jwj.projectflutter

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import com.android.volley.AuthFailureError
import com.android.volley.DefaultRetryPolicy
import com.android.volley.Request
import com.android.volley.Response
import com.android.volley.toolbox.JsonObjectRequest
import com.android.volley.toolbox.Volley
import com.microsoft.identity.client.*
import org.json.JSONObject


class CallOneDriveActivity : Activity() {
    private val CLIENT_ID = "94e6f01c-2239-4fec-9fed-b28ef20a649a"
    private val SCOPES = arrayOf("https://graph.microsoft.com/User.Read")
    private val MSGRAPH_URL = "https://graph.microsoft.com/v1.0/me"

    /* UI & Debugging Variables */
    private val TAG = CallOneDriveActivity::class.java.simpleName

    private lateinit var callGraphButton: Button
    private lateinit var signOutButton: Button

    /* Azure AD Variables */
    private var sampleApp: PublicClientApplication? = null
    private lateinit var authResult: AuthenticationResult


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.call_onedrive_activity)

        callGraphButton = findViewById(R.id.callGraph)
        signOutButton = findViewById(R.id.clearCache)

        callGraphButton.setOnClickListener {
            onCallGraphClicked()
        }

        signOutButton.setOnClickListener {
            onSignOutClicked()
        }/* Configure your sample app and save state for this activity */
        sampleApp = null
        if (sampleApp == null) {
            sampleApp = PublicClientApplication(
                    this.applicationContext,
                    CLIENT_ID)
        }

/* Attempt to get a user and acquireTokenSilent
* If this fails we do an interactive request
*/
        var users: List<User>?
        try {
            users = sampleApp?.users?.toList()

            if (users != null && users.size == 1) {
                /* We have 1 user */
                sampleApp?.acquireTokenSilentAsync(SCOPES, users[0], getAuthSilentCallback())
            } else {
                /* We have no user */
                /* Let's do an interactive request */
                sampleApp?.acquireToken(this, SCOPES, getAuthInteractiveCallback());
            }
        } catch (e: MsalClientException) {
            Log.d(TAG, "MSAL Exception Generated while getting users: " + e.toString())

        } catch (e: IndexOutOfBoundsException) {
            Log.d(TAG, "User at this position does not exist: " + e.toString())
        }

    }

//
// App callbacks for MSAL
// ======================
// getActivity() - returns activity so we can acquireToken within a callback
// getAuthSilentCallback() - callback defined to handle acquireTokenSilent() case
// getAuthInteractiveCallback() - callback defined to handle acquireToken() case
//

    fun getActivity(): Activity {
        return this
    }

    /* Callback method for acquireTokenSilent calls
    * Looks if tokens are in the cache (refreshes if necessary and if we don't forceRefresh)
    * else errors that we need to do an interactive request.
    */
    private fun getAuthSilentCallback(): AuthenticationCallback {
        return object : AuthenticationCallback {

            override fun onSuccess(authenticationResult: AuthenticationResult) {
                /* Successfully got a token, call Graph now */
                Log.d(TAG, "Successfully authenticated")

                /* Store the authResult */
                authResult = authenticationResult

                /* call graph */
                callGraphAPI()

                /* update the UI to post call Graph state */
                updateSuccessUI()
            }

            override fun onError(exception: MsalException) {
                /* Failed to acquireToken */
                Log.d(TAG, "Authentication failed: " + exception.toString());

                when (exception) {
                    is MsalClientException -> {
                        /* Exception inside MSAL, more info inside MsalError.java */
                    }
                    is MsalServiceException -> {
                        /* Exception when communicating with the STS, likely config issue */
                    }
                    is MsalUiRequiredException -> {
                        /* Tokens expired or no session, retry with interactive */
                    }
                }
            }

            override fun onCancel() {
                /* User cancelled the authentication */
                Log.d(TAG, "User cancelled login.")
            }
        };
    }

    /* Callback used for interactive request.  If succeeds we use the access
    * token to call the Microsoft Graph. Does not check cache
    */
    private fun getAuthInteractiveCallback(): AuthenticationCallback {
        return object : AuthenticationCallback {

            override fun onSuccess(authenticationResult: AuthenticationResult) {
                /* Successfully got a token, call graph now */
                Log.d(TAG, "Successfully authenticated");
                Log.d(TAG, "ID Token: " + authenticationResult.idToken)

                /* Store the auth result */
                authResult = authenticationResult

                /* call Graph */
                callGraphAPI()

                /* update the UI to post call Graph state */
                updateSuccessUI()
            }

            override fun onError(exception: MsalException) {
                /* Failed to acquireToken */
                Log.d(TAG, "Authentication failed: " + exception.toString());

                if (exception is MsalClientException) {
                    /* Exception inside MSAL, more info inside MsalError.java */
                } else if (exception is MsalServiceException) {
                    /* Exception when communicating with the STS, likely config issue */
                }
            }

            override fun onCancel() {
                /* User cancelled the authentication */
                Log.d(TAG, "User cancelled login.");
            }
        };
    }

    /* Set the UI for successful token acquisition data */
    private fun updateSuccessUI() {
        callGraphButton.visibility = View.INVISIBLE
        signOutButton.visibility = View.VISIBLE
        this.findViewById<View>(R.id.welcome).visibility = View.VISIBLE
        findViewById<TextView>(R.id.welcome).text = "Welcome, " + authResult.user.name
        findViewById<View>(R.id.graphData).visibility = View.VISIBLE
    }

    /* Use MSAL to acquireToken for the end-user
    * Callback will call Graph api w/ access token & update UI
    */
    private fun onCallGraphClicked() {
        sampleApp?.acquireToken(getActivity(), SCOPES, getAuthInteractiveCallback());
    }

/* Handles the redirect from the System Browser */

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent) {
        sampleApp?.handleInteractiveRequestRedirect(requestCode, resultCode, data)
    }

    private fun callGraphAPI() {
        Log.d(TAG, "Starting volley request to graph")

        /* Make sure we have a token to send to graph */
        if (authResult.accessToken == null) {
            return
        }

        val queue = Volley.newRequestQueue(this)
        val parameters = JSONObject()

        try {
            parameters.put("key", "value")
        } catch (e: Exception) {
            Log.d(TAG, "Failed to put parameters: " + e.toString())
        }

        val request = object : JsonObjectRequest(Request.Method.GET, MSGRAPH_URL,
                parameters,
                Response.Listener<JSONObject> { response ->
                    /* Successfully called graph, process data and send to UI */
                    Log.d(TAG, "Response: " + response.toString())
                    updateGraphUI(response)
                },
                Response.ErrorListener { error -> Log.d(TAG, "Error: " + error.toString()) }) {
            @Throws(AuthFailureError::class)
            override fun getHeaders(): Map<String, String> {
                val headers = HashMap<String, String>()
                headers.put("Authorization", "Bearer " + authResult.accessToken)
                return headers
            }
        }

        Log.d(TAG, "Adding HTTP GET to Queue, Request: " + request.toString())

        request.retryPolicy = DefaultRetryPolicy(
                3000,
                DefaultRetryPolicy.DEFAULT_MAX_RETRIES,
                DefaultRetryPolicy.DEFAULT_BACKOFF_MULT)
        queue.add(request)
    }

    /* Sets the Graph response */
    private fun updateGraphUI(graphResponse: JSONObject) {
        val graphText = findViewById<View>(R.id.graphData) as TextView
        graphText.text = graphResponse.toString()
    }

    private fun onSignOutClicked() {

        /* Attempt to get a user and remove their cookies from cache */
        var users: List<User>? = null

        try {
            users = sampleApp?.users

            if (users == null) {
                /* We have no users */

            } else if (users.size == 1) {
                /* We have 1 user */
                /* Remove from token cache */
                sampleApp?.remove(users[0])
                updateSignedOutUI()

            } else {
                /* We have multiple users */
                for (i in users.indices) {
                    sampleApp?.remove(users[i])
                }
            }

            Toast.makeText(baseContext, "Signed Out!", Toast.LENGTH_SHORT)
                    .show()

        } catch (e: MsalClientException) {
            Log.d(TAG, "MSAL Exception Generated while getting users: " + e.toString())

        } catch (e: IndexOutOfBoundsException) {
            Log.d(TAG, "User at this position does not exist: " + e.toString())
        }

    }

    /* Set the UI for signed-out user */
    private fun updateSignedOutUI() {
        callGraphButton.visibility = View.VISIBLE
        signOutButton.visibility = View.INVISIBLE
        findViewById<View>(R.id.welcome).visibility = View.INVISIBLE
        findViewById<View>(R.id.graphData).visibility = View.INVISIBLE
        (findViewById<View>(R.id.graphData) as TextView).text = "No Data"
    }
}