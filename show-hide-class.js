<script>
function collapse(button_id, className){
    var element = document.getElementById(button_id);
    element.classList.toggle("collapsible-label");
    var elements = document.getElementsByClassName(className)
    for (var i = 0; i < elements.length; i++){
        if(elements[i].style.display == "none") {
            elements[i].style.display = "";
        } else {
            elements[i].style.display = "none";
        }
    }
}
</script>
