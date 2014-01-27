dojo.provide('de.olafklischat.uploadtest.UploadsController');


dojo.declare("de.olafklischat.uploadtest.UploadsController", null, {

    constructor: function(containerId) {
        var self = this;
        self._container = dojo.byId(containerId);

        dojo.when(dojo.xhrGet({url:"uploads/all_required", handleAs:"json"}), function(uploads) {
            dojo.forEach(uploads, function (ul) {
                console.log(ul.file);
                dojo.create("div", {innerHTML: ul.file || ul.name}, self._container);
            });
        },
        function(error) {
            self._container.innerHTML = ('ERROR: ' + error);
        });
    }
});
