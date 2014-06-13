dojo.require('dijit.Dialog');
dojo.require("dijit.form.Button");
dojo.require("dijit._Templated");

dojo.declare('de.olafklischat.ConfirmDialog', [dijit.Dialog, dijit._Templated], {

		title: 'Confirm',
        templateString: dojo.cache("de.olafklischat", "ConfirmDialog.html"),
        widgetsInTemplate: true,

		constructor: function(options){
			if (options.message) {
				this.content = options.message;
			}
		}

});
