function mathtest() {
    var res = sum(1, 10000, sqrtx001, 0.001);
    alert("result: " + res);
}

function sqrtx001(x) {
    return Math.sqrt(x)/1000;
}

function sum(x0,x1,f,s) {
    if (!s) { s=1; }
    var res = 0;
    for (var x = x0; x < x1; x += s) {
        res += f(x);
    }
    return res;
}



////////////////////

dojo.require("dojo.data.api.Read");
dojo.require("dojo.data.api.Identity");

initGrid = function() {

    dojo.declare("my.OnTheFlyStore", [dojo.data.api.Read, dojo.data.api.Identity], {

        nItems: 20,

        _getItemNr: function(nr) {
            return {
                value: nr,
                squared: nr*nr,
                asDate: new Date(1000000 * nr)
            };
        },

        isItem: function(x) {
            return x.value === 0 || !!(x.value);
        },

        _checkIsItem: function(x) {
            if (! this.isItem(x)) {
                throw new Error('not an item: ' + x);
            }
        },

        _checkIsString: function(x) {
            if ("string" != typeof(x)) {
                throw new Error('not a string: ' + x);
            }
        },

        getValue: function(item, attribute, defaultValue){
            this._checkIsItem(item);
            this._checkIsString(attribute);
            var res = item[attribute];
            return res === undefined ? defaultValue : res;
        },

        getValues: function(item, attribute){
            // 		no multi-valued attributes
            var value = this.getValue(item, attribute);
            return (value ? [value] : []);
        },

        getAttributes: function(item) {
            this._checkIsItem(item);
            return ["value","squared","asDate"];
        },

        hasAttribute: function(item, attribute) {
            this._checkIsItem(item);
            this._checkIsString(attribute);
            return attribute === "value" || attribute == "squared" || attribute == "asDate";
        },

        containsValue: function(item, attribute, value) {
            return dojo.indexOf(this.getValues(item, attribute), value) >= 0;
        },

        isItemLoaded: function(x) {
            return this.isItem(x);
        },

        loadItem: function(kwa) {
        },

        _fetchItems: function(kwa, callback, errback) {
            var res = [];
            for (var i = 0; i < this.nItems; i++) {
                res.push(this._getItemNr(i));
            }
            callback(res, kwa);
        },

        getFeatures: function(){
            return {
                'dojo.data.api.Read': true,
                'dojo.data.api.Identity': true
            };
        },

        close: function(request) {

        },

        getLabel: function(item) {
            return "Item nr. " + item;
        },

        getLabelAttributes: function(item) {
            return ["value"];
        },

        getIdentity: function(item) {
            this._checkIsItem(item);
            return "" + item.value;
        },

        getIdentityAttributes: function(item) {
            return ["value"];
        },

        fetchItemByIdentity: function(kwa) {
            var itemnr = parseInt(kwa.identity);
            var scope = kwa.scope?keywordArgs.scope:dojo.global;
            if(kwa.onItem){
                kwa.onItem.call(scope, this._getItemNr(itemnr));
            }
        }
    });

    dojo.extend(my.OnTheFlyStore, dojo.data.util.simpleFetch);

    nstore = new my.OnTheFlyStore();

    nlayout = [{
            field: 'value',
            name: 'Item value',
            width: '100px'
        },
        {
            field: 'squared',
            name: 'Item value^2',
            width: '150px'
        },
        {
            field: 'asDate',
            name: 'Item as date',
            width: 'auto'
        }];

    grid = dijit.byId("grid");
    grid.set("query", {Title:'*'});
    grid.set("store", nstore);
    grid.set("clientSort", false);
    grid.set("rowSelector", '50px');
    grid.set("structure", nlayout);

    grid.startup();
};
