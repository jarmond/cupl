function cuplPrintStatus(message)
%CUPLPRINTSTATUS  Print time and a status message
%
%   CUPLANALYSEFILES(MESSAGE) Prints current time, followed by MESSAGE to the
%   command line.
%
% Copyright (c) 2010 Elina Vladimirou
% Copyright (c) 2013 Jonathan Armond

c = fix(clock);
fprintf('[%02d:%02d.%02d]: %s\n',c(4),c(5),c(6),message);
