function validate(formData, pageNr) {
    var result = {};
    var height = parseInt(formData["height"]);
    if (isNaN(height)) {
        result["height"] = "invalid height";
    } else if (height > 220) {
        result["height"] = "patient too tall";
    } else if (height < 100) {
        result["height"] = "patient too short";
    }
    println("formData=" + formData);
    println("formData.get('height')=" + formData.get('height'));
    println("formData['height']=" + formData["height"]);
    println("formData.get('height')[0]=" + formData.get('height')[0]);
    //println("formData['height'][0]=" + formData["height"][0]);
    result["sex"] = "" + formData + "--" + formData["height"] + "--" + pageNr;

    return result;
}
