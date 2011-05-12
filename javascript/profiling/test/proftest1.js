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