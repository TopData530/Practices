/*  Submits form if the enter button is presses.  
This is assigned to "onkeypress" of all input fields.
*/
function WebAdvisorButtonPress(e) {
    e = (e) ? e : event;
    var charCode = (e.charCode) ? e.charCode : ((e.which) ? e.which : e.keyCode);
    if (charCode == 13 || charCode == 3) {
        webAdvisor.submit();
    }

}
var webAdvisor;

Type.registerNamespace('Datatel.WebAdvisor');

Datatel.WebAdvisor.Client = function Datatel$WebAdvisor$Client(element) {
    Datatel.WebAdvisor.Client.initializeBase(this, [element]);
    this._associatedUpdatePanelId = null;
    this._pdfUrlControlId = null;
    this._pageUrl = null;
    this._ssotoken = null;
    this._enabled = false;
}
function Datatel$WebAdvisor$Client$get_associatedUpdatePanelId() {
    /// <value type="String" mayBeNull="true" locid="P:J#Datatel.WebAdvisor.Client.associatedRefreshLinkId"></value>
    if (arguments.length !== 0) throw Error.parameterCount();
    return this._associatedUpdatePanelId;
}
function Datatel$WebAdvisor$Client$set_associatedUpdatePanelId(value) {
    var e = Function._validateParams(arguments, [{ name: "value", type: String, mayBeNull: true}]);
    if (e) throw e;
    this._associatedUpdatePanelId = value;
}
function Datatel$WebAdvisor$Client$get_pdfUrlControlId() {
    /// <value type="String" mayBeNull="true" locid="P:J#Datatel.WebAdvisor.Client.pdfUrlControlId"></value>
    if (arguments.length !== 0) throw Error.parameterCount();
    return this._pdfUrlControlId;
}
function Datatel$WebAdvisor$Client$set_pdfUrlControlId(value) {
    var e = Function._validateParams(arguments, [{ name: "value", type: String, mayBeNull: true}]);
    if (e) throw e;
    this._pdfUrlControlId = value;
}
function Datatel$WebAdvisor$Client$get_pageUrl() {
    /// <value type="String" mayBeNull="true" locid="P:J#Datatel.WebAdvisor.Client.pageUrl"></value>
    if (arguments.length !== 0) throw Error.parameterCount();
    return this._pageUrl;
}
function Datatel$WebAdvisor$Client$set_pageUrl(value) {
    var e = Function._validateParams(arguments, [{ name: "value", type: String, mayBeNull: true}]);
    if (e) throw e;
    this._pageUrl = value;
}
function Datatel$WebAdvisor$Client$get_ssotoken() {
    /// <value type="String" mayBeNull="true" locid="P:J#Datatel.WebAdvisor.Client.ssotoken"></value>
    if (arguments.length !== 0) throw Error.parameterCount();
    return this._ssotoken;
}
function Datatel$WebAdvisor$Client$set_ssotoken(value) {
    var e = Function._validateParams(arguments, [{ name: "value", type: String, mayBeNull: true}]);
    if (e) throw e;
    this._ssotoken = value;
}
function Datatel$WebAdvisor$Client$get_enabled() {
    /// <value type="Boolean" mayBeNull="false" locid="P:J#Datatel.WebAdvisor.Client.enabled"></value>
    if (arguments.length !== 0) throw Error.parameterCount();
    return this._enabled;
}
function Datatel$WebAdvisor$Client$set_enabled(value) {
    var e = Function._validateParams(arguments, [{ name: "value", type: Boolean, mayBeNull: false}]);
    if (e) throw e;
    this._enabled = value;
}
function Datatel$WebAdvisor$Client$addTab(newTitle) {
    var tabRow = document.getElementById(this._tabRowId);
    var newTabIndex = tabRow.cells.length;

    tabRow.insertCell(newTabIndex);
    tabRow.cells[newTabIndex].innerHTML = "<h3><nobr><span>" + newTitle + "</span></nobr></h3>";
    Datatel.DrawTabs.tabifyCell(tabRow, newTabIndex, DatatelTabStyleInactive);
}
function Datatel$WebAdvisor$Client$unescapeTitle(title) {
    while (title.indexOf("+") != -1) {
        title = title.replace("+", " ");
    }
    return title;
}
function Datatel$WebAdvisor$Client$checkPreviousTabs(newTitle) {
    var tabRow = document.getElementById(this._tabRowId);
    var tabs = tabRow.cells;
    var found = false;

    for (var i = 0; i < tabs.length; i++) {
        tabTitle = tabs[i].getAttribute('name');
        if (tabTitle == newTitle) {
            found = true;
            this.set_enabled(true);
            webAdvisor.openTab(i);
        }
    }
    return found;
}
function Datatel$WebAdvisor$Client$sameTab(title, url) {
    // Load a form in the currently opened tab
    title = this.unescapeTitle(title);
    if (!this.checkPreviousTabs(title)) {
        this.sendCallback('sameTab' + title + '/*-' + url);
    }
}
function Datatel$WebAdvisor$Client$newTab(title, url) {
    var tabRow = document.getElementById(this._tabRowId);
    if (tabRow.cells.length < 6) {
        title = this.unescapeTitle(title);
        if (!this.checkPreviousTabs(title)) {
            this.addTab(title);
            this.sendCallback('newTab' + title + '/*-' + url);
        }
    }
    else {
        this.showError("You cannot open more than 6 tabs at one time.  Please close any you are finished with.");
    }
}
function Datatel$WebAdvisor$Client$newTabLink(title, url) {
    var tabRow = document.getElementById(this._tabRowId);
    if (tabRow.cells.length < 6) {
        title = this.unescapeTitle(title);
        if (!this.checkPreviousTabs(title)) {
            this.addTab(title);
            this.sendCallback('newTabLink' + title + '/*-' + url);
        }
    }
    else {
        this.showError("You cannot open more than 6 tabs at one time.  Please close any you are finished with.");
    }
}
function Datatel$WebAdvisor$Client$newTabProcess(title, pid) {
    var tabRow = document.getElementById(this._tabRowId);
    if (tabRow.cells.length < 6) {
        title = this.unescapeTitle(title);
        if (!this.checkPreviousTabs(title)) {
            this.addTab(title);
            this.sendCallback('newTabProcess' + title + '/*-' + pid);
        }
    }
    else {
        this.showError("You cannot open more than 6 tabs at one time.  Please close any you are finished with.");
    }
}
function Datatel$WebAdvisor$Client$openTab(index) {
    this.sendCallback('openTab' + index);
}
function Datatel$WebAdvisor$Client$closeTab(index) {
    this.sendCallback('closeTab' + index);
}
function Datatel$WebAdvisor$Client$loadFirstTab() {
    this.sendCallback('loadFirstTab');
}
function Datatel$WebAdvisor$Client$postData(data) {
    window.scrollTo(0, 0);
    this.sendCallback('postData' + data);
}
function Datatel$WebAdvisor$Client$back() {
    this.sendCallback('back');
}
function Datatel$WebAdvisor$Client$forward() {
    this.sendCallback('forward');
}
function Datatel$WebAdvisor$Client$openHelp() {
    var helpLink = $get("helpLink").attributes["href"].nodeValue;
    paramStart = helpLink.indexOf("TOKENIDX");
    paramEnd = helpLink.indexOf("&", paramStart);
    helpLink = helpLink.substring(0, paramStart) + helpLink.substring(paramEnd);

    window.open(helpLink + "&SSOTOKEN=" + this.get_ssotoken(), "_help");
}
function Datatel$WebAdvisor$Client$openPdf(pdfLink) {
    this.sendCallback('openPdf' + pdfLink);
}
function Datatel$WebAdvisor$Client$pagingEvent(evt) {
    button = (evt.target) ? evt.target : evt.srcElement;

    if (button.value == "JUMP") {
        var jumpTextName = button.name.replace("ACTION", "JUMP");
        var page = document.getElementsByName(jumpTextName)[0].value;
        if (isNaN(page) || page < 1) {
            alert("Please enter a valid page number");
            return;
        }
    }

    value = button.name + "=" + button.value;
    this.submit(value);
}
function Datatel$WebAdvisor$Client$submit(extraValues) {
    var data = "";
    var form = $get(this._contentId);
    var inputs = form.getElementsByTagName("input");
    for (var i = 0; i < inputs.length; i++) {

        //Don't include button values
        //Javascript is always enabled in the portal
        //For some reason, all checkboxes are getting picked up as checked by default
        if (inputs[i].type != "button" && (inputs[i].type != "radio" || inputs[i].checked) && (inputs[i].type != "checkbox" || inputs[i].checked) && inputs[i].name != "JS_ENABLED")
            data += inputs[i].name + "=" + encodeURIComponent(inputs[i].value) + "&";

        if (inputs[i].name == "JS_ENABLED")
            data += "JS_ENABLED=Y&";
    }

    inputs = form.getElementsByTagName("select");
    for (var i = 0; i < inputs.length; i++) {
        data += inputs[i].name + "=" + encodeURIComponent(inputs[i].options[inputs[i].selectedIndex].value) + "&";
    }

    inputs = form.getElementsByTagName("textarea");
    for (var i = 0; i < inputs.length; i++) {
        data += inputs[i].name + "=" + encodeURIComponent(inputs[i].value) + "&";
    }

    if (extraValues) {
        data += extraValues;
    }
    else {
        data = data.substring(0, data.length - 1);
    }

    webAdvisor.postData(data);
}

