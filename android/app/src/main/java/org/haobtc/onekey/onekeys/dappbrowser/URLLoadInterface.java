package org.haobtc.onekey.onekeys.dappbrowser;

public interface URLLoadInterface {

    void onWebpageLoaded(String url, String title);

    void onWebpageLoadComplete();
}