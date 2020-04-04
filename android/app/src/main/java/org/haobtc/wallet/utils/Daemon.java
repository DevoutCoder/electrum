package org.haobtc.wallet.utils;

import android.util.Log;

import androidx.appcompat.app.AppCompatActivity;

import org.greenrobot.eventbus.EventBus;
import org.haobtc.wallet.event.FirstEvent;
import org.haobtc.wallet.event.SecondEvent;
import com.chaquo.python.PyObject;

import java.lang.ref.WeakReference;

public class Daemon {
    public static PyObject commands = null;
    public static PyObject network = null;
    private static Daemon daemon;

    private Daemon() {
    }
    public static Daemon getInstance() {
        if (daemon == null) {
            synchronized (Daemon.class) {
                if (daemon  == null) {
                    daemon = new Daemon();
                }
            }
        }
        return daemon;
    }
    public void onCallback(String event, String msg) {
        Log.i("onCallback", "=================="+event +"   ============================    "+ msg);
        if (event.equals("update_status")){
            EventBus.getDefault().post(new SecondEvent(msg));
        }else if (event.equals("update_history")){
            EventBus.getDefault().post(new FirstEvent("22"));
        }else if (event.equals("set_server_status")){
            Log.i("onCallback", "自定义节点添加+++++++++++++++++++++++    "+ msg);
        }

    }
}
