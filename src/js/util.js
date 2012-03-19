.pragma library

function openPage(stack, page, popBefore) {
    if (popBefore)
        stack.pop();

    var component = Qt.createComponent("../qml/" + page + ".qml")
    stack.push(component);
}
