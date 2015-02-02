function displayPopup() {
	var l = document.getElementsByClassName('bua b-c-W')[0];
	var e = document.createEvent('MouseEvents');
	e.initEvent('click',true,true);
	var cancelled = !l.dispatchEvent(e);
	
	return cancelled;
}

function detectNoGplus() {
	var signupDialog = document.getElementsByClassName('Ea-q')[0];
	
	if (signupDialog) {
		webkit.messageHandlers.SignupDetect.postMessage('true');
	}
}

function detectDoneDialog() {
	var doneDialog = document.getElementsByClassName('Hme')[0];
	
	if (doneDialog) {
		webkit.messageHandlers.DoneDialogDetect.postMessage('true');
	}
}

function addEventHandler(elem,eventType,handler) {
	if (elem.addEventListener)
		elem.addEventListener (eventType,handler,false);
	else if (elem.attachEvent)
		elem.attachEvent ('on'+eventType,handler);
}

function listenToKioskSubmit() {
	var sEventType = 'click';
	var submitButton = document.getElementsByClassName('submit button')[0];
	
	addEventHandler(submitButton,sEventType,submitKiosk);
}

function submitKiosk() {
	webkit.messageHandlers.KioskSubmitDetect.postMessage('true');
}