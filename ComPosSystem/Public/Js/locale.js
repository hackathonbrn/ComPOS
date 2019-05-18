var locale = "rus";

$(document).ready(function() {
    if (locale === "rus") {
        document.getElementById("areaChart").innerText = "График хуяфик"
    }
    else {
        document.getElementById("areaChart").innerText = "Area Chart"
    }
});

$("#localeRu").click(function() {
    locale = "rus";
    this.classList.add("active");
    document.getElementById("localeEng").classList.remove("active");
    document.getElementById("areaChart").innerText = "График хуяфик"
});

$("#localeEng").click(function() {
    locale = "eng";
    this.classList.add("active");
    document.getElementById("localeRu").classList.remove("active");
    document.getElementById("areaChart").innerText = "Area Chart"
});