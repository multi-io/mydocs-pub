dojo.require('dijit.Dialog');
dojo.require("dijit.form.Button");
dojo.require("dijit._Templated");

dojo.declare('de.olafklischat.ConfirmDialog', [dijit.Dialog, dijit._Templated], {

    title: 'Confirm',
    templateString: dojo.cache("de.olafklischat", "ConfirmDialog.html"),
    widgetsInTemplate: true,

    constructor: function(options){
        var self = this;
        self.content = options.message;
    }

});


//TODO avoid polluting the global namespace
confirm = function(msg, buttons) {
    var dialog = new de.olafklischat.ConfirmDialog({message:msg}); //TODO: only have one instance, at least in the DOM
    window.dlg = dialog; //debugging
    dialog.show();
}
