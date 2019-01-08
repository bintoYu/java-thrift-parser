include "PebbleModel.thrift"
include "PebbleService.thrift"

/**
 * Thrift files can namespace, package, or prefix their output in various
 * target languages.
 */
namespace java com.tuniu.pebble.example.thrift

/**
 * Thrift lets you do typedefs to get pretty names for your types. Standard
 * C style here.
 */
typedef i32 MyInteger

/**
 * Thrift also lets you define constants for use across languages. Complex
 * types and structs are specified using JSON notation.
 */
const i32 INT32CONSTANT = 9853
const map<string,string> MAPCONSTANT = {'hello':'world', 'goodnight':'moon'}

/**
 * You can define enums, which are just 32 bit integers. Values are optional
 * and start at 1 if not supplied, C style again.
 */
enum Operation {
  ADD = 1,
  SUBTRACT = 2,
  MULTIPLY = 3,
  DIVIDE = 4
}

/**
 * Structs are the basic complex data structures. They are comprised of fields
 * which each have an integer identifier, a env, a symbolic name, and an
 * optional default value.
 *
 * Fields can be declared "optional", which ensures they will not be included
 * in the serialized output if they aren't set.  Note that this requires some
 * manual management in some languages.
 */
struct Work {
  1: required MyInteger num1 = 0,
  2: required i32 num2,
  3: required Operation op,
  4: optional string comment,
}

/**
 * Structs can also be exceptions, if they are nasty.
 */
exception InvalidOperation {
  1: i32 whatOp,
  2: string why
}

struct SubObj {
    2: optional bool on,
    3: optional byte bt,
    4: optional double valueD,
    6: optional i16 valueShord,
    8: optional i32 valueInt,
    10: optional i64 valueLong,
    11: optional string name,
    12: optional Work work,
//    13: optional map<map<i32, Work>, map<i32, Work>> smap,
    14: optional set<Work> simpleSet,
    15: optional list<Work> simpleList,
    16: optional Operation op,
}

struct DemoObj {
    2: optional bool on,
    3: optional byte bt,
    4: optional double valueD,
    6: optional i16 valueShord,
    8: optional i32 valueInt,
    10: optional i64 valueLong,
    11: optional string name,
    12: optional SubObj subObj,
//    13: optional map<string, map<Work, SubObj>> smap,
    14: optional set<SubObj> simpleSet,
    15: optional list<SubObj> simpleList,
    16: optional Operation op,
}

struct defaultObj {
    2: optional bool on = true,
    3: optional byte bt = 1,
    4: optional double valueD = 1,
    6: optional i16 valueShord = 1,
    8: optional i32 valueInt = 1,
    10: optional i64 valueLong = 1,
    11: optional string name = '2',
    12: optional SubObj subObj = {},
//    13: optional map<string, map<Work, SubObj>> smap,
    14: optional set<SubObj> simpleSet,
    15: optional list<SubObj> simpleList,
    16: optional Operation op,
}

struct DemoResult {
    1: required bool success,
    2: required i32 count,
    3: optional list<DemoObj> objList,
}

/**
 * Ahh, now onto the cool part, defining a service. Services just need a name
 * and can optionally inherit from another service using the extends keyword.
 */
service Calculator extends PebbleService.SharedService{


    /**
    * This is a operator of add two number
    **/
   i32 add(1:i32 num1, 2:i32 num2) throws (1: PebbleModel.PebbleTException pte),

   i32 calculate(1:i32 logid, 2:Work w) throws (1:InvalidOperation ouch),

   i32 noPebbleTExceptionMethod(1: i32 id),

   i32 withPebbleTExceptionMethod(1: i32 id) throws (1: PebbleModel.PebbleTException pte),
   /**
    * This method has a oneway modifier. That means the client only makes
    * a request and does not listen for any response at all. Oneway methods
    * must be void.
    */
   oneway void zip(),

   DemoResult complex(1: DemoObj obj) throws (1: PebbleModel.PebbleTException pte, 2: InvalidOperation ipe),

}