function displayPopup() {
	var l=document.getElementsByClassName('bua b-c-W')[0];
	var e=document.createEvent('MouseEvents');
	e.initEvent('click',true,true);
	var cancelled = !l.dispatchEvent(e);
	
	return cancelled;
}