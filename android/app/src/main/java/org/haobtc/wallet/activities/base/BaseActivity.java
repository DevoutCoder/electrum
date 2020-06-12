package org.haobtc.wallet.activities.base;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.WindowManager;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import org.haobtc.wallet.R;
import org.haobtc.wallet.utils.NfcUtils;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public abstract class BaseActivity extends AppCompatActivity {
    private String strUTF8;
    private String filed1utf;

    @SuppressLint("SourceLockedOrientationActivity")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getLayoutId() != R.layout.activity_lunch) {
            setContentView(getLayoutId());
        }
        // In order to runtime error `fix Only fullscreen activities can request orientation` in some phone type like samsung Galaxy s7
        if (getLayoutId() != R.layout.bluetooth_nfc) {
            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);//Disable horizontal screen
        }
        mBinitState();
        initView();
        initData();

    }

    public abstract int getLayoutId();

    public abstract void initView();

    public abstract void initData();

    //activity intent
    public void mIntent(Class<?> mActivity) {
        Intent intent = new Intent(this, mActivity);
        startActivity(intent);
    }
    @Override
    protected void onResume() {
        super.onResume();
        if (NfcUtils.mNfcAdapter != null && NfcUtils.mNfcAdapter.isEnabled()) {
            // enable nfc discovery for the app
            Log.i("NFC", "为本App启用NFC感应");
            NfcUtils.mNfcAdapter.enableForegroundDispatch(this, NfcUtils.mPendingIntent, NfcUtils.mIntentFilter, NfcUtils.mTechList);
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        if (NfcUtils.mNfcAdapter != null && NfcUtils.mNfcAdapter.isEnabled()) {
            // disable nfc discovery for the app
            NfcUtils.mNfcAdapter.disableForegroundDispatch(this);
            Log.i("NFC", "禁用本App的NFC感应");
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        NfcUtils.mNfcAdapter = null;
    }
    //toast short
    public void mToast(String str) {
        Toast.makeText(this, str, Toast.LENGTH_SHORT).show();
    }

    //toast long
    public void mlToast(String str) {
        Toast.makeText(this, str, Toast.LENGTH_LONG).show();
    }

    //switch Chinese
    public void mTextChinese() {
        Locale.setDefault(Locale.CHINESE);
        Configuration config = getBaseContext().getResources().getConfiguration();
        config.locale = Locale.CHINESE;
        getBaseContext().getResources().updateConfiguration(config
                , getBaseContext().getResources().getDisplayMetrics());
    }

    //switch English
    public void mTextEnglish() {
        Locale.setDefault(Locale.ENGLISH);
        Configuration config1 = getBaseContext().getResources().getConfiguration();
        config1.locale = Locale.ENGLISH;
        getBaseContext().getResources().updateConfiguration(config1
                , getBaseContext().getResources().getDisplayMetrics());
    }

    //UTF-8 to text
    public String mUTFTtoText(String str) {
        try {
            strUTF8 = URLDecoder.decode(str, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return strUTF8;
    }

    //text  to  utf-8
    public String mmTextToutf8(String strFiled) {
        String filed1HangyeUTF = null;
        try {
            filed1HangyeUTF = new String(strFiled.getBytes(StandardCharsets.UTF_8));
            filed1utf = URLEncoder.encode(filed1HangyeUTF, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return filed1utf;

    }

    //get now time
    public String mGetNowDatetime() {
        @SuppressLint("SimpleDateFormat") SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date curDate = new Date(System.currentTimeMillis());
        return formatter.format(curDate);
    }

    //judge mobile is wrong or right
    public boolean isMobileNO(String mobiles) {
        Pattern p = Pattern
                .compile("^((17[0-9])|(14[0-9])|(13[0-9])|(15[^4,\\D])|(16[0-9])|(18[0,5-9]))\\d{8}$");
        Matcher m = p.matcher(mobiles);

        return m.matches();
    }

    //judge pass type  must have Punctuation、Case letters、num、At least 8.
    public boolean isPassType(String mobiles) {
        Pattern p = Pattern
                .compile("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}");
        Matcher m = p.matcher(mobiles);

        return m.matches();
    }

    //get versionCode
    public int getLocalVersion(Context ctx) {
        int localVersion = 0;
        try {
            PackageInfo packageInfo = ctx.getApplicationContext()
                    .getPackageManager()
                    .getPackageInfo(ctx.getPackageName(), 0);
            localVersion = packageInfo.versionCode;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return localVersion;
    }

    /**
     * get  versionName
     *
     */
    public String mGetVersionName(Context context) {
        PackageManager packageManager = context.getPackageManager();
        PackageInfo packageInfo;
        String versionName = "";
        try {
            packageInfo = packageManager.getPackageInfo(context.getPackageName(), 0);
            versionName = packageInfo.versionName;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return versionName;
    }

    //Picture compression
    public Bitmap mPicYasuo(String imgPath) {
        /**
         * Compress picture
         */
        BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;
        options.inSampleSize = 2;
        options.inJustDecodeBounds = false;
        return BitmapFactory.decodeFile(imgPath, options);

    }

    /**
     * Set transparent immersion bar
     */
    public void mInitState() {
        //transparent immersion bar
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
        //Transparent navigation bar will cause virtual buttons to disappear (for example, Huawei)
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);
    }

    /**
     * Set transparent immersion bar:white text
     */
    public void mWhiteinitState() {
//        LinearLayout top_manger=findViewById(R.id.top_manger);
        //透明状态栏
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);

    }

    /**
     * Set transparent immersion bar : white backgrand black text
     */
    public void mBinitState() {
        //other one write
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
        getWindow().setStatusBarColor(Color.WHITE);
        getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);

    }

    //Transformation  price
    public String mNumToPrice(String string) {
        // string type price to double
        Double numDouble = Double.parseDouble(string);
        // Want to convert to the currency format of the specified country 
        NumberFormat format = NumberFormat.getCurrencyInstance(Locale.CHINA);
        // Return the string type of the converted currency 
        return format.format(numDouble);
    }

}