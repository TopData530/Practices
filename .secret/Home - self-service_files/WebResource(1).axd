Type.registerNamespace('Datatel');

//event  management
/*
Internal object representing a browser event
*/
EventObject = function(target, type, functionPointer, userCapture)
{
    this.target = target;
    this.type = type;
    this.functionPointer = functionPointer;
    this.userCapture =userCapture; 
    return this;
}
/*
Cross browser utility functions
*/
CrossBrowserUtility = function()
{
    this.registeredEvents =  new Array();
    return this;
}


/*
Add the event to the target, and keep track of it 
so we can remove the event on window unload
*/
CrossBrowserUtility.prototype.addEvent=function(target, type, functionPointer, useCapture)
{
    if (target.addEventListener)
    {
        target.addEventListener(type, functionPointer, useCapture);
        this.registeredEvents.push(new EventObject(target, type, functionPointer, useCapture));
        return true;
    }
    else if (target.attachEvent("on" + type, functionPointer))
    {
        this.registeredEvents.push(new EventObject(target, type, functionPointer, useCapture));
        return true;
    }
    else  
        return false;
}
/*
Remove the event from the target, and remove the corresponding
event object from the registry
*/
CrossBrowserUtility.prototype.removeEvent=function(target, type, functionPointer, useCapture)
{
    this.removeEventObject(target, type, functionPointer, useCapture);
    if (target.removeEventListener)
    {
        target.removeEventListener(type, functionPointer, useCapture);
        return true;
    }
    else if (target.detachEvent("on" + type, functionPointer))
    {
        return true;
    }
    else  
        return false;
}
/*
Remove the event object from the registry
*/
CrossBrowserUtility.prototype.removeEventObject=function(target, type, functionPointer, useCapture)
{
    for(var index=0;index<this.registeredEvents.length;index++)
        if(
            this.registeredEvents[index].target == target &&
            this.registeredEvents[index].type == type &&
            this.registeredEvents[index].functionPointer == functionPointer &&
            this.registeredEvents[index].useCapture == useCapture 
          )
    {
        this.registeredEvents.splice(index,1);
    }
    return false;
}

/*
On window unload, remove all events attached via the 
add event method
*/
CrossBrowserUtility.prototype.onWindowUnload=function()
{
    for(var index=0;index<Utility.registeredEvents.length;index++)
    {
        Utility.removeEvent(
                            Utility.registeredEvents[index].target,
                            Utility.registeredEvents[index].type,
                            Utility.registeredEvents[index].functionPointer,
                            Utility.registeredEvents[index].useCapture
                        );
    }
}
//event infromation
/*
Get the DOM object that triggered this event
*/
CrossBrowserUtility.prototype.getSourceElement = function(e)
{
    if (e && e.srcElement)
        return e.srcElement;
    else if (e && e.target)
        return e.target;
    else 
	  return false;
}
/*
Get the X offset relative to the source element
*/
CrossBrowserUtility.prototype.getEventOffsetX = function(e)
{
    if (e && e.layerX)
        return e.layerX;
    else if (e && e.offsetX)
        return e.offsetX;
    else 
	  return false;
}
/*
Get the Y offset relative to the source element
*/
CrossBrowserUtility.prototype.getEventOffsetY = function(e)
{
    if (e && e.layerY)
        return e.layerY;
    else if (e && e.offsetY)
        return e.offsetY;
    else 
	  return false;
}
/*
Get the key code
*/
CrossBrowserUtility.prototype.getKeyCode = function(e)
{
    if(e.keyCode)
        return e.keyCode;
    else if (e.which)
        return e.which;
    else
        return -1;
}
/*
Cancel event propogation
*/
CrossBrowserUtility.prototype.cancelBubble=function(e)
{
    if (e.preventDefault) 
    {
      e.preventDefault();
      e.stopPropagation();
    } 
    else 
    {
      e.returnValue = false;
      e.cancelBubble = true;
    }
}

