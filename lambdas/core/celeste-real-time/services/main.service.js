const {
    ApiGatewayManagementApiClient,
    PostToConnectionCommand,
} = require("@aws-sdk/client-apigatewaymanagementapi");
const josmejia2401js = require('josmejia2401-js');
const constants = require('../lib/constants');
const josmejia2401Js = require("josmejia2401-js");

exports.doAction = async function (event, context) {
    const traceID = josmejia2401js.commonUtils.getTraceID(event?.headers || {});
    josmejia2401js.logger.error({ message: { event, context }, requestId: traceID });

    try {
        const options = {
            requestId: traceID
        };
        const {
            body,
            requestContext: { routeKey, connectionId, domainName, stage },
            queryStringParameters = {},
        } = event;

        let response = josmejia2401js.responseHandler.successResponse("success");

        switch (routeKey) {
            case "$connect":
                const { username } = queryStringParameters;
                response = await onConnect(connectionId, username, options);
                break;
            case "$disconnect":
                response = await onDisconnect(connectionId, options);
                break;
            case "$default":
                break;
            //custom event
            case "message":
                const callbackUrl = `https://${domainName}/${stage}`;
                response = await onMessage(connectionId, body, callbackUrl);
                break;
            default:
                break;
        }
        return response;
    } catch (err) {
        josmejia2401js.logger.error({ message: err, requestId: traceID });
        return josmejia2401js.globalException.buildInternalError("No pudimos realizar la solicitud. Intenta más tarde, por favor.")
    }
}


const onConnect = async (connectionId, username, options) => {
    if (!connectionId) return;
    if (!username.includes("guest")) {
        const usernameResponse = await dynamoDBRepository.scan({
            expressionAttributeValues: {
                ":username": {
                    "S": `${username}`
                }
            },
            expressionAttributeNames: {
                "#username": "username"
            },
            projectionExpression: undefined,
            filterExpression: "#username=:username",
            limit: 1,
            lastEvaluatedKey: undefined,
            tableName: constants.TBL_USERS
        }, options);
        if (!usernameResponse) {
            return josmejia2401js.globalException.buildNotFoundError({});
        }
    }
    const response = await josmejia2401js.dynamoDBRepository.putItem({
        tableName: constants.TBL_SESSIONS,
        item: {
            connectionId: { S: `${connectionId}` },
            username: { S: `${username}` },
            createdAt: { S: `${new Date().toISOString()}` }
        }
    }, options);
    return josmejia2401js.responseHandler.successResponse({
        connectionId: response.connectionId.S,
        username: response.username.S,
        createdAt: response.createdAt.S
    });
};

const onDisconnect = async (connectionId, options) => {
    if (!connectionId) return;
    await josmejia2401js.dynamoDBRepository.deleteItem({
        tableName: constants.TBL_SESSIONS,
        item: {
            connectionId: { S: `${connectionId}` }
        }
    }, options);
    return josmejia2401js.responseHandler.successResponse({
        connectionId: connectionId
    });
};


const onMessage = async (connectionId, body, callbackUrl, options) => {
    if (!connectionId) {
        return;
    }
    if (typeof body != Object) {
        body = JSON.parse(body);
    }
    const { username, message } = body;

    const fromResponse = await dynamoDBRepository.getItem({
        key: {
            connectionId: {
                S: `${connectionId}`
            }
        },
        tableName: constants.TBL_SESSIONS
    }, options);
    if (!fromResponse) {
        return josmejia2401js.globalException.buildNotFoundError({});
    }
    const fromResponseData = {
        connectionId: fromResponse.connectionId?.S,
        username: fromResponse.username?.S,
        createdAt: fromResponse.createdAt?.S,
    }

    if (username === "chatbot") {
        //llamar lambda de chatbot y respuesta devolver
        const responseChatbot = "";
        const requestParams = {
            ConnectionId: fromResponseData.connectionId,
            Data: `{"from":"chatbot","to":"${fromResponseData.username}","message":"${responseChatbot}"}`,
        };
        const command = new PostToConnectionCommand(requestParams);
        const clientApi = new ApiGatewayManagementApiClient({
            endpoint: callbackUrl,
        });
        const resApi = await clientApi.send(command);
        josmejia2401Js.logger.info({ requestId: options.traceID, message: resApi });
    } else {
        const toResponse = await dynamoDBRepository.scan({
            expressionAttributeValues: {
                ":username": {
                    "S": `${username}`
                }
            },
            expressionAttributeNames: {
                "#username": "username"
            },
            projectionExpression: undefined,
            filterExpression: "#username=:username",
            limit: 1,
            lastEvaluatedKey: undefined,
            tableName: constants.TBL_SESSIONS
        }, options);

        if (toResponse.results.length > 0) {
            toResponse.results = toResponse.results.map(p => ({
                connectionId: p.connectionId?.S,
                username: p.username?.S,
                createdAt: p.createdAt?.S,
            }));
            const clientApi = new ApiGatewayManagementApiClient({
                endpoint: callbackUrl,
            });
            for (const result of toResponse.results) {
                const requestParams = {
                    ConnectionId: result.connectionId,
                    Data: `{"from":"${fromResponseData.username}","to":"${result.username}","message":"${message}"}`,
                };
                const command = new PostToConnectionCommand(requestParams);
                const resApi = await clientApi.send(command);
                josmejia2401Js.logger.info({ requestId: options.traceID, message: resApi });
            }
        }
    }
    return josmejia2401js.responseHandler.successResponse({
        connectionId: connectionId
    });
};