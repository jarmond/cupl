function idx=indexOfAccepted(analysis,i)
% INDEXOFACCEPTED Return indexes of accepted sisters for cell i.

idx = find(analysis.acceptedSisters & analysis.sisterCellIdx == i);