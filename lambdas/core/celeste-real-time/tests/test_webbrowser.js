//npm install ws
const WebSocket = require('ws');
const WEBSOCKET_API = "wss://0kgiwttbua.execute-api.us-east-1.amazonaws.com/dev";
function webSocketTest() {
    console.log("WebSocket is supported by your Browser!");
    const ws = new WebSocket(`${WEBSOCKET_API}?username=guest1`);
    ws.onopen = function () {
        console.log("onopen");
        ws.send(
            `{"username":"guest1", "msg":"hollaaaa"}`
        );
    };
    ws.onmessage = function (evt) {
        console.log("onmessage", evt);
        // trigger when websocket received message
    };

    ws.onclose = function () {
        console.log("onclose");
        // trigger when connection get closed
    };

    ws.onerror = function (error) {
        console.log("error", error);
        // trigger when connection get closed
    };
}
webSocketTest();

