package com.justep.cordova.plugin.pingpp;

import android.content.ComponentName;
import android.content.Intent;
import com.pingplusplus.android.PaymentActivity;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import android.util.Log;
import com.pingplusplus.android.Pingpp;
import com.pingplusplus.android.PingppLog;

public class PingppPlugin extends CordovaPlugin {

	private static final int REQUEST_CODE_PAYMENT = 1;
	private CallbackContext callbackContext;
	private String charge;

	@Override
    public boolean execute(String action, JSONArray data, CallbackContext callbackContext) throws JSONException {

        this.callbackContext = callbackContext;
        
        if (action.equals("createPayment")) {
            charge = data.get(0).toString();

            Intent intent = new Intent(this.cordova.getActivity(), PaymentActivity.class);
            intent.putExtra(PaymentActivity.EXTRA_CHARGE, charge);
            this.cordova.startActivityForResult(this, intent, Pingpp.REQUEST_CODE_PAYMENT);
            return true;
        } else if(action.equals("getVersion")){
        	callbackContext.success(Pingpp.VERSION);
        	return true;
        } else if(action.equals("setDebugMode")) {
        	String enable = data.get(0).toString();
        	if("true".equals(enable)){
        		PingppLog.DEBUG = true;
            } else {
                PingppLog.DEBUG = false;
            }
        }
        return false;
    }

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {

		if (requestCode == Pingpp.REQUEST_CODE_PAYMENT) {
			if (resultCode == android.app.Activity.RESULT_OK) {
				String result = data.getExtras().getString("pay_result");
				String errorMsg = data.getExtras().getString("error_msg"); // 错误信息
				String extraMsg = data.getExtras().getString("extra_msg"); // 错误信息
				
				try{
					JSONObject object = new JSONObject();
					JSONObject err = new JSONObject();
					err.put("charge", charge);
					if (result.equals("success")) {
						object.put("err", err);
						object.put("result", result);
						callbackContext.success(object);
					} else {
						err.put("msg",errorMsg);
						object.put("err", err);
						object.put("result", result);
						callbackContext.error(object);
					}
				} catch (JSONException e) {
                    e.printStackTrace();
                }
			} else if (resultCode == android.app.Activity.RESULT_CANCELED) {
				callbackContext.error("cancel");
			}
		}
	}
}
