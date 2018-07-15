function p(x) {
    console.log(x);
}


function after(secs, value) {
    return new Promise((resolve, reject) => {
        setTimeout(() => resolve(value), 1000 * secs);
    });
}


after(2, "hello world").then(p);


async function addPromises(p1, p2) {
    x = await p1
    y = await p2
    return x+y
}

addPromises(after(2, 42), after(3, 23)).then(p);

console.log("end of toplevel");
