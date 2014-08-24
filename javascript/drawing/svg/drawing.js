var svgRoot, mainCanvas;

//Methode zu Event hinzufuegen die clientX/Y als SVGPoint zurueckgibt
Event.prototype.getClientCoords = function() {
    var result = svgRoot.createSVGPoint();
    result.x = this.clientX;
    result.y = this.clientY;
    return result;
}


function onLoad(){
    svgRoot = document.getElementById('svgRoot');

    mainCanvas = document.getElementById('mainCanvas');

    mainCanvas.onmousedown = drawStart;
    mainCanvas.onmousemove = drawVertice;
    mainCanvas.onmouseup = drawEnd;
}

var screenToCanvasTM
var currPath

function drawStart(evt) {
    //TM nur einmal am Anfang jedes Pfads berechnen (Performance)
    screenToCanvasTM = mainCanvas.getScreenCTM().inverse();

    var canvasCoords = evt.getClientCoords().matrixTransform(screenToCanvasTM);
    currPath = document.createElementNS("http://www.w3.org/2000/svg","path");
    currPath.setAttribute("d", "M "+canvasCoords.x+" "+canvasCoords.y);;
    currPath.setAttribute("stroke","black");;
    currPath.setAttribute("fill","none");;
    mainCanvas.appendChild(currPath);
}

function drawVertice(evt) {
    if (currPath) {
        var canvasCoords = evt.getClientCoords().matrixTransform(screenToCanvasTM);
        currPath.setAttribute("d", currPath.getAttribute("d")
                              + " L "+canvasCoords.x+" "+canvasCoords.y);
    }
}

function drawEnd(evt) {
    var canvasCoords = evt.getClientCoords().matrixTransform(screenToCanvasTM);
    currPath.setAttribute("d", currPath.getAttribute("d")
                          + " L "+canvasCoords.x+" "+canvasCoords.y+" z");
    currPath = null;
}