/*
Detect browser type
*/
CrossBrowserUtility.prototype.isFireFox = function()
{
    return (typeof window.getComputedStyle != "undefined" && typeof document.createRange != "undefined")
}
CrossBrowserUtility.prototype.isSafari = function()
{
   return navigator.userAgent.toLowerCase().indexOf("safari") >= 0 ;
}
/*
Detect browser type
*/
CrossBrowserUtility.prototype.isIE = function()
{
    return navigator.userAgent.toLowerCase().indexOf("msie") >= 0 && document.all;

    //isOpera: (window.opera && document.getElementById),
    //isIEMac: (this.ie && navigator.userAgent.toLowerCase().indexOf("mac") >= 0),
	//isIE4 : (isIE && !document.getElementById),
	//isNetscape = (document.layers && typeof document.classes != "undefined"),
}
/*
Get actual browser height
*/
CrossBrowserUtility.prototype.getBackgroundColor = function(oDiv)
{
}
/*
Get current style property
*/
CrossBrowserUtility.prototype.getStyleInformation = function(oDiv,style)
{
    /*
    Safari wants style = 'border-top-color'
    IE/FF want borderTopColor
    */
    var newStyle =""
    for(var index=0;index<style.length;index++)
    {
        if(style.charAt(index)=="-")
        {
            newStyle+= style.charAt(index+1).toUpperCase();
            index++;
        }
        else
        {
            newStyle+= style.charAt(index);
        }
    }
    var val;
    if (this.isSafari())
    {
       var styleObj = document.defaultView.getComputedStyle(oDiv, null);
       val=styleObj.getPropertyValue(style);
    }
    else if (this.isIE())
    {
        val=(oDiv.currentStyle[newStyle]);
    }
    else
    {
        var styleObj = document.defaultView.getComputedStyle(oDiv, null);
        val=styleObj[newStyle];
    }
    if(!val)
        val= oDiv.style[style];
    return val;
}

/*
Get actual browser width
*/
CrossBrowserUtility.prototype.getW = function(oDiv)
{
    var width;
    if (this.isIE())
        width=parseInt(oDiv.currentStyle.width,10);
    else
        width=parseInt(document.defaultView.getComputedStyle(oDiv, null).width,10);
    if(isNaN(width))
        width = oDiv.offsetWidth;
    return width;
}

/*
Get actual browser width
*/
CrossBrowserUtility.prototype.getH = function(oDiv)
{
    var height;
    if (this.isIE())
        height=parseInt(oDiv.currentStyle.height,10);
    else
        height=parseInt(document.defaultView.getComputedStyle(oDiv, null).height,10);
    if(isNaN(height))
        height = oDiv.offsetHeight;
    return height;
}
//validation
/*
Check to see if input is alpha numeric
*/
CrossBrowserUtility.prototype.isAlphaNumeric=function(name)
{
    for(var index=0; index<name.length; index++)
    {
        var code = name.charAt(index).charCodeAt(0);
        if((code > 47 && code<59) || (code > 64 && code<91) || (code > 96 && code<123) || (code==32) || name.charAt(index)=='-') //allow spaces and dashes
        {
        }
        else
        {
            return false;
        }
    }
    return true;
}
/*
Check to see if input is a valid date
*/
CrossBrowserUtility.prototype.validateDate=function(dateString)
{
     if(dateString=="")return true;
	 var syntaxCheck=(/^\d{2}[\-/]\d{2}[\-/]\d{4}$/.test(dateString))
	 dateString=dateString.replace(/[\-/]/g,',')
	 dateString=dateString.split(',')
	 var date=new Date(dateString[2],dateString[0]-1,dateString[1])
	 var validDate=(1*dateString[1]==date.getDate() && 1*dateString[0]==(date.getMonth()+1) && 1*dateString[2]==date.getFullYear())
	 if (syntaxCheck && validDate) return true;
	 return false;
}

//call backs
/*
Clear out the post (so data is recollected) and do a call back
*/
CrossBrowserUtility.prototype.doCallBack=function(eventTarget, eventArgument, eventCallback, context, errorCallback, useAsync)
{
    __theFormPostData = '';
    WebForm_InitCallback();
    WebForm_DoCallback(eventTarget, eventArgument, eventCallback, context, errorCallback, useAsync);
}

