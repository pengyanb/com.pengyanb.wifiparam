package org.apache.cordova.PybWifiParameters;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;


public class PybWifiParameters extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("getCurrentWifiSsid")) {
            this.getCurrentLocalWifiSSID(callbackContext);
            return true;
        }
        return false;
    }
    private void getCurrentLocalWifiSSID(CallbackContext callbackContext)
    {
        String ssid = "Unknown";
        Context context = this.cordova.getActivity().getApplicationContext();
        ConnectivityManager connectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo networkInfo = connectivityManager.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
        if(networkInfo != null && networkInfo.isConnected())
        {
            WifiManager wifiManager = (WifiManager) context.getSystemService(context.WIFI_SERVICE);
            WifiInfo wifiInfo = wifiManager.getConnectionInfo();
            System.out.println(String.format("[%s]", wifiInfo.toString()));
            System.out.println(String.format("[%s]", wifiInfo.getSSID()));
            ssid = wifiInfo.getSSID();
            if (ssid.startsWith("\"") && ssid.endsWith("\""))
                ssid = ssid.substring(1, ssid.length()-1);
            callbackContext.success(ssid);
        }
        else
        {
            callbackContext.error("Error: unable to get wifi parameters");
        }
    }

}