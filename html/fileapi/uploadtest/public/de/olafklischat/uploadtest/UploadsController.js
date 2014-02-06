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
        self._panel_names = [];
    },

    startup: function() {
        var self = this;
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
    
    loadUploadData: function(baseUrl) {
        var self = this;
        if (baseUrl) {
            return dojo.xhrGet({url:baseUrl, handleAs:"json"}).then(function(res) {
                console.debug("loadUploadData(" + baseUrl + "): " + dojo.toJson(res));
                self._panel_delete_all();
                self._baseUrl = baseUrl;
                dojo.forEach(res, function(ul) {
                    console.log(ul.file);
                    self._panel_create(ul.file || ul.name, 100);
                });
            });
        } else {
            self._panel_delete_all();
            return {then: function(f) { f(); }};
        }
    },

    _onFilesChosen: function(files) {
        console.log("Files chosen: " + files);
        dojo.forEach(files, function(file) {
            console.log("file: " + file);
        });
    },

    _startUpload: function(file) {
        
    },


    // _panel_* functions: low-level API for handling the file panels (table rows). Keeps panels sorted by name
    // panels should be treated as opaque objects by API users. They can be treated as JS objects though (i.e. values can be stored in them).

    //    store the names in _panel_names array

    _panel_create: function(name, percent) {
        var self = this;
        //TODO: O(n^2). Consider binary search.
        var pos = 0, count = self._panel_names.length;
        while (pos < count) {
            var n = self._panel_names[pos];
            if (n === name) {
                throw "duplicate name: " + name;
            }
            if (n > name) {
                break;
            }
            pos++;
        }
        var id = dijit.registry.getUniqueId("uploads_panel");
        var tr = dojo.create("tr", {id: id}, self._mainTable, pos);
        var td1 = dojo.create("td", {id: id + "_name", innerHTML: dojox.html.entities.encode(name)}, tr);
        var td2 = dojo.create("td", null, tr);
        var td3 = dojo.create("td", {innerHTML: '<button>X</button>'}, tr);
        var pb = new dijit.ProgressBar({id: id + "_progress", style: "width: 300px"});
        pb.placeAt(td2);
        pb.set('value', percent);
        self._panel_names.splice(pos, 0, name);
        return tr;
    },

    _panel_at: function(index) {
        return this._mainTable.children[index];
    },
    
    _panel_delete: function(panel) {
        var self = this;
        var name = self._panel_getname(panel);
        dojo.destroy(panel);
        var i = dojo.indexOf(self._panel_names, name);
        if (i != -1) {
            self._panel_names.splice(i, 1);
        }
    },

    _panel_delete_all: function() {
        dojo.empty(this._mainTable);
        this._panel_names = [];
    },

    _panel_byname: function(name) {
        var self = this;
        var idx = dojo.indexOf(self._panel_names, name);
        if (idx == -1) {
            return null;
        } else {
            return self._panel_at(idx);
        }
    },

    _panel_getname: function(panel) {
        var td = dojo.byId(panel.id + "_name");
        return dojox.html.entities.decode(dojo.attr(td, 'innerHTML'));
    },

    _panel_getstate: function(panel) {
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