//dhtml 
/*
Sets the inner text of the dom object to text
*/
CrossBrowserUtility.prototype.setInnerText=function (obj, text)
{
    if(obj.innerText != undefined)
        obj.innerText = text;
    else if(obj.textContent!= undefined)
        obj.textContent = text;
    else
        return false;
    return true;
}
/*
Gets the inner text of the dom object 
*/
CrossBrowserUtility.prototype.getInnerText=function(obj)
{
    if(obj.innerText!= undefined)
        return obj.innerText;
    else if(obj.textContent!= undefined)
        return obj.textContent;
    else if(obj.text!= undefined)
        return obj.text;
    else
        return false;
}
/*
Gets the xml text of the dom object 
*/
CrossBrowserUtility.prototype.getInnerXml=function(node) {
    if(node.xml)
        return node.xml;
    else if (XMLSerializer)
        return new XMLSerializer().serializeToString(node);
    else
        return false;
}
/*
Gets Xml parser
*/
CrossBrowserUtility.prototype.getXmlParser=function()
{
    if (window.ActiveXObject)
        return new ActiveXObject("Microsoft.XMLDOM");
    else if (document.implementation && document.implementation.createDocument)
        return document.implementation.createDocument("","",null);
    else
        return false
}
/*
Loads the strXml into the xmlDoc
*/
CrossBrowserUtility.prototype.loadXml=function (xmlDoc,strXml)
{
    if (window.ActiveXObject)
        xmlDoc.loadXML(strXml);
    else if (typeof DOMParser != undefined)
    {
        var objDOMParser = new DOMParser();
        var objDoc = objDOMParser.parseFromString(strXml, "text/xml");
        while (xmlDoc.hasChildNodes())
            xmlDoc.removeChild(xmlDoc.lastChild); 
        for (var i=0; i < objDoc.childNodes.length; i++) {
          var objImportedNode = xmlDoc.importNode(objDoc.childNodes[i], true);
          xmlDoc.appendChild(objImportedNode);
        } 
    }
    else
        return false;
    return true;
}
/*
Loops up the DOM tree and returns the parent node at the tag name specified.
*/
CrossBrowserUtility.prototype.getParentNode=function(obj,parentNodeTagName)
{
	obj = obj.parentNode;
    while(obj && obj.tagName  != parentNodeTagName.toUpperCase())
    {
        obj=obj.parentNode;
    }
    return obj;
}
/*
Loops up the DOM tree and returns all child controls that match the match function
*/
CrossBrowserUtility.prototype.findMatchingControls = function(control, matchFunction, results)
{
    if(matchFunction(control)) results.push(control);
    for (var index=0;index<control.childNodes.length;index++)
        this.findMatchingControls(control.childNodes[index], matchFunction, results);
}
/*
Gets all elements with the specified class name
*/
CrossBrowserUtility.prototype.getElementsByClassName = function(className, parentElement) {
	var elements = new Array();
  	var children = (parentElement || document.body).getElementsByTagName('*');
	for ( var index = 0; index<children.length ; index++ )
	{
		var elem = children[index];
/**
		if (elem && elem.className == className)
		{
			elements[elements.length] = elem;
		}
**/		
		
		if(elem)
		{
		    var classes = elem.className.split(' ');
		    for(var classIndex = 0; classIndex < classes.length; classIndex++)
		    {
		        if(classes[classIndex].toUpperCase() == className.toUpperCase())
		        {
		            elements[elements.length] = elem;
		            break;
		        }
		    }
		}
		
	}
	return elements;
}
/*
Gets index of the specified element in the array.
*/
CrossBrowserUtility.prototype.getIndex = function(arr,element)
{
    for(var i=0;i<arr.length;i++)
        if(arr[i]==element)
            return i;
    return -1;
}

/*
Toggles the CSS visibility property of an element
Added by JLT, 4/11/07
*/
CrossBrowserUtility.prototype.toggleElementVisibility = function(elementId)
{ 
    var element = document.getElementById(elementId);
    if (element.style.visibility && element.style.visibility == 'hidden') {
        // Safari attaches events to inner text nodes, which can lead to strange behavior
        if (!this.isSafari() || window.event.srcElement.tagName) {
            element.style.visibility = 'visible';
        }
    }
    else {
        element.style.visibility = 'hidden';
    }
}

CrossBrowserUtility.prototype.toggleElementDisplay = function(elementId)
{
    var element = $get(elementId);
    if (Sys.UI.DomElement.getVisible(element)) {
        Sys.UI.DomElement.setVisible(element, false);
    }
    else {
        Sys.UI.DomElement.setVisible(element, true);
    }
}

