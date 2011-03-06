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
        var dynButtons = [];
        dojo.connect(dijit.byId("createBtnBtn"), "onClick", function() {
                         var btn = new dijit.form.Button({label:"Say Hello"});
                         dojo.place(btn.domNode, dojo.query("h1")[0], "after");
                         dojo.connect(btn, "onClick", function() {
                                          alert("Hello World!");
                                      });
                         dynButtons.push(btn);
                     });
        dojo.connect(dijit.byId("colorBtn"), "onClick", function() {
                         dojo.forEach(dynButtons, function(btn) {
                                          btn.attr("style", "color: green");
                                      });
                     });
    });
