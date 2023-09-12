import Debug "mo:base/Debug";
import Blob "mo:base/Blob";
import Cycles "mo:base/ExperimentalCycles";
import Error "mo:base/Error";
import Array "mo:base/Array";
import Nat8 "mo:base/Nat8";
import Nat64 "mo:base/Nat64";
import Text "mo:base/Text";
import JSON "mo:serde/JSON";

//import the custom types we have in Types.mo
import Types "Types";


//Actor
actor {
  
  public func get_gives() : async Text {

    let ic : Types.IC = actor ("aaaaa-aa");


    let start_timestamp : Types.Timestamp = 1682978460; //May 1, 2023 22:01:00 GMT
    let host : Text = "feathers-dot-fby-dev.uc.r.appspot.com";
    let url = "https://" # host # "/gives/?start_date=01%2F04%2F2023&end_date=16%2F08%2F2023";


    // 2.2 prepare headers for the system http_request call
    let request_headers = [
        { name = "Host"; value = host # ":443" },
        { name = "User-Agent"; value = "exchange_rate_canister" },
    ];

    // 2.3 The HTTP request
    let http_request : Types.HttpRequestArgs = {
        url = url;
        max_response_bytes = null; //optional for request
        headers = request_headers;
        body = null; //optional for request
        method = #get;
        transform = null; //optional for request
    };

    Cycles.add(220_131_200_000); //minimum cycles needed to pass the CI tests. Cycles needed will vary on many things size of http response, subnetc, etc...).

    let http_response : Types.HttpResponsePayload = await ic.http_request(http_request);
    
    let response_body: Blob = Blob.fromArray(http_response.body);
    let decoded_text: Text = switch (Text.decodeUtf8(response_body)) {
        case (null) { "No value returned" };
        case (?y) { y };
    };

    decoded_text
  };

};
