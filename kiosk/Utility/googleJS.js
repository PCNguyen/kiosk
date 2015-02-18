/*********************************
 * cookie handling
 *********************************/
function createCookie(name,value,days) {
	if (days) {
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
}

function eraseCookie(name) {
	createCookie(name,"",-1);
}

//--main hook
function removeGoogleLogin() {
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
}

/*********************************
 * Handling Style
 *********************************/

function addCustomStyle(styleDetail) {
	var styleElement = document.createElement('style');
	document.documentElement.appendChild(styleElement);
	styleElement.textContent = styleDetail;
}

function styleLoginPage() {
	addCustomStyle('#Passwd {margin-top:10px !important;} ;');
}

function styleBackgroundHidden() {
	addCustomStyle('.Z0 {display:none !important;} ;');
}

function styleReviewTextField() {
	addCustomStyle('textarea.mKd {height:250px !important; font-size:2em !important;} .vVc {font-size:3em !important;} .Fme {font-size:2em !important;} .bxd {font-size:1em !important;} ;');
}

function styleReviewButtons() {
	addCustomStyle('.pKd div[role=button] {width:130px !important; height:40px !important; font-size:2em !important; padding-top:10px !important;} ;');
}

function styleReviewBox() {
	addCustomStyle('div[role=dialog] {left:10px !important;} #glass-content, #glass-content iframe, .The {width:745px !important; height:580px !important;} ;');
	styleReviewTextField();
	styleReviewButtons();
}

function styleConfirmationSourceHidden() {
	addCustomStyle('div.uQc.ymc, div[role=button].yVc {display:none !important;} ;');
}

function styleConfirmationButtons() {
	addCustomStyle('.Hme div[role=button] {width:130px !important; height:40px !important; font-size:2em !important; padding-top:10px !important;} div[role=button].uVc {width:130px !important; height:40px !important; font-size:2em !important; padding-top:20px !important;} ;');
}

//--main hook
function styleMultiPage() {
	styleLoginPage();
	styleBackgroundHidden();
	styleReviewBox();
	styleConfirmationSourceHidden();
	styleConfirmationButtons();
}

/*****************************************
* handling selection && element detection
******************************************/

function manualClickClassElements(className, index)
{
	var element = document.getElementsByClassName(className)[index];
	var clickEvent = document.createEvent('MouseEvents');
	clickEvent.initEvent('click',true,true);
	var cancelled = !element.dispatchEvent(clickEvent);
	
	return cancelled;
}

function manualClickClassElement(className)
{
	manualClickClassElements(className, 0)
}

//--main hook
function triggerReviewWidget()
{
	manualClickClassElement('bua b-c-W');
}

//--main hook
function detectNoGplus() {
	var signupDialog = document.getElementsByClassName('Ea-q')[0];
	
	if (signupDialog) {
		webkit.messageHandlers.SignupDetect.postMessage('true');
	}
}

//--main hook
function detectDoneDialog() {
	var doneDialog = document.getElementById('glass-content');
	
	if (!doneDialog) {
		webkit.messageHandlers.DoneDialogDetect.postMessage('true');
	}
}

function triggerRatingClick(starIndex) {
	//--get the widget iframe
	iframes = document.getElementsByTagName('iframe');
	var widgetFrame;
	for (var i = 0; i<iframes.length; i++) {
		var sourceURL = iframes[i].getAttribute('src');
		if (sourceURL && sourceURL.indexOf("widget") > 0) {
			widgetFrame = iframes[i];
		}
	}
	
	//--access the doc elements
	doc = widgetFrame.contentDocument || widgetFrame.contentWindow.document;
	
	//--search for the star element
	var element = doc.getElementsByClassName('b-db-ac')[starIndex];
	
	//--simulate the click event
	var clickEvent = document.createEvent('MouseEvents');
	clickEvent.initEvent('click',true,true);
	var cancelled = !element.dispatchEvent(clickEvent);
	
	return cancelled;
}
