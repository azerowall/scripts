var vayr_answers = new Array();
for (var i = 0; i < L.length; i++)
{
	vayr_answers[i] = L[i].slice();
	
	for (var j = 0; j < vayr_answers[i].length; j++)
	{
		if (vayr_answers[i][j] == '')
			vayr_answers[i][j] = ' ';
	}
}

var vayr_str_answers = new Array();
for (var i = 0; i < vayr_answers.length; i++) vayr_str_answers[i] = vayr_answers[i].join('');

function vayr_modal_close()
{
	var vayr_modal = document.getElementById('modal-wnd');
	vayr_modal.parentNode.removeChild(vayr_modal);
}
function vayr_modal_open()
{
	var vayr_modal = document.createElement('div');
	vayr_modal.innerHTML = '<div id="modal-wnd" class="modalDialog" style="position: fixed;top: 0;right: 0;bottom: 0;left: 0;background: rgba(0,0,0,0.8);display: block;pointer-events: auto;"><div style="width: 400px;position: relative;margin: 10% auto;padding: 5px 20px 13px 20px;background: #fff;background: -moz-linear-gradient(#fff, #999);background: -webkit-linear-gradient(#fff, #999);background: -o-linear-gradient(#fff, #999);"><a href="#" title="Закрыть" class="close" onclick="vayr_modal_close()" style="background: #606061;color: #FFFFFF;line-height: 25px;position: absolute;right: -12px;text-align: center;top: -10px;width: 24px;text-decoration: none;font-weight: bold;">X</a><h2>Кроссворд</h2><pre>' + vayr_str_answers.join('\n') + '</pre></div></div>';
	
	document.body.appendChild(vayr_modal);
}

vayr_modal_open();

// Penalties