dojo.provide('de.olafklischat.uploadtest.UploadsController');

dojo.require("dijit._Widget");
dojo.require("dijit._Templated");
dojo.require('dojo.NodeList-manipulate');
dojo.require("dojox.html.entities");
dojo.require("dijit.ProgressBar");
dojo.require("dijit.registry");
dojo.require("dojo.NodeList-traverse");

dojo.declare("de.olafklischat.uploadtest.UploadsController", [dijit._Widget, dijit._Templated], {

    templateString: dojo.cache("de.olafklischat.uploadtest", "UploadsController.html"),

    constructor: function() {
        var self = this;
        self._npanel_names = [];
    },

    startup: function() {
        var self = this;
        dojo.when(dojo.xhrGet({url:"uploads/all_existing", handleAs:"json"}), function(uploads) {
            dojo.forEach(uploads, function (ul) {
                console.log(ul.file);
                self._npanel_create(ul.file || ul.name, 42);
            });
            var p = self._panel_at(1);
            self._panel_setpct(p, 20 + self._panel_getpct(p));
            self._panel_create("foo.hällo.<bar", 23, 2);
            console.log("NAME: " + self._panel_getname(self._panel_at(2)));
        },
        function(error) {
            console.log("ERROR: " + error);
        });
        dojo.connect(self._fileButton, "onclick", self, function() {
            self._fileInput.click();
        });
        dojo.connect(self._fileInput, "onchange", self, function() {
            self._onFilesChosen(self._fileInput.files);
        });

        var droptarget = self._mainTable;
        window.addEventListener("dragenter", function(evt) {
            evt.preventDefault();
            droptarget.setAttribute("dragenter", true);
        }, true);
        window.addEventListener("dragleave", function(evt) {
            droptarget.removeAttribute("dragenter");
        }, true);
        dojo.connect(droptarget, "ondragover", self, function(evt) {
            evt.preventDefault();
        });
        dojo.connect(droptarget, "ondrop", self, function(evt) {
            evt.preventDefault();
            self._onFilesChosen(evt.dataTransfer.files);
        });
    },

    _onFilesChosen: function(files) {
        console.log("Files chosen: " + files);
        dojo.forEach(files, function(file) {
            console.log("file: " + file);
        });
    },


    // _npanel_* function: mid-level API on top of _panel_*; makes panels accessible by name, maintains sorting

    //    store the names in _npanel_names array

    _npanel_create: function(name, percent) {
        var self = this;
        //TODO: O(n^2). Consider binary search.
        var i = 0, count = self._npanel_names.length;
        while (i < count) {
            var n = self._npanel_names[i];
            if (n === name) {
                throw "duplicate name: " + name;
            }
            if (n > name) {
                break;
            }
            i++;
        }
        self._panel_create(name, percent, i);
        self._npanel_names.splice(i, 0, name);
    },

    _panel_byname: function(name) {
        var self = this;
        var idx = dojo.indexOf(self._npanel_names, name);
        if (idx == -1) {
            return null;
        } else {
            return self._panel_at(idx);
        }
    },


    // _panel_* functions: low-level API for handling the file panels (table rows)

    _panel_create: function(name, percent, pos) {
        var self = this;
        var id = dijit.registry.getUniqueId("uploads_panel");
        var tr = dojo.create("tr", {id: id}, self._mainTable, pos);
        var td1 = dojo.create("td", {id: id + "_name", innerHTML: dojox.html.entities.encode(name)}, tr);
        var td2 = dojo.create("td", null, tr);
        var td3 = dojo.create("td", {innerHTML: '<button>X</button>'}, tr);
        var pb = new dijit.ProgressBar({id: id + "_progress", style: "width: 300px"});
        pb.placeAt(td2);
        pb.set('value', percent);
        return tr;
    },

    _panel_at: function(index) {
        return this._mainTable.children[index];
    },

    _panel_getname: function(panel) {
        var td = dojo.byId(panel.id + "_name");
        return dojox.html.entities.decode(dojo.attr(td, 'innerHTML'));
    },

    _panel_getpct: function(panel) {
        var self = this;
        var pb = dijit.byId(panel.id + "_progress");
        return pb.get('value');
    },

    _panel_setpct: function(panel, percent) {
        var self = this;
        var pb = dijit.byId(panel.id + "_progress");
        pb.set('value', percent);
    }

});
