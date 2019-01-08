namespace java com.tuniu.pebble.thrift.model

/**
* A id boost to 128bit use two i64
**/
struct Uuid {
    /*
     * The most significant 64 bits of this UUID.
     */
    1: required i64 mostSigBits,

    /*
     * The least significant 64 bits of this UUID.
     */
    2: required i64 leastSigBits,
}


enum ErrorType {
     SERVICE_SOCKET_REFUSED = 20000,  ## socket链接拒绝
     SERVICE_SOCKET_BROKEN,           ## socket链接破损
     SERVICE_NOT_FOUND(),             ## 服务未发现
     SERVICE_FORBIDDEN,                ## 服务禁止访问
     SERVICE_RATE_LIMIT,              ## 服务速率限制
     SERVICE_TIMEOUT,                 ## 服务超时
     SERVICE_INTERNAL_ERROR,          ## 服务内部错误
     UNKONWN,                         ## 未知错误
 }

const map<i16,myConst> MAP_CONST = {1: "world", 2: "moon"}

struct myConst{
    1:i16 type,
    2:string message
}

exception PebbleTException {
    1: myConst type
}
