/* "static" class */
Datatel.DrawTabs = function() {}

/* Tab style constants */
var DatatelTabStyleInactive = 0;
var DatatelTabStyleActive = 1;
var DatatelTabStyleHover = 2;

/*
Global function that draws tabs for all non-container parts on the page
*/
Datatel.DrawTabs.onWindowLoad = function()
{
    // var date1 = new Date();
    //get all divs
    var alldivs = document.getElementsByTagName("DIV");
    var allWebParts = new Array();

    for(var index=0;index<alldivs.length;index++)
    {
        var webPartId = alldivs[index].getAttribute("WebPartID");
        if((webPartId) && (webPartId.indexOf("000000") == -1)) // The menu is a webpart with an empty guid, ignore it
        {
            //get all webparts on page
            allWebParts.push(alldivs[index]);
        }
    }

	// Find all web parts not in the container and convert their chrome headings (if present)
	// into rounded tabs
    for(var index1 = 0; index1 < allWebParts.length; index1++)
    {
		var webPartDiv = allWebParts[index1];
		
		//This means the part is already in container, so dont round it
		var isContainerWebPart = (webPartDiv.firstChild && webPartDiv.firstChild.getAttribute && webPartDiv.firstChild.getAttribute("isDatatelContainerPart"));
		
		if(!isContainerWebPart)
		{
			var nonContainerPart = webPartDiv;
			var nonContainerPartTable = Utility.getParentNode(nonContainerPart,"TABLE");
			
			// Find header row for part table
	        	var headers = Utility.getElementsByClassName("ms-WPHeader", nonContainerPartTable); //get all headers
			
			if(headers.length > 0)
			{
				var header = headers[0];

				if (header.cells[0].className == 'ms-wpTdSpace')//in SP2010 a new cell spacer exists
					header.deleteCell( 0);
				
				// Add spacer to occupy the rest of the header
				var spacer = header.insertCell(1);
				
			

				spacer.innerHTML = "&nbsp;";
				// spacer.style.width = nonContainerPartTable.offsetWidth + "px";
				// spacer.width = "100%";
				spacer.style.width = "100%";

				// Make the cell a "tab"
				Datatel.DrawTabs.tabifyCell(header, 0, DatatelTabStyleActive);
			}
		}
    }
    allDivs = null;

    // var date2 = new Date();
    // alert("drawtabs: " + date1 + ":" + date2)
}

/* Hides the web part by hiding the row it is contained within
*/
Datatel.DrawTabs.deleteWebPart = function(webpartID) {
    var oWebPart = document.getElementById(webpartID);
    if (oWebPart) {
        // This means the part is already in container, so dont go any further
        var isContainerWebPart = (oWebPart && oWebPart.getAttribute && oWebPart.getAttribute("isDatatelContainerPart"));
        if (!isContainerWebPart) {
            var nonContainerPart = oWebPart;
            var nonContainerPartTable = Utility.getParentNode(nonContainerPart, "TABLE");
            if (nonContainerPartTable) {
                var nonContainerPartTr = Utility.getParentNode(nonContainerPartTable, "TR");
                if (nonContainerPartTr) {
                    nonContainerPartTr.style.display = "none";
                }
            }
        }
    }
}

Datatel.DrawTabs.tabifyCell = function(headerRow, titleCellIndex, tabStyle)
{
	// Get the cell with the web part title
	var headerCell	 = headerRow.cells[titleCellIndex];
	
	
	// Style web part title as a tab
	var wpTitleHeading = headerCell.firstChild;

	// Clear width attribute on headerif set. SharePoint sets this to the fixed width
	// of the part when the part has an explicit width property (minus space for the drop down menu)
	// However, this blows up fixed width parts in IE if they are made into tabs
	wpTitleHeading.style.width = "";

	wpTitleHeading.className = "ms-WPTitle";

	// Add a relative positioned div to hold the rounded corners
	var cornerHolder = document.createElement("div");
	cornerHolder.className = "dt-containerCornerHolder";
	headerCell.appendChild(cornerHolder);
	wpTitleHeading.parentNode.removeChild(wpTitleHeading);
	cornerHolder.appendChild(wpTitleHeading);

	// Change width attribute so that cell does not span entire part
	headerCell.style.width = "";

	//make left and right rounded corners
	var leftImage = document.createElement("div");
	var rightImage = document.createElement("div");
	leftImage.className = "dt-containerCornerLeft";
	rightImage.className = "dt-containerCornerRight";
	
	cornerHolder.appendChild(leftImage);
	cornerHolder.appendChild(rightImage);

	// Style the tab
	Datatel.DrawTabs.styleCell(headerCell, tabStyle);
}

Datatel.DrawTabs.styleCell = function(tabCell, tabStyle)
{
	var tabStyleName = "";
	switch(tabStyle)
	{
		case DatatelTabStyleInactive:
			tabStyleName = "Inactive";
			break;
		case DatatelTabStyleActive:
			tabStyleName = "Active";
			break;
		case DatatelTabStyleHover:
			tabStyleName = "Hover";
			break;
		default:
			tabStyleName = "Inactive";
			break;
	}
	
	tabCell.className = "dt-containerTab dt-containerTab" + tabStyleName;
	
	// Remove bottom border for the active tab
	tabCell.style.borderBottomWidth = (tabStyle == DatatelTabStyleActive) ? "0px": "1px"; 
}



if(__DrawTabs) // this is the web.config setting
{
	// Draw tabs when page loads
	Utility.addEvent(window,"load",Datatel.DrawTabs.onWindowLoad);
}
