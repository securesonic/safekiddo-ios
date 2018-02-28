ReplayRequest is a NSURLRequest category which made you able to print your request as a curl request in your console or in a log file to be able to replay it, or send it to the back-end guy and hope he will find why his API raised 500 errors every time you call it! :-)

To use it, simply import the NSURLRequest+replayRequest.h where you need it and call the "curlRequest" method on your request.