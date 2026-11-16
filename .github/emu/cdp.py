import json, sys, urllib.request, websocket
pages = json.load(urllib.request.urlopen('http://127.0.0.1:9222/json'))
ws = websocket.create_connection(pages[0]['webSocketDebuggerUrl'], suppress_origin=True)
def ev(expr):
    ws.send(json.dumps({'id': 1, 'method': 'Runtime.evaluate', 'params': {'expression': expr, 'returnByValue': True}}))
    while True:
        r = json.loads(ws.recv())
        if r.get('id') == 1:
            return r.get('result', {}).get('result', {}).get('value')
if sys.argv[1] == 'setup':
    ev("localStorage.setItem('chat-demo:api-key','sk-test'); location.reload()")
else:
    print(json.dumps(ev("""(()=>{const cs=getComputedStyle(document.documentElement);const r=e=>e&&e.getBoundingClientRect().toJSON();
      const f=document.querySelector('#root > div');
      return {innerHeight, innerWidth, dpr:devicePixelRatio, vvHeight:visualViewport.height, vvTop:visualViewport.offsetTop,
        safeTop:cs.getPropertyValue('--safe-area-inset-top'), safeBottom:cs.getPropertyValue('--safe-area-inset-bottom'),
        frame:r(f), frameStyle:f&&f.getAttribute('style'), textarea:r(document.querySelector('textarea')),
        firstButton:r(document.querySelector('button')), active:document.activeElement&&document.activeElement.tagName, ua:navigator.userAgent}})()"""), indent=1))
