function p(x) {
    console.log(x);
}


function after(secs, value) {
    return new Promise((resolve, reject) => {
        setTimeout(() => resolve(value), 1000 * secs);
    });
}


after(2, "hello world").then(p);


function addPromises(p1, p2) {
    return new Promise((resolve, reject) => {
        p1.then(x => {
            p2.then(y => {
                resolve(x+y);
            });
        });
    });
}

addPromises(after(2, 42), after(3, 23)).then(p);

console.log("end of toplevel");
