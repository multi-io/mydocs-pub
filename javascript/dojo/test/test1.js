dojo.provide("test1");

dojo.require("dijit.form.Button");
dojo.require("dijit.Dialog");

dojo.addOnLoad(
    function(){
        dojo.query("a").forEach(function(n){
                                    n.innerHTML += "Tralala";
                                });
        var dlg = dijit.byId("mydialog");
        dojo.connect(dijit.byId("showDlgBtn"), "onClick", function() {
                     dlg.show();
                     });
    });