function Datatel$WebAdvisor$Client$fixContent() {
    try {
        var cssLink = document.getElementById("waFormStyle");
        var newCssLink = document.getElementById("formCss");
        if (newCssLink) {
            cssLink.href = cssLink.attributes["path"].nodeValue + (newCssLink.attributes["href"].nodeValue.substring(1));
        }
        else {
            try {
                cssLink.href = cssLink.attributes["path"].nodeValue + "emptyCss";
            }
            catch (e) {
                //Safari is dumb and can't handle an empty 'href', so we have to give it a fake path and let it fail
            }
        }

        var helpLink = $get("waHelpLink");
        var newHelpLink;
        try {
            newHelpLink = $get("helpLink");
            helpLink.href = newHelpLink.href;
        }
        catch (e) {
            if (helpLink != null) {
                helpLink.style.display = "none";
            }
        }

        var linksToFix = document.getElementsByName('misctextlink');
        for (var i = 0; i < linksToFix.length; i++) {
            title = linksToFix[i].title;
            if (title == null)
                title = linksToFix[i].innerText;
            if (title == null)
                title = "";

            var newLink = linksToFix[i].href;
            //The link is currently pointing to this portal server, so fix it
            if (linksToFix[i].href.indexOf("WebAdvisor.aspx") != -1) {
                //This link is just a query string
                newLink = linksToFix[i].href.substring(linksToFix[i].href.indexOf("?"));
                linksToFix[i].href = "javascript:webAdvisor.sameTab(\"" + linksToFix[i].title + "\",\"" + newLink + "\");";
                linksToFix[i].target = "";
            }
            else {
                //This link is a path, so remove the portal piece of the URL
                newLink = cssLink.attributes["path"].nodeValue + linksToFix[i].href.substring(webAdvisor.get_pageUrl().length);
                linksToFix[i].href = newLink;
                linksToFix[i].target = "_help";
            }

        }

        var custom = $get('customStuff_BODY');
        if (custom) {

            linksToFix = custom.getElementsByTagName('A');
            for (var i = 0; i < linksToFix.length; i++) {
                if (linksToFix[i].attributes["name"] &&
                linksToFix[i].attributes["name"].nodeValue != "misctextlink" &&
                linksToFix[i].attributes["onclick"] &&
                linksToFix[i].attributes["onclick"].nodeValue &&
                linksToFix[i].attributes["onclick"].nodeValue.indexOf("./html/") != -1 &&
                linksToFix[i].attributes["href"] &&
                linksToFix[i].attributes["href"].nodeValue &&
                linksToFix[i].attributes["href"].nodeValue.indexOf("javascript") != -1) {

                    title = linksToFix[i].title;
                    if (title == null)
                        title = linksToFix[i].innerText;
                    if (title == null)
                        title = "";

                    var newLink = linksToFix[i].href;
                    //The link is currently pointing to this portal server, so fix it
                    if (linksToFix[i].href.indexOf("WebAdvisor.aspx") != -1) {
                        //This link is just a query string
                        newLink = linksToFix[i].href.substring(linksToFix[i].href.indexOf("?"));
                        linksToFix[i].href = "javascript:webAdvisor.sameTab(\"" + linksToFix[i].title + "\",\"" + newLink + "\");";
                        linksToFix[i].target = "";
                    }
                    else {
                        //This link is a path, so remove the portal piece of the URL
                        newLink = cssLink.attributes["path"].nodeValue + linksToFix[i].href.substring(webAdvisor.get_pageUrl().length);
                        linksToFix[i].href = newLink;
                        linksToFix[i].target = "_help";
                    }
                }

            }
        }

        linksToFix = document.getElementsByName('misctextimage');
        for (var i = 0; i < linksToFix.length; i++) {
            linksToFix[i].src = cssLink.attributes["path"].nodeValue + linksToFix[i].src.substring(webAdvisor.get_pageUrl().length);
        }
    }
    catch (e) { }

    var tabs = $get("webAdvisorTabs");
    if (tabs.cells.length > 0) {
        var mainRow = $get("webAdvisorMainRow");
        mainRow.className = "visible";

        //Round the corners of each tab
        for (var i = 0; i < tabs.cells.length; i++) {
            var tabStyle = (tabs.cells[i].getAttribute("id") == "openTab") ? DatatelTabStyleActive : DatatelTabStyleInactive;
            Datatel.DrawTabs.tabifyCell(tabs, i, tabStyle);
        }
    }

}
function Datatel$WebAdvisor$Client$sendCallback(data) {
    if (this.get_enabled()) {
        this.showLoadingUI();
        __doPostBack(this.get_associatedUpdatePanelId(), data);
    }
    else {
        this.showError("The web part is loading content.  Please wait...");
    }
}
function Datatel$WebAdvisor$Client$showLoadingUI() {
    var element = document.getElementById(this._contentId);
    element.innerHTML = this._loadingMarkup;

    // If loadFirstTab has been called, these two elements will not exist yet
    try {
        var mainRow = document.getElementById(this._mainRowId);
        mainRow.className = "";
    }
    catch (e) { }

    try {
        var toolbarRow = document.getElementById(this._toolbarId);
        toolbarRow.style.display = "none";
    }
    catch (e) { }

    this.set_enabled(false);
}
function Datatel$WebAdvisor$Client$onPdfUrlReceived(sender, args) {
    if (args._dataItems) {
        var url = args._dataItems[webAdvisor._pdfUrlControlId];
        if (url != null && url != undefined) {
            var reportWin = window.open("WebAdvisorReport.aspx?" + url, "_report");
        }
    }
}
function Datatel$WebAdvisor$Client$checkForSessionExpiration(sender, args) {
    if (sender._xmlHttpRequest.responseText.indexOf("CookieAuth.dll?Logon") != -1 || sender._xmlHttpRequest.responseText.indexOf("Logon.aspx") != -1) {
        var element = document.getElementById(webAdvisor._contentId);
        element.innerHTML = "Your session has timed out.  Please refresh the page.";
        window.location.reload();
    }
}
function Datatel$WebAdvisor$Client$checkForResponseError(sender, args) {
    if (args.get_error() != undefined) {
        var errorMessage;
        if (args.get_response().get_statusCode() == '200') {
            errorMessage = args.get_error().message;
        }
        else {
            errorMessage = "An error occurred.  Please close your browser window and try again.";
        }
        args.set_errorHandled(true);
        $get(webAdvisor._contentId).innerHTML = errorMessage;
    }
}
function Datatel$WebAdvisor$Client$tabMouseOver(tabId) {
    var tab = $get(tabId);
    Datatel.DrawTabs.styleCell(tab, DatatelTabStyleHover);
}

