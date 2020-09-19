function tryDisableMoodleTestPreventers() {
    let has_protection = M && M.mod_quiz && M.mod_quiz.secure_window;
    if (!has_protection) return false;

    M.mod_quiz.secure_window.is_content_editable = (n) => true;
    let events = ['contextmenu','mousedown','mouseup','dragstart',
    'selectstart','cut','copy','paste'];
    for (ev of events) {
        Y.one(document).detach(ev);
    }
    return true;
}

var mtdpTimer = setInterval(function() {
    console.log('try to disable');
    if (tryDisableMoodleTestPreventers()) {
        clearInterval(mtdpTimer);
        console.log('disabled');
    }
}, 500);