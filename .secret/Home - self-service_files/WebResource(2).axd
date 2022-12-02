/// <reference name="MicrosoftAjax.js" />
Type.registerNamespace('Datatel');

Datatel.WebPart = function(element) {
    Datatel.WebPart.initializeBase(this, [element]);
    this._jQueryElement = null;
    this._ajaxProperties = null;
    this._contentPanel = null;
    this._errorPanel = null;
    this._refreshLink = null;
    this._loadingMarkup = null;
    this._refreshOnLoad = false;
    this._serviceLocation = null;
    this._helpID = null;
}

Datatel.WebPart.prototype = {

    initialize: function() {
        Datatel.WebPart.callBaseMethod(this, 'initialize');
        this._contentPanel = $get(this.get_id() + "_Content", this.get_element());
        this._errorPanel = $get(this.get_id() + "_Errors", this.get_element());
        this._refreshLink = $get(this.get_id() + "_RefreshLink", this.get_element());

        if (this._refreshOnLoad && this._contentPanel != null) {
            this.refresh();
        }
    },

    dispose: function() {
        this._jQueryElement = null;
        this._ajaxProperties = null;
        this._contentPanel = null;
        this._errorPanel = null;
        this._refreshLink = null;
        this._loadingMarkup = null;
        this._refreshOnLoad = null;
        this._serviceLocation = null;
        this._helpID = null;
    },

    get_ajaxProperties: function() {
        /// <value type="Array" mayBeNull="false" locid="P:J#Datatel.WebPart.ajaxProperties"></value>
        if (arguments.length !== 0) throw Error.parameterCount();
        return this._ajaxProperties;
    },

    set_ajaxProperties: function(value) {
        var e = Function._validateParams(arguments, [{ name: "value", type: String, mayBeNull: false}]);
        if (e) throw e;
        var jQueryElement = $(this.get_element());
        this._ajaxProperties = Sys.Serialization.JavaScriptSerializer.deserialize(value, true);
        for (var i = 0; i < this._ajaxProperties.length; i++) {
            if (this._ajaxProperties[i].type == "Date") {
                jQueryElement.data(this._ajaxProperties[i].name, Sys.Serialization.JavaScriptSerializer.deserialize(this._ajaxProperties[i].value));
            }
            else {
                jQueryElement.data(this._ajaxProperties[i].name, this._ajaxProperties[i].value);
            }
        }
    },

    get_serviceLocation: function() {
        /// <value type="String" mayBeNull="false" locid="P:J#Datatel.WebPart.serviceLocation"></value>
        if (arguments.length !== 0) throw Error.parameterCount();
        if (this._serviceLocation == null) return "";
        return this._serviceLocation;
    },

    set_serviceLocation: function(value) {
        var e = Function._validateParams(arguments, [{ name: "value", type: String, mayBeNull: false}]);
        if (e) throw e;
        this._serviceLocation = value;
    },

    get_loadingMarkup: function() {
        /// <value type="String" mayBeNull="true" locid="P:J#Datatel.WebPart.loadingMarkup"></value>
        if (arguments.length !== 0) throw Error.parameterCount();
        if (this._loadingMarkup == null) return "";
        return this._loadingMarkup;
    },

    set_loadingMarkup: function(value) {
        var e = Function._validateParams(arguments, [{ name: "value", type: String, mayBeNull: true}]);
        if (e) throw e;
        this._loadingMarkup = value;
    },

    get_helpID: function() {
        /// <value type="String" mayBeNull="true" locid="P:J#Datatel.WebPart.helpID"></value>
        if (arguments.length !== 0) throw Error.parameterCount();
        if (this._helpID == null) return "";
        return this._helpID;
    },

    set_helpID: function(value) {
        var e = Function._validateParams(arguments, [{ name: "value", type: String, mayBeNull: true}]);
        if (e) throw e;
        this._helpID = value;
    },

    get_refreshOnLoad: function() {
        /// <value type="Bool" mayBeNull="false" locid="P:J#Datatel.WebPart.refreshOnLoad"></value>
        if (arguments.length !== 0) throw Error.parameterCount();
        if (this._refreshOnLoad == null) return "";
        return this._refreshOnLoad;
    },

    set_refreshOnLoad: function(value) {
        var e = Function._validateParams(arguments, [{ name: "value", type: Boolean, mayBeNull: false}]);
        if (e) throw e;
        this._refreshOnLoad = value;
    },

    addError: function(errorMessage) {
        var e = Function._validateParams(arguments, [{ name: "errorMessage", type: String, mayBeNull: false}]);
        if (e) throw e;

        this._errorPanel.innerHTML += "<div class='dt-error'>" + errorMessage + "</div>";
        Sys.UI.DomElement.setVisible(this._errorPanel, true);
    },

    enableThrobber: function() {
        if (this._refreshLink != null) {
            Sys.UI.DomElement.toggleCssClass(this._refreshLink, "dt-throbber");
        }
        if (this._loadingMarkup != null) {
            this._contentPanel.innerHTML = this._loadingMarkup;
        }
        if (this._errorPanel != null) {
            this._errorPanel.innerHTML = "";
            Sys.UI.DomElement.setVisible(this._errorPanel, false);
        }
    },

    disableThrobber: function() {
        if (this._refreshLink != null) {
            Sys.UI.DomElement.toggleCssClass(this._refreshLink, "dt-throbber");
        }
        this._contentPanel.innerHTML = "";
    },

    getPostData: function() {
        var data = "{";
        var jQueryElement = $(this.get_element());
        for (var i = 0; i < this._ajaxProperties.length; i++) {
            data += this._ajaxProperties[i].name + ": "
            if (this._ajaxProperties[i].type == "String") {
                data += "'" + jQueryElement.data(this._ajaxProperties[i].name) + "'";
            } else if (this._ajaxProperties[i].type == "Date") {
                data += Sys.Serialization.JavaScriptSerializer.serialize(jQueryElement.data(this._ajaxProperties[i].name));
            }
            else {
                data += jQueryElement.data(this._ajaxProperties[i].name);
            }
            if (i < this._ajaxProperties.length - 1) {
                data += ", ";
            }
        }
        data += "}";
        return data;
    },

    refresh: function() {
        this.enableThrobber();
        var data = this.getPostData();
        var scripttimeout = this.getTimeOut();
        this.sendRequest("Refresh", data, scripttimeout, this.onSuccess, this.onFailure);
    },

    getTimeOut: function() {
        var timeoutVal;
        var jQueryElement1 = $(this.get_element());
        for (var i = 0; i < this._ajaxProperties.length; i++) {
            if (this._ajaxProperties[i].name == "scripttimeout") {
                timeoutVal = jQueryElement1.data(this._ajaxProperties[i].name);
                timeoutVal = timeoutVal * 1000;
            }
        }
        return timeoutVal;
    },

    openHelp: function() {
        $.ajax({
            type: "POST",
            url: Sys.Net.WebRequest._createUrl("/_layouts/Datatel/WebServices/DatatelWebPart.asmx/OpenHelp"),
            data: "{'helpID': '" + this.get_helpID() + "'}",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            timeout: 60000,
            success: this.onHelpSuccess,
            error: this.onHelpFailure,
            control: this
        });
    },

    sendRequest: function(methodName, data, timeout, successFunction, errorFunction) {
        $.ajax({
            type: "POST",
            url: Sys.Net.WebRequest._createUrl(this.get_serviceLocation() + "/" + encodeURIComponent(methodName)),
            data: data,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            timeout: timeout,
            success: successFunction,
            error: errorFunction,
            control: this
        });
    },

    onHelpSuccess: function(data, status) {
        window.open(data.d, "HelpWindow", "location=1,status=1,scrollbars=1");
    },

    onHelpFailure: function(request, status, errorThrown) {
        alert("Unable to open web part help");
    },

    onSuccess: function(data, status) {
        var control = this;
        if (!this._contentPanel) {
            control = this.control;
        }
        control.disableThrobber();
        control._contentPanel.innerHTML = data.d.Content;
        for (var i = 0; i < data.d.Errors.length; i++) {
            control.addError(data.d.Errors[i]);
        }
    },

    onFailure: function(request, status, errorThrown) {
        this.control.disableThrobber();
        if (!errorThrown) {
            if (status == "parsererror" && (request.responseText.indexOf("CookieAuth.dll?Logon") != -1 ||
                                            request.responseText.indexOf("Logon.aspx") != -1)) {
                this.control.addError("Your session has timed out.  Please refresh the page.");
                window.location.reload();
            } else {
                this.control.addError("The web part is unavailable (" + status + ").");
            }
        }
        else this.control.addError(errorThrown);
    }
}

Datatel.WebPart.registerClass('Datatel.WebPart', Sys.UI.Control);

if (typeof (Sys) !== 'undefined') Sys.Application.notifyScriptLoaded();