function Datatel$WebAdvisor$Client$tabMouseOut(tabId) {
    var tab = $get(tabId);
    Datatel.DrawTabs.styleCell(tab, DatatelTabStyleInactive);
}
function Datatel$WebAdvisor$Client$showError(error) {
    alert(error);
}
function Datatel$WebAdvisor$Client$initialize() {
    this._enabled = true;
    this._contentId = "webAdvisorContent";
    this._mainRowId = "webAdvisorMainRow";
    this._tabRowId = "webAdvisorTabs";
    this._toolbarId = "webAdvisorToolBar";
    this._loadingMarkup = "<div class='webadvisorthrobber'>&nbsp;</div>";

    Sys.WebForms.PageRequestManager.getInstance().add_pageLoading(this.onPdfUrlReceived)
    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(this.checkForResponseError);
    Sys.Net.WebRequestManager.add_completedRequest(this.checkForSessionExpiration)

    webAdvisor = this;
    this.loadFirstTab();
}
Datatel.WebAdvisor.Client.prototype = {
    get_associatedUpdatePanelId: Datatel$WebAdvisor$Client$get_associatedUpdatePanelId,
    set_associatedUpdatePanelId: Datatel$WebAdvisor$Client$set_associatedUpdatePanelId,
    get_pdfUrlControlId: Datatel$WebAdvisor$Client$get_pdfUrlControlId,
    set_pdfUrlControlId: Datatel$WebAdvisor$Client$set_pdfUrlControlId,
    get_enabled: Datatel$WebAdvisor$Client$get_enabled,
    set_enabled: Datatel$WebAdvisor$Client$set_enabled,
    get_pageUrl: Datatel$WebAdvisor$Client$get_pageUrl,
    set_pageUrl: Datatel$WebAdvisor$Client$set_pageUrl,
    get_ssotoken: Datatel$WebAdvisor$Client$get_ssotoken,
    set_ssotoken: Datatel$WebAdvisor$Client$set_ssotoken,
    addTab: Datatel$WebAdvisor$Client$addTab,
    unescapeTitle: Datatel$WebAdvisor$Client$unescapeTitle,
    checkPreviousTabs: Datatel$WebAdvisor$Client$checkPreviousTabs,
    sameTab: Datatel$WebAdvisor$Client$sameTab,
    newTab: Datatel$WebAdvisor$Client$newTab,
    newTabLink: Datatel$WebAdvisor$Client$newTabLink,
    newTabProcess: Datatel$WebAdvisor$Client$newTabProcess,
    openTab: Datatel$WebAdvisor$Client$openTab,
    closeTab: Datatel$WebAdvisor$Client$closeTab,
    loadFirstTab: Datatel$WebAdvisor$Client$loadFirstTab,
    postData: Datatel$WebAdvisor$Client$postData,
    back: Datatel$WebAdvisor$Client$back,
    forward: Datatel$WebAdvisor$Client$forward,
    openHelp: Datatel$WebAdvisor$Client$openHelp,
    openPdf: Datatel$WebAdvisor$Client$openPdf,
    pagingEvent: Datatel$WebAdvisor$Client$pagingEvent,
    submit: Datatel$WebAdvisor$Client$submit,
    fixContent: Datatel$WebAdvisor$Client$fixContent,
    sendCallback: Datatel$WebAdvisor$Client$sendCallback,
    showLoadingUI: Datatel$WebAdvisor$Client$showLoadingUI,
    onPdfUrlReceived: Datatel$WebAdvisor$Client$onPdfUrlReceived,
    checkForSessionExpiration: Datatel$WebAdvisor$Client$checkForSessionExpiration,
    checkForResponseError: Datatel$WebAdvisor$Client$checkForResponseError,
    tabMouseOver: Datatel$WebAdvisor$Client$tabMouseOver,
    tabMouseOut: Datatel$WebAdvisor$Client$tabMouseOut,
    showError: Datatel$WebAdvisor$Client$showError,
    initialize: Datatel$WebAdvisor$Client$initialize
}