/*
Toggles the CSS display property of an element, as well as an expand/collapse icon
*/
CrossBrowserUtility.prototype.toggleDisplayAndGraphic = function(controlId, iconId, classDisplay, classNone) 
{

	var taskPanel = document.getElementById(controlId);
	var icon = document.getElementById(iconId);
	

    if (Sys.UI.DomElement.getVisible(taskPanel)) {
        Sys.UI.DomElement.setVisible(taskPanel, false);
        Sys.UI.DomElement.removeCssClass(icon, "collapse-icon");
        Sys.UI.DomElement.addCssClass(icon, "expand-icon");
    }
    else {
        Sys.UI.DomElement.setVisible(taskPanel, true);
        Sys.UI.DomElement.removeCssClass(icon, "expand-icon");
        Sys.UI.DomElement.addCssClass(icon, "collapse-icon");
    }

}   

/*    
WebAdvisor Menu Accordian -  Toggles the CSS display property of an element, as well as an expand/collapse icon
*/
CrossBrowserUtility.prototype.multiToggleDisplayAndGraphic = function(controlId, iconId, classDisplay, classNone) 
{

	var taskPanel = document.getElementById(controlId);
	var icon = document.getElementById(iconId);
	
	var children = taskPanel.getElementsByTagName('div');

    if (Sys.UI.DomElement.getVisible(children[0])) {
		
		for ( var index = 0; index<children.length ; index++ )
		{
			var elem = children[index];
			Sys.UI.DomElement.setVisible(elem, false);
		}
        Sys.UI.DomElement.removeCssClass(icon, "collapse-icon");
        Sys.UI.DomElement.addCssClass(icon, "expand-icon");
    }
    else {
		for ( var index = 0; index<children.length ; index++ )
		{
			var elem = children[index];
			Sys.UI.DomElement.setVisible(elem, true);
		}

        Sys.UI.DomElement.removeCssClass(icon, "expand-icon");
        Sys.UI.DomElement.addCssClass(icon, "collapse-icon");
    }

}   



CrossBrowserUtility.prototype.itemDisplayAll = function(todoListId, expand, groupClass, iconClass, expandIconClass, collapseIconClass) {
    var newIconClass;
    
    var element = document.getElementById(todoListId);
    
    if(expand) {
        newIconClass = collapseIconClass;
    } else {
        newIconClass = expandIconClass;
    }
    
    var icons = Utility.getElementsByClassName(iconClass, null);
    
    for(var i=0;i<icons.length;i++)
        icons[i].className=newIconClass;
            
    var groups = Utility.getElementsByClassName(groupClass, null);
   
    for(var i=0;i<groups.length;i++) 
    	Sys.UI.DomElement.setVisible(groups[i], expand);            
    
}
/*
Create a utility object that has all the methods to be referenced across  the scripts.
*/
var Utility = new CrossBrowserUtility();
Utility.addEvent(window,'unload',CrossBrowserUtility.prototype.onWindowUnload);


$(document).ready(function(){
    $('a[href*=IsDlg=1]').
        filter(':not(.ms-dialog a)').
        click(function () {
            var options = {
                url: $(this).attr('href'),
                width: $(this).attr('width') ? $(this).attr('width') : 1080,
                height: $(this).attr('height') ? $(this).attr('height') : 768,
                dialogReturnValueCallback: Function.createDelegate(null,CloseCallback)
            };
        SP.UI.ModalDialog.showModalDialog(options);
        return false;
    });
});

$('a[href*=IsDlg=1]').live("click", function() {
   var options = {
                url: $(this).attr('href'),
                width: $(this).attr('width') ? $(this).attr('width') : 1080,
                height: $(this).attr('height') ? $(this).attr('height') : 768,
                dialogReturnValueCallback: Function.createDelegate(null,CloseCallback)
	};
	SP.UI.ModalDialog.showModalDialog(options);
        return false;
});

function CloseCallback(result, value) { 
	if(result === SP.UI.DialogResult.OK) { 
       SP.UI.ModalDialog.RefreshPage(SP.UI.DialogResult.OK)
    } 
 }