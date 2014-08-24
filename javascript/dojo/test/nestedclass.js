console.log("hello");

dojo.declare("foo.Bar", null, {

    constructor: function(factor) {
        var self = this;
        self._factor = factor;
        self._nesteds = [];
        for (var i = 1; i <= 10; i++) {
            self._nesteds.push(new self._Nested(self, i));
        }
    },

    getMultiple: function(x) {
        return x * this._factor;
    },

    _Nested: dojo.declare(null, {
        constructor: function(outerSelf, factor) {
            this._outerSelf = outerSelf;
            this._factor = factor;
        },

        getInnerMultiple: function(x) {
            return x * this._outerSelf.getMultiple(this._factor);
        }
    }),

    printNestedMultiples: function() {
        var self = this;
        dojo.forEach(self._nesteds, function(nested) {
            console.log(nested.getInnerMultiple(42));
        });
    }

});


bar = new foo.Bar(2);
console.log(bar.getMultiple(42));
bar.printNestedMultiples();