Datatel.WebAdvisor.Client.registerClass('Datatel.WebAdvisor.Client', Datatel.WebPart);

Datatel.WebPart.WebAdvisorMenu = function (element) {
    Datatel.WebPart.WebAdvisorMenu.initializeBase(this, [element]);
    this._initialLoad = true;

    var controls = $(element).find('.wa-dt-rowhead');

    if (controls.length == 1) {
        $(controls[0]).children('div').slideDown();
        var icon = $(controls[0]).children('a').find('.expand-icon');
        icon.removeClass('expand-icon');
        icon.addClass('collapse-icon');
    }
}

Datatel.WebPart.WebAdvisorMenu.prototype = {

    set_menuId: function (menuId) {
        $(this.get_element()).data("menuId", menuId);
    },

    set_flushCache: function (flushCache) {
        $(this.get_element()).data("flushCache", flushCache);
    },

    ensureToggleIcons: function () {
        var subMenus = $(this.get_element()).find('.wa-dt-rowtitle').filter(':visible');
        subMenus.each(function (index, elem) {
            var links = $(elem).children('.dt-row');
            if (links.length == 0 || links.is(':hidden')) {
                var icon = $(elem).find('.collapse-icon');
                icon.removeClass('collapse-icon');
                icon.addClass('expand-icon');
            } else {
                var icon = $(elem).find('.expand-icon');
                icon.removeClass('expand-icon');
                icon.addClass('collapse-icon');
            }
        });
    },

    toggleTopMenu: function (controlId, iconId) {
        var subMenus = $('#' + controlId + ' > div');
        var wamenu = $(this.get_element());
        var topMenus = wamenu.find('.wa-dt-rowhead');

        if (!subMenus.is(':hidden')) {
            subMenus.slideUp('fast');
            $('#' + iconId).removeClass('collapse-icon');
            $('#' + iconId).addClass('expand-icon');
        } else {
            wamenu.find('.wa-dt-rowtitle-initial').slideUp('fast');
            wamenu.find('.wa-dt-rowtitle').slideUp('fast');
            wamenu.find('.wa-dt-rowtitle > div').slideUp('fast');

            var toToggle = topMenus.not('#' + controlId).find('.collapse-icon');
            toToggle.removeClass('collapse-icon');
            toToggle.addClass('expand-icon');

            subMenus.slideDown('fast');
            $('#' + iconId).removeClass('expand-icon');
            $('#' + iconId).addClass('collapse-icon');

            this.ensureToggleIcons();
        }
    },

    getMenu: function (menuId) {
        // If menu already has stuff under it, then all we want to do is
        // collapse, not send a request to the server.
        var menuClicked = $('#wa-dt-rowtitle' + menuId);
        var iconSpan = $('#_menuExpand_' + menuId);
        var linksUnderClicked = menuClicked.children('.dt-row');
        if (linksUnderClicked.is(':not(:hidden)')) {
            linksUnderClicked.slideUp('fast');
            iconSpan.removeClass('collapse-icon');
            iconSpan.addClass('expand-icon');
        } else if (linksUnderClicked.is(':hidden')) {
            // If the menu was collapsed, but items are still there, show them
            linksUnderClicked.slideDown('fast');
            iconSpan.removeClass('expand-icon');
            iconSpan.addClass('collapse-icon');
        } else {
            // If the menu has no items under it and was clicked on, then go back to the server
            // and get the menu items
            this.set_menuId(menuId);
            this.ensureToggleIcons();
            this.refresh(true);
        }
    },

    onAccordianSuccess: function (data, status) {
        var control = this;
        if (!this._contentPanel) {
            control = this.control;
        }
        control.disableThrobber();
        control._contentPanel.innerHTML = data.d.Content;
        for (var i = 0; i < data.d.Errors.length; i++) {
            control.addError(data.d.Errors[i]);
        }


        var menuWebpart = $(control.get_element()).closest('.WebAdvisorMenu');
        var selectedMenu = menuWebpart.data('menuId');

        // We want to find all the .dt-row divs underneath a wa-dt-rowtitle and make them hidden, unless it was
        // the "wa-dt-rowtitle" + selectedMenu is the ID of the submenu that was expanded

        var controls = Utility.getElementsByClassName('wa-dt-rowhead', null);
        var topMenus = $(control.get_element()).find('.wa-dt-rowhead');

        if (topMenus.length > 1) {
            topMenus.each(function (index, domElem) {
                var submenus = $(domElem).children('.wa-dt-rowtitle');
                var links = $(domElem).find('.dt-row');
                if (links.length == 0 || links.length == links.filter(':hidden').length) {
                    submenus.hide();
                } else {
                    links.show();
                }
            });
        } else {
            var icon = $(topMenus[0]).children('a').find('.expand-icon');
            icon.removeClass('expand-icon');
            icon.addClass('collapse-icon');
        }
    },
    refresh: function (avoidFlush) {
        if (this._initialLoad || avoidFlush) {
            this.set_flushCache(false);
        }
        this.enableThrobber();
        var data = this.getPostData();
        var scripttimeout = this.getTimeOut();
        this._initialLoad = false;
        this.set_flushCache(true);
        this.sendRequest("Refresh", data, scripttimeout, this.onAccordianSuccess, this.onFailure);

    }
}

Datatel.WebPart.WebAdvisorMenu.registerClass('Datatel.WebPart.WebAdvisorMenu', Datatel.WebPart);
if (typeof (Sys) !== 'undefined') Sys.Application.notifyScriptLoaded();
