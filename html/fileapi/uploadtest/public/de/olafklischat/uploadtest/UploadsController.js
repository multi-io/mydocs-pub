dojo.provide('de.olafklischat.uploadtest.UploadsController');

dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require('dojo.NodeList-manipulate');
dojo.require("dojox.html.entities");
dojo.require("dijit.ProgressBar");

dojo.declare("de.olafklischat.uploadtest.UploadsController", [dijit._Widget, dijit._Templated], {

    templateString: '<div style="overflow:scroll"><table dojoAttachPoint="_mainTable"></table></div>',

    constructor: function() {
        var self = this;
        dojo.when(dojo.xhrGet({url:"uploads/all_existing", handleAs:"json"}), function(uploads) {
            dojo.forEach(uploads, function (ul) {
                console.log(ul.file);
                var tr = dojo.create("tr", null, self._mainTable);
                var td1 = dojo.create("td", {innerHTML: dojox.html.entities.encode(ul.file || ul.name)}, tr);
                var td2 = dojo.create("td", null, tr);
                var td3 = dojo.create("td", {innerHTML: '<button>X</button>'}, tr);
                var pb = new dijit.ProgressBar({style: "width: 300px"});
                pb.placeAt(td2);
                pb.set('value', 42);
            });
        },
        function(error) {
            console.log("ERROR: " + error);
        });
    }
});
