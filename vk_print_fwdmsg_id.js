function xForwardedMessagesShowConversationId() {
    const msgs = document.getElementsByClassName('im-mess');
    for (let i = 0; i < msgs.length; i++) {
        const msg = msgs[i];
        if (!msg.hasAttribute('data-x-id_checked')) {
            const msgid = msg.getAttribute('data-msgid');
            const m = msgid.match(/_(\d+)_/);
            if (m) {
                convId = m[1];
                const textBlock = msg.getElementsByClassName('im-mess--text')[0];
                const html = '<span style="color:var(--blue_400)"> ' + convId + '</span>';
                textBlock.insertAdjacentHTML('beforeend', html);
            }
            msg.setAttribute('data-x-id_checked', '1');
        }
    }
}

xForwardedMessagesShowConversationId();