dojo.provide('de.olafklischat.ConfirmDialog');

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
    },

    buildRendering: function() {
        var self = this;
        self.inherited(arguments);
        self._btnPane = dojo.query('.appDialogPaneButtons', self.domNode)[0]
    },

    recreateButtons: function(buttons) {
        var self = this;
        self._btnPane.innerHTML = '';
        //TODO: _Closed?
        var buttons2 = dojo.mixin({_Cancel:self.onCancel, _OK: self.onExecute}, buttons);
        for (var key in buttons2) {
            if (!buttons2.hasOwnProperty(key) || key[0]==='_') {
                continue;
            }
            var value = buttons2[key];
            while (typeof(value) !== "function") {
                if (!buttons2.hasOwnProperty(value)) {
                    throw "buttons map contains undefined reference: " + value;
                }
                value = buttons2[value];
            }
            var button = new dijit.form.Button({label:key})
            dojo.place(button.domNode, self._btnPane);
            (function(_value){
                dojo.connect(button, "onClick", self, function() {
                    self.hide();
                    _value.call(self);
                });
            })(value);
        }
    }

});


//TODO avoid polluting the global namespace
confirm = function(msg, buttons) {
    var dialog = new de.olafklischat.ConfirmDialog({message:msg}); //TODO: only have one instance, at least in the DOM
    window.dlg = dialog; //debugging
    dialog.recreateButtons(buttons);
    console.debug('bp1=' + dlg._btnPane);
    dialog.show();
    console.debug('bp2=' + dlg._btnPane);
}
