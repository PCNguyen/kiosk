eraseCookie("SSID");
eraseCookie("SID");
eraseCookie("SAPISID");
eraseCookie("PREF");
eraseCookie("NID");
eraseCookie("LSID");
eraseCookie("HSID");
eraseCookie("GAPS");
eraseCookie("GALX");
eraseCookie("APISID");
eraseCookie("ACCOUNT_CHOOSER");

webkit.messageHandlers.CookieClearCompleted.postMessage('done');