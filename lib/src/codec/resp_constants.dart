// RESP2 constants
const int respSimpleString = 43; // '+'
const int respError = 45; // '-'
const int respInteger = 58; // ':'
const int respBulkString = 36; // '$'
const int respArray = 42; // '*'

//CRLF
const int respCarriageReturn = 13; // \r
const int respLineFeed = 10; // \n

// RESP3 constants
const int respBoolean = 35; // '#'
const int respDouble = 44; // ','
const int respNull = 95; // '_'
const int respMap = 37; // '%'
const int respSet = 126; // '~'
const int respBlobError = 33; // '!'
const int respPush = 62; // '>'
const int respVerbatimString = 61; // '='
const int respBigNumber = 40; // '('

// Valores booleanos (usados dentro del tipo booleano)
const int respTrue = 116; // 't'
const int respFalse = 102; // 'f'
